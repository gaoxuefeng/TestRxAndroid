# -*- coding: utf-8 -*-
'''
Created on 2015年9月8日

@author: li.zheshen
'''

# mysql链接url
#测试mysql
#mysql_con_url = "mysql://yungecenter:YungeMysql345@10.51.78.240:3306/yungecenter?charset=utf8"
#外网测试mysql
#mysql_con_url = "mysql://yungetest:YgCentER489@123.57.231.228:3306/yungecenter?charset=utf8"
#正式环境mysql
mysql_con_url = "mysql://yungecenter:YungeMysql345@10.51.89.11:3306/yungecenter?charset=utf8"
# celery设置broker链接url
celery_broker_con_url = "amqp://celery:celeryadmin@127.0.0.1:5672/activity"

# celery设置后端url
celery_backend_con_url = "redis://127.0.0.1:5001/0"

# 缓存redis主机名
redis_cache_host = "127。0.0.1"

# 缓存redis端口
redis_cache_port = 3001

# 缓存redis数据库
redis_cache_db = 0

# 活动redis主机名
redis_activity_host = "127.0.0.1"

# 活动redis端口
redis_activity_port = 4001

# 活动redis数据库
redis_activity_db = 0

# 每天秒杀活动开始时间
seckill_start_microsecond = (10*3600)*1000

# 秒杀，活动redis使用key字符串
seckill_status = "activity_seckill_status_string"
seckill_goods_normal = "activity_seckill_goods_normal_list"
seckill_goods_vip = "activity_seckill_goods_vip_list"
seckill_users = "activity_seckill_goods_users_hash"
seckill_vips = "activity_seckill_vip_set"
seckill_winers = "activity_seckill_winers_hash"

# 支付宝通知链接
seckill_ali_notify_url = "http://testyunge.ethank.com.cn/activity/seckill/notify"
seckill_ali_return_url = "http://testyunge.ethank.com.cn/activity/static/seckill/secKill.html"

seckill_pay_cost = '1'
