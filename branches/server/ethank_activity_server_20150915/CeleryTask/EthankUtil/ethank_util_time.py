# -*- coding: utf-8 -*-
'''
Created on 2015年9月13日

@author: li.zheshen
'''
import time


class EthankUtilTime(object):
    def __init__(self):
        pass

    @staticmethod
    def get_today_str():
        time_str = time.strftime("%Y_%m_%d", time.localtime(time.time()))
        return time_str
