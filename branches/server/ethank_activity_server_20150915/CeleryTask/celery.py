# -*- coding: utf-8 -*-
'''
Created on 2015年6月8日

@author: li.zheshen
'''

from __future__ import absolute_import
import celery
from celery.schedules import crontab
import redis
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
import CeleryTask.settings as conf


celery_app = celery.Celery('CeleryTask',
                           broker=conf.celery_broker_con_url,
                           backend=conf.celery_backend_con_url,
                           include=['CeleryTask.seckill_tasks'])
celery_schedule = {
                       "seckill_start": {
                               "task": "CleryTask.seckill_tasks.seckill_start",
                               "schedule": crontab(month_of_year=9,
                                                   day_of_month="16-18",
                                                   hour=10,
                                                   minute=0),
                               "args": (),
                               },
                       "seckill_init": {
                               "task": "CleryTask.seckill_tasks.seckill_init",
                               "schedule": crontab(month_of_year=9,
                                                   day_of_month=14,
                                                   hour=10,
                                                   minute=1),
                               "args": (),
                               }
            }

celery_app.conf.update(CELERY_TASK_RESULT_EXPIRES=1200,
                       CELERYD_CONCURRENCY=50,
                       CELERYD_PREFETCH_MULTIPLIER=4,
                       CELERYD_MAX_TASKS_PER_CHILD=400,
                       CELERYD_TASK_TIME_LIMIT=1800,
                       CELERY_REDIS_MAX_CONNECTIONS=1000,
                       CELERYBEAT_SCHEDULE=celery_schedule)


engine = create_engine(conf.mysql_con_url)

db_session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))

redis_cache_pool = redis.ConnectionPool(host=conf.redis_cache_host,
                                        port=conf.redis_cache_port,
                                        db=conf.redis_cache_db)

redis_activity_pool = redis.ConnectionPool(host=conf.redis_activity_host,
                                           port=conf.redis_activity_port,
                                           db=conf.redis_activity_db)


class EthankCeleryBaseTask(celery.Task):
    abstruct = True

    def after_return(self, status, retval, task_id, args, kwargs, einfo):
        db_session.remove()


if __name__ == '__main__':
    celery_app.start()
