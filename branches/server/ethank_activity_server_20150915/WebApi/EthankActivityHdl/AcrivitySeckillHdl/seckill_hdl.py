# -*- coding: utf-8 -*-
'''
Created on 2015年9月10日

@author: li.zheshen
'''

import tornado
from CeleryTask.seckill_tasks import seckill_task


class SeckillHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def get(self):
        token = self.get_argument("token", "")
        seckill_task.apply_async(args=[token],
                                 callback=self.on_seckill_result)

    @tornado.web.asynchronous
    def post(self):
        token = self.get_argument("token", "")
        seckill_task.apply_async(args=[token],
                                 callback=self.on_seckill_result)

    def on_seckill_result(self, data):
        ret_data = {"status": 0,
                    "pay_url": ""}
        try:
            ret_data["pay_url"] = data.result["pay_url"]
            ret_data["status"] = data.result["status"]
        except Exception, e:
            print e
        self.write(ret_data)
        self.finish()
