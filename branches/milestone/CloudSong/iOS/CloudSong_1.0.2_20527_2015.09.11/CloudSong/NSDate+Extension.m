//
//  NSDate+Extension.m
//  ZhaiBuZhu
//
//  Created by sen on 14-10-12.
//  Copyright (c) 2014年 hikomobile. All rights reserved.
//

#import "NSDate+Extension.h"



@implementation CSDateModel : NSObject




@end



@implementation NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{

    NSDate *nowDate = [[NSDate date] dateWithYMD];
    

    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

/**
 *  返回从当前时间起days天内的日期数据
 *
 *  @param days 需要的时间天数
 *
 *  @return 返回一个CSDateModel模型数组
 */
+ (NSArray *)datesSinceNow:(NSInteger)days
{
    NSTimeInterval deltaTimeInterval = 60 * 60 * 24;
    NSMutableArray *datesM = [NSMutableArray arrayWithCapacity:days];
    for (int i = 0; i < days; i++) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:deltaTimeInterval * i];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitWeekday;
        
        // 获得当前时间的年月日
        NSDateComponents *cmps = [calendar components:unit fromDate:date];
        CSDateModel *dateModel = [[CSDateModel alloc] init];
        dateModel.year = cmps.year;
        dateModel.month = cmps.month;
        dateModel.day = cmps.day;
        dateModel.weekday = cmps.weekday - 1;
        [datesM addObject:dateModel];
    }
    return datesM;
}


// 根据 时-分 返回 日期格式： 年-月-日 时:分:秒
+ (NSDate *)dateWithHourMinute:(NSString *)hourMinute
{
    // 现获取系统时间：年-月-日
    NSDate *currentDate = [NSDate date] ;
    NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init] ;
    [currentFormatter setDateFormat:@"YYYY-MM-dd"] ;
    NSString *stringFromDate = [currentFormatter stringFromDate:currentDate] ;
    
    // 拼接传过来的 时-分
    NSString *revertDateString = [NSString stringWithFormat:@"%@ %@", stringFromDate, hourMinute] ;
    NSDateFormatter *revertFormatter = [[NSDateFormatter alloc] init] ;
    [revertFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:NSTimeZoneNameStyleStandard]] ;
    [revertFormatter setDateFormat:@"YYYY-MM-dd HH:mm"] ;
    
    return  [revertFormatter dateFromString:revertDateString] ;
    
}

// 返回距离当前时间的秒数
- (double)deltaTimeFromNow
{
    
    // 调整时间为北京时间，而不是格林尼治时间
    NSDate *GMTDate = [NSDate date] ;
    NSTimeZone *zone = [NSTimeZone systemTimeZone] ;
    NSInteger deltaTime = [zone secondsFromGMTForDate: GMTDate];
    NSDate *localeDate = [GMTDate  dateByAddingTimeInterval: deltaTime];
    
    return [self timeIntervalSinceDate:localeDate] ;
}

@end
