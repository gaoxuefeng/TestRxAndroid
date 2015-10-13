# -*- coding: utf-8 -*-
'''
Created on 2015年9月10日

@author: li.zheshen
'''

import tornado
from CeleryTask.seckill_tasks import get_status_task


class GetStatusHandler(tornado.web.RequestHandler):

    @tornado.web.asynchronous
    def get(self):
        token = self.get_argument("token", "")
        get_status_task.apply_async(args=[token],
                                    callback=self.on_get_status_result)

    @tornado.web.asynchronous
    def post(self):
        token = self.get_argument("token", "")
        get_status_task.apply_async(args=[token],
                                    callback=self.on_get_status_result)

    def on_get_status_result(self, data):
        ret_data = {"activity_status": 0}
        try:
            ret_data["activity_status"] = data.result
        except Exception, e:
            print e
        if not ret_data:
            ret_data = 0
        self.write(ret_data)
        self.finish()
