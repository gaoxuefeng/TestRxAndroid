//
//  CSKTVBookingOrder.m
//  CloudSong
//
//  Created by youmingtaizi on 6/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVBookingOrder.h"

@implementation CSKTVBookingOrder

//- (NSString *)totalTime
//{
//    NSString *endTime = nil;
//    if (!_totalTime) {
//        NSRange range = NSMakeRange(0, 2);
//        NSString *replacedStr = [_hour substringWithRange:range];
//        NSString *str = [NSString stringWithFormat:@"%02ld",([replacedStr integerValue] + [_duration integerValue])];
//        endTime = [_hour stringByReplacingCharactersInRange:range withString:str];
//    }
//    NSString *day = [_day stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
//    return [NSString stringWithFormat:@"%@日 %@-%@",day,_hour,endTime];
//}
- (NSString *)totalTime
{
    if (!_totalTime) {
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[_rbStartTime doubleValue]];
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[_rbEndTime doubleValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
        // 获得当前时间的年月日
        NSDateComponents *startTimeCmps = [calendar components:unit fromDate:startTime];
        NSDateComponents *endTimeCmps = [calendar components:unit fromDate:endTime];
        
        NSString *weekDay = nil;
        switch (startTimeCmps.weekday) {
            case 1:
                weekDay = @"周日";
                break;
            case 2:
                weekDay = @"周一";
                break;
            case 3:
                weekDay = @"周二";
                break;
            case 4:
                weekDay = @"周三";
                break;
            case 5:
                weekDay = @"周四";
                break;
            case 6:
                weekDay = @"周五";
                break;
            case 7:
                weekDay = @"周六";
                break;
            default:
                break;
        }
        _totalTime = [NSString stringWithFormat:@"%ld月%ld日 %@ %02ld:%02ld-%02ld:%02ld",startTimeCmps.month,startTimeCmps.day,weekDay,startTimeCmps.hour,startTimeCmps.minute,endTimeCmps.hour,endTimeCmps.minute];
    }
    return _totalTime;
}

@end
