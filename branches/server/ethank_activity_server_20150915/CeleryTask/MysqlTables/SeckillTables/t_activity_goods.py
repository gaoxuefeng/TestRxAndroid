# -*- coding: utf-8 -*-
'''
Created on 2015年9月13日

@author: li.zheshen
'''
# 导入:
from sqlalchemy import Column, String, Integer, TIMESTAMP, DateTime

from sqlalchemy.ext.declarative import declarative_base


# 创建对象的基类:
Base = declarative_base()


# 定义User对象:
class TActivityGoods(Base):
    # 表的名字:
    __tablename__ = 't_activity_goods'

    # 表的结构:
    goods_id = Column(Integer(), primary_key=True)
    goods_group = Column(Integer())
    goods_name = Column(String(255))
    goods_status = Column(Integer())
    goods_prize_pool = Column(Integer())
    goods_order_id = Column(String(255))
    goods_verify_code = Column(String(255))
    goods_activity_date = Column(DateTime())
