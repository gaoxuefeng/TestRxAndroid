# -*- coding: utf-8 -*-
'''
Created on 2015年9月8日

@author: li.zheshen
'''


from __future__ import absolute_import
from CeleryTask.celery import EthankCeleryBaseTask
from CeleryTask.celery import celery_app
from CeleryTask.celery import db_session
from CeleryTask.celery import redis_activity_pool
from CeleryTask.celery import redis_cache_pool
from CeleryTask.MysqlTables.t_user import TUser
from CeleryTask.EthankSMS.ethank_sms import ethank_sms
from CeleryTask.EthankPay.ethank_ali_pay import EthankAliPay
from CeleryTask.MysqlTables.SeckillTables.t_activity_goods \
    import TActivityGoods
from CeleryTask.MysqlTables.SeckillTables.t_activity_seckill_vip \
    import TActivitySeckillVip
from CeleryTask.MysqlTables.SeckillTables.t_activity_win_record \
    import TActivityWinRecord
from CeleryTask.EthankCrypto.ethank_token_crypto import ethank_token_crypto
from CeleryTask.DataCaches.data_cacher import DataCacher
from CeleryTask import settings as conf
import redis
import time
import datetime
from CeleryTask.EthankUtil.ethank_util_time import EthankUtilTime
from CeleryTask.settings import redis_activity_db
from sqlalchemy import Column, DateTime, String, Integer, ForeignKey, func
from celery.utils.log import get_task_logger
logger = get_task_logger(__name__)


def check_token(token, session):
    ret = None
    plain_token = None
    try:
        cacher = DataCacher(redis.StrictRedis(connection_pool=redis_cache_pool))
        crypto = ethank_token_crypto()
        plain_token = crypto.decrypt(token)
        logger.info(plain_token)
    except Exception, e:
        logger.info(e)

    if plain_token:
        user = None
        try:
            user_id, _ = plain_token.split(":")
        except:
            user_id = ""
        if user_id:
            cache_key = "t_user@id:{}".format(user_id)
            logger.info(cache_key)
            user = cacher.cache_get(cache_key)
            if not user:
                user = session.query(TUser)\
                 .filter(TUser.id == user_id).scalar()
        if user:
            cacher.cache_set(cache_key, user)
            ret = user_id
    return ret


@celery_app.task
def sync_time_task():
    ret_microsec = 24*3600*1000
    now = datetime.datetime.now()
    now_microsec = now.hour*3600*1000 + \
        now.minute*60*1000 + \
        now.second*1000 + \
        now.microsecond/1000
    sub_microsecond = conf.seckill_start_microsecond - now_microsec
    if sub_microsecond > 0:
        ret_microsec = sub_microsecond
    else:
        ret_microsec = ret_microsec + sub_microsecond
    return ret_microsec


@celery_app.task(base=EthankCeleryBaseTask)
def seckill_task(token):
    ret_json = {"pay_url": "", "status": 0}
    ok = True
    now = datetime.datetime.now()
    now_microsec = now.hour*3600*1000 + \
        now.minute*60*1000 + \
        now.second*1000 + \
        now.microsecond/1000
    sub_microsecond = conf.seckill_start_microsecond - now_microsec
    if ok:
        if sub_microsecond > 0:
            ok = False
    if ok:
        activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
        time_str = EthankUtilTime.get_today_str()
        status = activity_con.get(conf.seckill_status)
        if status != "1":
            ok = False
            logger.info("hack attack!")
    if ok:
        user_id = check_token(token, db_session)
        clicks = activity_con.hincrby(conf.seckill_users+time_str, user_id, 1)
        if clicks != 1:
            ok = False
    if ok:
        prize_user_exists = activity_con.hexists(conf.seckill_winers,user_id)
        if prize_user_exists:
            ok = False
    if ok:
        goods_id = None
        is_vip = activity_con.hexists(conf.seckill_vips+time_str, user_id)
        if is_vip:
            goods_id = activity_con.lpop(conf.seckill_goods_vip+time_str)
        else:
            goods_id = activity_con.lpop(conf.seckill_goods_normal+time_str)
        if not goods_id:
            ok = False
        if  activity_con.llen(conf.seckill_goods_vip+time_str) ==0 and \
            activity_con.llen(conf.seckill_goods_normal+time_str) == 0:
            activity_con.set(conf.seckill_status, "0")
            
    if ok:
        ali_pay = EthankAliPay()

        goods = db_session.query(TActivityGoods)\
                     .filter(TActivityGoods.goods_id == goods_id)\
                     .one()
        user = db_session.query(TUser)\
                     .filter(TUser.id == user_id)\
                     .one()
        if goods:
            ali_pay.set_notify_url(conf.seckill_ali_notify_url)
            ali_pay.set_return_url(conf.seckill_ali_return_url)
            ali_pay.set_total_pay(conf.seckill_pay_cost)
            ali_pay.set_order_id(goods.goods_order_id)
            pay_url = ali_pay.build_link()
            goods.goods_status = 1
            win_rec = TActivityWinRecord() 
            win_rec.wim_record_sequence = activity_con.hlen(conf.seckill_winers)+1
            activity_con.hincrby(conf.seckill_winers, user.id, 1)
            win_rec.win_record_activity_id = 1 
            win_rec.win_record_address = ""
            win_rec.win_record_nick_name = user.nick_name
            win_rec.win_record_note = ""
            win_rec.win_record_order_id = goods.goods_order_id
            win_rec.win_record_out_order_id = ""
            win_rec.win_record_pay_status = 0
            win_rec.win_record_pay_url = pay_url
            win_rec.win_record_phone = user.phone_num
            win_rec.win_record_time = \
                time.strftime("%Y年%m月%d日", time.localtime(time.time()))
            win_rec.win_record_user_id = user.id
            win_rec.win_record_verify_code = goods.goods_verify_code
            db_session.add(win_rec)
            db_session.commit()            
            ret_json["pay_url"] = pay_url
            ret_json["status"] = 1
    return ret_json


@celery_app.task(base=EthankCeleryBaseTask)
def get_winer_list_task():
    activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
    cacher = DataCacher(redis.StrictRedis(connection_pool=redis_cache_pool))
    winer_list = activity_con.hkeys(conf.seckill_winers)
    ret_json = []
    for winer_id in winer_list:
        cache_key = "t_activity_win_record@id:{}".format(winer_id)
        win_rec = None
        winer_dict = {}
        try:
            win_rec = cacher.cache_get(cache_key)
            logger.info(winer_id)
            if not win_rec:
                win_rec = db_session.query(TActivityWinRecord)\
                 .filter(TActivityWinRecord.win_record_user_id == winer_id)\
                 .one()
                if win_rec:
                    cacher.cache_set(cache_key, win_rec)
            if win_rec and win_rec.win_record_pay_status == 2:
                winer_dict["datetime"] = win_rec.win_record_time
                winer_dict["nick_name"] = win_rec.win_record_nick_name
                ret_json.append(winer_dict)

        except Exception, e:
            logger.info(e)
    
    return ret_json


@celery_app.task(base=EthankCeleryBaseTask)
def get_status_task(token):
    time_str = EthankUtilTime.get_today_str()
    ret_status = 0
    is_exist = False
    user_id = None
    try:
        activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
        status = activity_con.get(conf.seckill_status)
        user_id = check_token(token, db_session)
        if user_id:
            is_exist = activity_con.hexists(conf.seckill_users+time_str,
                                            user_id)
    except Exception, e:
        logger.info(e)
    if user_id and not is_exist:
        if status == "0":
            ret_status = 0
        elif status == "1":
            ret_status = 1
        elif status == "2":
            ret_status = 2
        else:
            ret_status = 0

    return ret_status


@celery_app.task(base=EthankCeleryBaseTask)
def get_details_task(token):
    ret_json = {"datetime": "",
                "ordinal": 0,
                "pay_url": "",
                "status": 0,
                "tel": "",
                "verify_code": ""}
    user_id = check_token(token, db_session)
    if user_id:
        activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
        is_exist = activity_con.hexists(conf.seckill_winers, user_id)
        if is_exist:
            cacher = DataCacher(redis.StrictRedis(connection_pool=
                                                   redis_cache_pool))
            cache_key = "t_activity_win_record@id:{}".format(user_id)
            win_rec = cacher.cache_get(cache_key)
            if not win_rec:
                win_rec = db_session.query(TActivityWinRecord)\
                 .filter(TActivityWinRecord.win_record_user_id == user_id)\
                 .one()
                if win_rec:
                    cacher.cache_set(cache_key, win_rec)
                    # 待支付
            if win_rec:
                if win_rec.win_record_pay_status == 0:
                    ret_json["status"] = 1
                    ret_json["datetime"] = win_rec.win_record_time
                    ret_json["ordinal"] = win_rec.win_record_sequence
                    ret_json["pay_url"] = win_rec.win_record_pay_url
                    ret_json["tel"] = win_rec.win_record_phone
                # 支付失败
                elif win_rec.win_record_pay_status == 1:
                    ret_json["status"] = 2
                    ret_json["datetime"] = win_rec.win_record_time
                    ret_json["ordinal"] = win_rec.win_record_sequence
                    ret_json["tel"] = win_rec.win_record_phone
                # 支付成功
                elif win_rec.win_record_pay_status == 2:
                    ret_json["status"] = 3
                    ret_json["datetime"] = win_rec.win_record_time
                    ret_json["ordinal"] = win_rec.win_record_sequence
                    ret_json["tel"] = win_rec.win_record_phone
                    ret_json["verify_code"] = \
                        win_rec.win_record_verify_code
    return ret_json


@celery_app.task(base=EthankCeleryBaseTask)
def seckill_end():
    activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
    # 设置活动初始状态
    activity_con.set(conf.seckill_status, "2")


@celery_app.task(base=EthankCeleryBaseTask)
def seckill_start():
    activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
    # 设置活动初始状态
    activity_con.set(conf.seckill_status, "1")


@celery_app.task(base=EthankCeleryBaseTask)
def seckill_init():
    time_str = EthankUtilTime.get_today_str()
    activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
    # 设置活动初始状态
    activity_con.set(conf.seckill_status, "0")
    # 初始化奖品列表
    goods_list = db_session.query(TActivityGoods)\
        .filter(TActivityGoods.goods_group == 1,
                TActivityGoods.goods_activity_date <= func.now(),
                TActivityGoods.goods_status != 2).all()
                
    activity_con.delete(conf.seckill_goods_normal+time_str)
    activity_con.delete(conf.seckill_goods_vip+time_str)
    activity_con.delete(conf.seckill_vips+time_str)
    for goods in goods_list:
        if goods:
            if goods.goods_prize_pool == 0:
                activity_con.lpush(conf.seckill_goods_normal+time_str,
                                  goods.goods_id)
            elif goods.goods_prize_pool == 1:
                activity_con.lpush(conf.seckill_goods_vip+time_str,
                                  goods.goods_id)
    # 初始化vip表
    vip_list = db_session.query(TActivitySeckillVip)\
        .filter(TActivitySeckillVip.seckill_vip_date == time_str).all()
    for vip in vip_list:
        if vip:
            user_id = vip.seckill_vip_user_id
            activity_con.hincrby(conf.seckill_vips+time_str, user_id, 0)


@celery_app.task(base=EthankCeleryBaseTask)
def seckill_notify_url(order_id, ali_order_id):
    activity_con = redis.StrictRedis(connection_pool=redis_activity_pool)
    
    win_rec = db_session.query(TActivityWinRecord)\
        .filter(TActivityWinRecord.win_record_order_id == order_id,
                TActivityWinRecord.win_record_activity_id == 1).one()
    goods = db_session.query(TActivityGoods)\
             .filter(TActivityGoods.goods_order_id == order_id)\
             .one()
    goods.goods_status = 2
    win_rec.win_record_pay_status = 2
    win_rec.win_record_order_id = order_id
    win_rec.win_record_out_order_id = ali_order_id
    db_session.commit()
    user_id = win_rec.win_record_user_id
    tel = win_rec.win_record_phone
    win_record_time = win_rec.win_record_time
    verify_code = win_rec.win_record_verify_code
    sequence = win_rec.win_record_sequence
    cache_key = "t_activity_win_record@id:{}".format(user_id)
    cacher = DataCacher(redis.StrictRedis(connection_pool=redis_cache_pool))
    cacher.cache_del(cache_key)
    sms = ethank_sms()
    content = "潮趴汇喜您成功秒杀“真●我巅峰”演唱会门票2张。您的抢票验证码为"+\
                verify_code.encode("UTF-8")+\
                "，演唱会时间：2015年9月22日19：20。"+\
                "请在演唱会开始前80分钟到北京国家体育馆鸟巢“潮趴汇领票处”凭验证码领取门票，"+\
                "找不到人请拨：18561601603"

    logger.info("__________________begin _____________________")
    logger.info("content:"+content)
    logger.info("tel:"+tel)
    logger.info("___________________end_______________________")
    sms.send_sms(tel.encode("utf-8"), content)
    logger.info("_____________________________________________")

