//
//  RTDateTool.h
//  RecordTime
//
//  Created by sen on 8/31/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTTime : NSObject
/* 年 */
@property(assign, nonatomic) NSInteger year;
/* 月 */
@property(assign, nonatomic) NSInteger month;
/* 日 */
@property(assign, nonatomic) NSInteger day;
/* 星期 */
@property(assign, nonatomic) NSInteger weekday;
/* 小时 */
@property(assign, nonatomic) NSInteger hour;
/* 分钟 */
@property(assign, nonatomic) NSInteger minute;
/* 秒 */
@property(assign, nonatomic) NSInteger second;
@end


@interface RTDateTool : NSObject

+ (RTTime *)timeFromDate:(NSDate *)date;

+ (NSDateFormatter *)dateFormatter;
@end
