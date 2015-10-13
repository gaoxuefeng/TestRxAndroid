# -*- coding: utf-8 -*-
'''
Created on 2015年9月11日

@author: li.zheshen
'''
import unittest
from CeleryTask.DataCaches.data_cacher import DataCacher


class DataCacherTest(unittest.TestCase):

    def test_tidy_key(self):
        data_cacher = DataCacher("")
        t_key = data_cacher._tidy_key("dddd@111@www@ssss")
        self.assertEqual("111ddddsssswww", t_key, "")
        t_key = data_cacher._tidy_key("dddd@")
        self.assertEqual("dddd", t_key, "")
        t_key = data_cacher._tidy_key("dddd")
        self.assertEqual("dddd", t_key, "")
        t_key = data_cacher._tidy_key("")
        self.assertEqual("", t_key, "")


if __name__ == "__main__":

    unittest.main()
