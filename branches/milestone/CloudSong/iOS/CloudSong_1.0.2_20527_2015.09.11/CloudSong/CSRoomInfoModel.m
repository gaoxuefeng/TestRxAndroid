//
//  CSRoomInfoModel.m
//  CloudSong
//
//  Created by sen on 15/7/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomInfoModel.h"


@interface CSRoomInfoModel ()
@property(nonatomic, assign) int sign;
@property(nonatomic, copy) NSString *startHours;
@property(nonatomic, copy) NSString *endHours;

@end

@implementation CSRoomInfoModel
- (void)setSign:(int)sign
{
    _sign = sign;
    if (sign == 2) {
        _time = [NSString stringWithFormat:@"%@至%@",_startHours,_endHours];
    }
}

- (void)setRbStartTime:(NSString *)rbStartTime
{
    _rbStartTime = rbStartTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:rbStartTime.doubleValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
    // 获得当前时间的年月日
    NSDateComponents *cmps = [calendar components:unit fromDate:date];
    NSString *weekDay = nil;
    switch (cmps.weekday) {
        case 1:
            weekDay = @"日";
            break;
        case 2:
            weekDay = @"一";
            break;
        case 3:
            weekDay = @"二";
            break;
        case 4:
            weekDay = @"三";
            break;
        case 5:
            weekDay = @"四";
            break;
        case 6:
            weekDay = @"五";
            break;
        case 7:
            weekDay = @"六";
            break;
            
        default:
            break;
    }
    NSString *dateStr = [NSString stringWithFormat:@"%ld月%ld日 周%@ ",cmps.month,cmps.day,weekDay];
    self.startHours = [NSString stringWithFormat:@"%@ %ld:%02ld",dateStr,cmps.hour,cmps.minute];
    self.sign++;
}

- (void)setRbEndTime:(NSString *)rbEndTime
{
    _rbEndTime = rbEndTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:rbEndTime.doubleValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    // 获得当前时间的年月日
    NSDateComponents *cmps = [calendar components:unit fromDate:date];
    self.endHours = [NSString stringWithFormat:@"%ld:%02ld",cmps.hour,cmps.minute];
    self.sign++;
}

- (NSString *)countDownStr
{
     NSInteger seconds = _rbStartTime.doubleValue - [NSDate date].timeIntervalSince1970;
    _duration = seconds;
    if (seconds > 0) { // 还未开始
        if (seconds > 3600 * 24) { // 超过一天
            NSInteger days = seconds / (3600 * 24);
            return [NSString stringWithFormat:@"离开始还有:%ld天",days];
        }else if (seconds > 3600) // 小于一天超过1小时
        {
            NSInteger hours = seconds / 3600;
            NSInteger leftSecond = seconds % 3600;
            NSInteger minutes = leftSecond / 60;
            NSInteger finalSeconds = leftSecond % 60;
            return [NSString stringWithFormat:@"离开始还有:%ld小时%ld分钟%ld秒",hours,minutes,finalSeconds];
        }else if (seconds > 60) // 小于天数超过一分钟
        {
            NSInteger minutes = seconds / 60;
            NSInteger finalSeconds = seconds % 60;
            return [NSString stringWithFormat:@"离开始还有:%ld分钟%ld秒",minutes,finalSeconds];
        }else
        {
            return [NSString stringWithFormat:@"离开始还有:%ld秒",seconds];
        }
    }else
    {
        seconds = _rbEndTime.doubleValue - [NSDate date].timeIntervalSince1970;
        if (seconds > 3600 * 24) { // 超过一天
            NSInteger days = seconds / (3600 * 24);
            return [NSString stringWithFormat:@"离结束还有:%ld天",days];
        }else if (seconds > 3600) // 小于一天超过1小时
        {
            NSInteger hours = seconds / 3600;
            NSInteger leftSecond = seconds % 3600;
            NSInteger minutes = leftSecond / 60;
            NSInteger finalSeconds = leftSecond % 60;
            return [NSString stringWithFormat:@"离结束还有:%ld小时%ld分钟%ld秒",hours,minutes,finalSeconds];
        }else if (seconds > 60) // 小于天数超过一分钟
        {
            NSInteger minutes = seconds / 60;
            NSInteger finalSeconds = seconds % 60;
            return [NSString stringWithFormat:@"离结束还有:%ld分钟%ld秒",minutes,finalSeconds];
        }else if(seconds > 0)
        {
            return [NSString stringWithFormat:@"离结束还有:%ld秒",seconds];
        }else
        {
            return @"已结束";
        }
    }
}

@end
