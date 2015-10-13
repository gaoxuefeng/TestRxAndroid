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
class TActivityWinRecord(Base):
    # 表的名字:
    __tablename__ = 't_activity_win_record'

    # 表的结构:
    win_record_id = Column(Integer(), primary_key=True)
    win_record_activity_id = Column(Integer())
    win_record_user_id = Column(Integer())
    win_record_order_id = Column(String(255))
    win_record_out_order_id = Column(String(255))
    win_record_nick_name = Column(String(255))
    win_record_time = Column(String(255))
    win_record_sequence = Column(Integer())
    win_record_note = Column(String(255))
    win_record_phone = Column(String(255))
    win_record_address = Column(String(255))
    win_record_pay_url = Column(String(255))
    win_record_pay_status = Column(Integer())
    win_record_verify_code = Column(String(255))
