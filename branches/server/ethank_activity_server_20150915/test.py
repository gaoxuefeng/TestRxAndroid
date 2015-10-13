# -*- coding: utf-8 -*-
'''
Created on 2015年9月11日

@author: li.zheshen
'''

from tornado import gen
from tornado import ioloop
from tornado.web import asynchronous, RequestHandler, Application

from CeleryTask.seckill_tasks import sync_time_task

import tcelery
tcelery.setup_nonblocking_producer()


class AsyncHandler(RequestHandler):
    @asynchronous
    def get(self):
        sync_time_task.apply_async(args=[], callback=self.on_result)

    def on_result(self, response):
        self.write(str(response.result))
        self.finish()




application = Application([
    (r"/async-sleep", AsyncHandler)
])


if __name__ == "__main__":
    application.listen(8887)
    ioloop.IOLoop.instance().start()