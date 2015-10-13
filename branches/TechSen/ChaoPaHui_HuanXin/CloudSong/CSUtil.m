//
//  CSUtil.m
//  CloudSong
//
//  Created by youmingtaizi on 5/15/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSUtil.h"
#import <UIKit/UIKit.h>

@implementation CSUtil

#pragma mark - Public Methods

+ (BOOL)isLaterThanIOSVersion:(CGFloat)version include:(BOOL)include {
    BOOL result = NO;
    NSInteger inputVersion = (NSInteger)(version * 100);
    NSInteger currentVersion = [CSUtil getIOSVersion];
    if (include)
        result = currentVersion >= inputVersion;
    else
        result = currentVersion > inputVersion;
    return result;
}

+ (NSString *)relativeDescriptionOfDate:(NSDate *)date
{
    NSString *str;
    NSTimeInterval intervalNow = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval intervalDate = [date timeIntervalSince1970];
    
    int64_t dateSecondCount = intervalDate;
    int64_t nowSecondCount = intervalNow;
    
    int64_t oldDay = (dateSecondCount / 86400);
    int64_t curDay = (nowSecondCount / 86400);
    if (curDay < oldDay)
    {
        // 时间有问题，不显示
        str = @"";
    }
    else if (curDay == oldDay)
    {
        // 同一天，根据intervalSinceNow进一步判断
        int passedSecond = (int)(nowSecondCount - dateSecondCount);
        
        if (passedSecond < 60)
        {
            // 如果由于用户修改时间等原因出现了负值，强行显示为0秒前
            passedSecond = MAX(passedSecond, 1);
            str = [NSString stringWithFormat:@"%d秒前", passedSecond];
        }
        else if (passedSecond < 3600)
        {
            int minute = passedSecond / 60;
            str = [NSString stringWithFormat:@"%d分钟前", minute];
        }
        else
        {
            int hour = passedSecond / 3600;
            str = [NSString stringWithFormat:@"%d小时前", hour];
        }
    }
    else if (curDay == oldDay + 1)
    {
        // 昨天
        str = @"昨天";
    }
    else if (curDay - oldDay < 7)
    {
        // xxx天前
        str = [NSString stringWithFormat:@"%lld天前", curDay - oldDay];
    }
    else if (curDay - oldDay < 30)
    {
        str = [NSString stringWithFormat:@"%lld周前", (curDay - oldDay)/7];
    }
    else if (curDay - oldDay < 365)
    {
        str = [NSString stringWithFormat:@"%lld月前", (curDay - oldDay)/30];
    }
    else
    {
        str = [NSString stringWithFormat:@"%lld年前", (curDay - oldDay)/365];
    }
    
    return str;
}

+ (void)hideEmptySeparatorForTableView:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}

+ (NSString *)pathForButtonInfos {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *buttonInfos = [docPath stringByAppendingPathComponent:@"ButtonInfos"];
    BOOL isDir = NO;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:buttonInfos isDirectory:&isDir] && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:buttonInfos withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return buttonInfos;
}

+ (NSString *)pathForAllSingSongs {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *buttonInfos = [docPath stringByAppendingPathComponent:@"AllSingSongs"];
    BOOL isDir = NO;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:buttonInfos isDirectory:&isDir] && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:buttonInfos withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return buttonInfos;
}

+ (NSString *)pathForRecommendedAlbums {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *buttonInfos = [docPath stringByAppendingPathComponent:@"RecommendedAlbums"];
    BOOL isDir = NO;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:buttonInfos isDirectory:&isDir] && isDir))
        [[NSFileManager defaultManager] createDirectoryAtPath:buttonInfos withIntermediateDirectories:NO attributes:nil error:nil];
    return buttonInfos;
}

+ (NSDate *)ealiestAvailableDateWithOpenTime:(NSDate *)openTime closeTime:(NSDate *)closeTime {
    // 生成formattor
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [currentCalendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                                      fromDate:currentDate];
    
    // 开始营业的时间
    NSDateComponents *openTimeComponents = [currentCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                              fromDate:openTime];

    // 结束营业的时间前1小时
    NSDateComponents *closeTimeComponents = [currentCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                              fromDate:closeTime];

    // 如果当前时间在营业时间之前
    if ([currentDateComponents hour] < [openTimeComponents hour]
        || ([currentDateComponents hour] == [openTimeComponents hour] && [currentDateComponents minute] <= [openTimeComponents minute])) {
        NSString *dateString = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",
                                [currentDateComponents month],
                                [currentDateComponents day],
                                [openTimeComponents hour],
                                [openTimeComponents minute]];
        return [[CSUtil defaultFullDateFormattor] dateFromString:dateString];
    }
    // 如果当前时间在营业时间和结束营业时间前1小时的时间段之内
    else if (([currentDateComponents hour] < [closeTimeComponents hour] - 1)
             || ([currentDateComponents hour] == [closeTimeComponents hour] - 1 && [currentDateComponents minute] <= [closeTimeComponents minute])) {
        NSDate *dateBefore30MinAgo = [NSDate dateWithTimeInterval:-30 * 60 sinceDate:currentDate];
        NSDateComponents *dateComponentsBefore30MinAgo = [currentCalendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                                                            fromDate:dateBefore30MinAgo];
        // 返回当前时间至30min之前时间段里的半点时间
        if ([dateComponentsBefore30MinAgo minute] <= 30) {
            [dateComponentsBefore30MinAgo setMinute:30];
            NSString *dateString = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",
                                    [dateComponentsBefore30MinAgo month],
                                    [dateComponentsBefore30MinAgo day],
                                    [dateComponentsBefore30MinAgo hour],
                                    [dateComponentsBefore30MinAgo minute]];
            return [[CSUtil defaultFullDateFormattor] dateFromString:dateString];
        }
        // 返回当前时间至30min之前时间段里的整点时间
        else {
            return [NSDate dateWithTimeInterval:60 * (60 - [dateComponentsBefore30MinAgo minute]) sinceDate:dateBefore30MinAgo];
        }
    }
    // 如果是在当天营业结束时间前1小时之后的时间段内的话，则返回第二天的营业开始时间
    else {
        // 先取当天营业开始时间，在加上24小时
        NSDateComponents *openDateComponents = [[NSDateComponents alloc] init];
        [openDateComponents setMonth:[currentDateComponents month]];
        [openDateComponents setDay:[currentDateComponents day]];
        [openDateComponents setHour:[openTimeComponents hour]];
        [openDateComponents setMinute:[openTimeComponents minute]];
        NSDate *todayOpenDate = [currentCalendar dateFromComponents:openDateComponents];
        return [NSDate dateWithTimeInterval:3600 * 24 sinceDate:todayOpenDate];
    }
}

+ (NSDateFormatter *)defaultFullDateFormattor {
    static NSDateFormatter *formattor = nil;
    if (!formattor) {
        formattor = [[NSDateFormatter alloc] init];
        formattor.dateFormat = @"MM-dd HH:mm";
    }
    return formattor;
}

+ (NSDateFormatter *)defaultDateFormattor {
    static NSDateFormatter *formattor = nil;
    if (!formattor) {
        formattor = [[NSDateFormatter alloc] init];
        formattor.dateFormat = @"MM-dd";
    }
    return formattor;
}

+ (NSDateFormatter *)defaultTimeFormattor {
    static NSDateFormatter *formattor = nil;
    if (!formattor) {
        formattor = [[NSDateFormatter alloc] init];
        formattor.dateFormat = @"HH:mm";
    }
    return formattor;
}

+ (NSDateFormatter *)defaultDateWithUnitFormattor
{
    static NSDateFormatter *formattor = nil;
    if (!formattor) {
        formattor = [[NSDateFormatter alloc] init];
        formattor.dateFormat = @"MM月dd日";
    }
    return formattor;
}

#pragma mark - Private Methods

+ (NSInteger)getIOSVersion
{
    NSInteger version = 0;
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *components = [systemVersion componentsSeparatedByString:@"."];
    // 例如 iOS 8
    if (components.count == 1)
        version = 100 * [components[0] integerValue];
    // 例如 iOS 8.1
    else if (components.count == 2)
        version = 100 * [components[0] integerValue] + 10 * [components[1] integerValue];
    // 例如 iOS 8.1.2
    else if (components.count == 3)
        version = 100 * [components[0] integerValue] + 10 * [components[1] integerValue] + [components[2] integerValue];
    return version;
}

@end
