# -*- coding: utf-8 -*-
'''
Created on 2015年6月8日

@author: li.zheshen
'''
from tornado.options import define, options
import tornado.ioloop
import tornado.web
from WebApi.ethank_activity_apis import ethank_activity_apis
import tcelery


if __name__ == "__main__":
    define("debug", default=True, help="switch to debug mode", type=bool)

    define("port", default=8080, help="run on the given port", type=int)

    tornado.options.parse_command_line()

    settings = {'debug': options.debug}

    apis = ethank_activity_apis()

    application = tornado.web.Application(apis.get_api_list(), **settings)

    application.listen(options.port)

    tcelery.setup_nonblocking_producer()

    tornado.ioloop.IOLoop.instance().start()
