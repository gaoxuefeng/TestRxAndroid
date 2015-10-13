# -*- coding: utf-8 -*-
'''
Created on 2015年9月10日

@author: li.zheshen
'''

import tornado
import CeleryTask.seckill_tasks


class SyncTimeHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def get(self):
        CeleryTask.seckill_tasks.sync_time_task.\
            apply_async(args=[], callback=self.on_sync_time_result)

    @tornado.web.asynchronous
    def post(self):
        CeleryTask.seckill_tasks.sync_time_task.\
            apply_async(args=[], callback=self.on_sync_time_result)

    def on_sync_time_result(self, data):
        ret_data = {"time_ticket": 24*60*60*1000}
        try:
            ret_data["time_ticket"] = data.result
        except Exception, e:
            print e
        self.write(ret_data)
        self.finish()
