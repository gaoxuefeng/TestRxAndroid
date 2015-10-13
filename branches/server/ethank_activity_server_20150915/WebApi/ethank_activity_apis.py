# -*- coding: utf-8 -*-
'''
Created on 2015年6月8日

@author: li.zheshen
'''
from WebApi.EthankActivityHdl.AcrivitySeckillHdl.get_details_hdl\
 import GetDetailsHandler
from WebApi.EthankActivityHdl.AcrivitySeckillHdl.get_status_hdl\
 import GetStatusHandler
from WebApi.EthankActivityHdl.AcrivitySeckillHdl.get_winer_list_hdl\
 import GetWinerListHandler
from WebApi.EthankActivityHdl.AcrivitySeckillHdl.seckill_hdl\
 import SeckillHandler
from WebApi.EthankActivityHdl.AcrivitySeckillHdl.sync_time_hdl\
 import SyncTimeHandler
from WebApi.EthankActivityHdl.AcrivitySeckillHdl.notify_url_hdl\
 import NotifyUrlHandler


class ethank_activity_apis(object):

    def __init__(self):
        self.apis = []
        self._define_ethank_apis()

    def get_api_list(self):
        return self.apis

    def _add_activity_seckill_api(self):
        get_details_api = (r"/activity/seckill/get_details.v1",
                           GetDetailsHandler)
        get_status_api = (r"/activity/seckill/get_status.v1",
                          GetStatusHandler)
        get_winer_list_api = (r"/activity/seckill/get_winer_list.v1",
                              GetWinerListHandler)
        seckill_api = (r"/activity/seckill/do_it.v1",
                       SeckillHandler)
        sync_time_api = (r"/activity/seckill/sync_time.v1",
                         SyncTimeHandler)
        notify_url_api = (r"/activity/seckill/notify",
                          NotifyUrlHandler)

        self.apis.append(get_details_api)
        self.apis.append(get_status_api)
        self.apis.append(get_winer_list_api)
        self.apis.append(seckill_api)
        self.apis.append(sync_time_api)
        self.apis.append(notify_url_api)

    def _define_ethank_apis(self):
        self._add_activity_seckill_api()
