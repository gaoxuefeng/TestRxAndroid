# -*- coding: utf-8 -*-
'''
Created on 2015年9月14日

@author: li.zheshen
'''

import tornado
from CeleryTask.seckill_tasks import seckill_notify_url


class NotifyUrlHandler(tornado.web.RequestHandler):
    def post(self):
        out_trade_no = self.get_argument("out_trade_no", default="")
        trade_no = self.get_argument("trade_no", default="")
        result = self.get_argument("trade_status", default="")
        print "notifymsg:"
        print result
        if result == "TRADE_SUCCESS" or result == "TRADE_FINISHED":
            seckill_notify_url.\
                apply_async(args=[out_trade_no, trade_no],callback=None)
        self.write("success")