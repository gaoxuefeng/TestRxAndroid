# -*- coding: utf-8 -*-
'''
Created on 2015年9月13日

@author: li.zheshen
'''
# 导入:
from sqlalchemy import Column, String, Integer, TIMESTAMP, Date

from sqlalchemy.ext.declarative import declarative_base


# 创建对象的基类:
Base = declarative_base()


# 定义User对象:
class TActivitySeckillVip(Base):
    # 表的名字:
    __tablename__ = 't_activity_seckill_vip'

    # 表的结构:
    seckill_vip_id = Column(Integer(), primary_key=True)
    seckill_vip_user_id = Column(Integer())
    seckill_vip_date = Column(String(255))
