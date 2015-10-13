//
//  CSRoomDetailModel.m
//  CloudSong
//
//  Created by sen on 15/7/6.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomDetailModel.h"
#import <MJExtension.h>
#import "CSDishModel.h"
@interface CSRoomDetailModel ()
@property(nonatomic, assign) int sign;
@property(nonatomic, copy) NSString *startHours;
@property(nonatomic, copy) NSString *endHours;

@end

@implementation CSRoomDetailModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"goodsList":[CSDishModel class]};
}

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

- (void)setOrderTime:(NSString *)orderTime
{
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    dfm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[orderTime doubleValue]];
    _orderTime = [dfm stringFromDate:date];
}

@end
