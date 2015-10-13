# -*- coding: utf-8 -*-
'''
Created on 2015年6月8日

@author: li.zheshen
'''
from CeleryTask.seckill_tasks import check_token
import unittest


class SeckillTaskTestCase(unittest.TestCase):
    def test_check_token(self):
        # check_token("a22f665f864c8d55")
        check_token("c76eebec9bf2a9d0")
        #check_token("c76dfdfdfdfdf")

if __name__ == '__main__':
    unittest.main()
