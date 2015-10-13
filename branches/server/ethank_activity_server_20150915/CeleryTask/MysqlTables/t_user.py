# -*- coding: utf-8 -*-
'''
Created on 2015年9月8日

@author: li.zheshen
'''
# 导入:
from sqlalchemy import Column, String, Integer, TIMESTAMP, Date

from sqlalchemy.ext.declarative import declarative_base


# 创建对象的基类:
Base = declarative_base()


# 定义User对象:
class TUser(Base):
    # 表的名字:
    __tablename__ = 't_user'

    # 表的结构:
    id = Column(Integer(), primary_key=True)
    nick_name = Column(String(50))
    age = Column(Integer())
    gender = Column(Integer())
    phone_num = Column(String(15))
    head_url = Column(String(200))
    state = Column(Integer())
    password = Column(String(32))
    dynamic_pw = Column(String(30))
    register_time = Column(TIMESTAMP())
    constellation = Column(Integer())
    bloodtype = Column(Integer())
    level = Column(Integer())
    love_singers = Column(String(500))
    love_songs = Column(String(500))
    what_is_up = Column(String(1000))
    used_happy_bean = Column(Integer())
    countinous_sign_day = Column(Integer())
    has_happy_bean = Column(Integer())
    login_time = Column(Date())
    has_times = Column(Integer())
