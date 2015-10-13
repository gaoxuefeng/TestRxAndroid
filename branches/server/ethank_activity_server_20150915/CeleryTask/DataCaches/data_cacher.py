# -*- coding: utf-8 -*-
'''
Created on 2015年9月11日

@author: li.zheshen
'''
import pickle


class DataCacher(object):

    def __init__(self, redis_con):
        self.con = redis_con

    def cache_set(self, key, obj):
        dump_obj = ""
        try:
            if obj:
                dump_obj = pickle.dumps(obj)
            if key:
                t_key = self._tidy_key(key)
                self.con.set(t_key, dump_obj, ex=6*60*60)
        except Exception, e:
            print e

    def cache_get(self, key):
        obj = None
        dump_obj = None
        try:
            if key:
                t_key = self._tidy_key(key)
                dump_obj = self.con.get(t_key)
            if dump_obj:
                obj = pickle.loads(dump_obj)
        except Exception, e:
            print e
        return obj

    def cache_del(self, key):
        if key:
            try:
                t_key = self._tidy_key(key)
                self.con.delete(t_key)
            except Exception, e:
                print e

    def _tidy_key(self, key):
        t_key = ""
        try:
            key_lst = key.split("@")
            key_lst.sort()
            t_key = ''.join(key_lst)
        except Exception, e:
            print e
        finally:
            return t_key
