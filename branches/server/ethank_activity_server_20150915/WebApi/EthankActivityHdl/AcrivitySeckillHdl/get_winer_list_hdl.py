# -*- coding: utf-8 -*-
'''
Created on 2015年9月10日

@author: li.zheshen
'''

import tornado
from CeleryTask.seckill_tasks import get_winer_list_task


class GetWinerListHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def get(self):
        get_winer_list_task.apply_async(args=[],
                                        callback=self.on_get_winer_list_result)

    @tornado.web.asynchronous
    def post(self):
        get_winer_list_task.apply_async(args=[],
                                        callback=self.on_get_winer_list_result)

    def on_get_winer_list_result(self, data):
        ret_data = {"winer_list": {}}
        try:
            ret_data["winer_list"] = data.result
        except Exception, e:
            print e
        self.write(ret_data)
        self.finish()
