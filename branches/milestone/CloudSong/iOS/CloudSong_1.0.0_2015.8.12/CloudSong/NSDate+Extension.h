//
//  NSDate+Extension.h
//  ZhaiBuZhu
//
//  Created by sen on 14-10-12.
//  Copyright (c) 2014年 hikomobile. All rights reserved.
//  可以对一个NSdate对象进行时间上的判断

#import <Foundation/Foundation.h>

@interface CSDateModel : NSObject
/** 年 */
@property(nonatomic, assign) NSInteger year;
/** 月 */
@property(nonatomic, assign) NSInteger month;
/** 日 */
@property(nonatomic, assign) NSInteger day;
/** 星期 1代表星期一 ... 7代表星期日*/
@property(nonatomic, assign) NSInteger weekday;
@end


@interface NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;


/**
 *  返回从当前时间起days天内的日期数据
 *
 *  @param days 需要的时间天数
 *
 *  @return 返回一个CSDateModel模型数组
 */
+ (NSArray *)datesSinceNow:(NSInteger)days;

// 返回距离当前时间的秒数
- (double)deltaTimeFromNow ;

// 根据 时-分 返回 日期格式： 年-月-日 时:分:秒
+ (NSDate *)dateWithHourMinute:(NSString *)hourMinute ;


@end
