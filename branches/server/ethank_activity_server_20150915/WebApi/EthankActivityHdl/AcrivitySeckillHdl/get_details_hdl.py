# -*- coding: utf-8 -*-
'''
Created on 2015年9月10日

@author: li.zheshen
'''

import tornado
from CeleryTask.seckill_tasks import get_details_task


class GetDetailsHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def get(self):
        token = self.get_argument("token", "")
        get_details_task.apply_async(args=[token],
                                     callback=self.on_get_details_result)

    @tornado.web.asynchronous
    def post(self):
        token = self.get_argument("token", "")
        get_details_task.apply_async(args=[token],
                                     callback=self.on_get_details_result)

    def on_get_details_result(self, data):
        ret_data = {"datetime": "",
                    "pay_url": "",
                    "status": 0,
                    "tel": "",
                    "verify_code": ""}
        try:
            ret_data["datetime"] =  data.result["datetime"]
            ret_data["pay_url"] =  data.result["pay_url"]
            ret_data["status"] =  data.result["status"]
            ret_data["tel"] =  data.result["tel"]
            ret_data["verify_code"] =  data.result["verify_code"]
        except Exception, e:
            print e
        self.write(ret_data)
        self.finish()
