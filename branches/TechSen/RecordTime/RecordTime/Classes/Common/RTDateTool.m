//
//  RTDateTool.m
//  RecordTime
//
//  Created by sen on 8/31/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTDateTool.h"


@implementation RTTime : NSObject


@end


@interface RTDateTool ()

@end

@implementation RTDateTool
static NSDateFormatter *dateFormatterTmp;

+ (NSDateFormatter *)dateFormatter
{
    if (!dateFormatterTmp) {
        dateFormatterTmp = [[NSDateFormatter alloc] init];
        dateFormatterTmp.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return dateFormatterTmp;
}


+ (RTTime *)timeFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    RTTime *time = [[RTTime alloc] init];
    NSDateComponents *cmps = [calendar components:unit fromDate:date];
    time.year = cmps.year;
    time.month = cmps.month;
    time.day = cmps.day;
    time.weekday = cmps.weekday - 1;
    time.hour = cmps.hour;
    time.minute = cmps.minute;
    time.second = cmps.second;
    return time;
}

@end
