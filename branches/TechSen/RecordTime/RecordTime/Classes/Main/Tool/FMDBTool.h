//
//  FMDBTool.h
//  RecordTime
//
//  Created by sen on 9/4/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTDatePointModel.h"


@interface FMDBTool : NSObject

/* 添加一条时间点记录 */
+ (void)insertDatePointWithType:(RTDatePointType)datePointType;

/** 查询所有时间点 */
+ (NSArray *)queryAllDatePoint;

/** 查询昨天时间点 */
+ (NSArray *)queryNearlyYesterdayDatePointsWithType:(RTDatePointType)datePointType;

/** 查询近七天时间点 */
+ (NSArray *)queryNearlyWeekDatePointsWithType:(RTDatePointType)datePointType;

/** 查询近一个月时间点 */
+ (NSArray *)queryNearlyMonthDatePoints:(RTDatePointType)datePointType;

@end
