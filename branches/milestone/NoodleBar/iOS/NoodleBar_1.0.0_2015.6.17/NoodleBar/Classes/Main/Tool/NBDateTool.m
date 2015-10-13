//
//  NBDateTool.m
//  NoodleBar
//
//  Created by sen on 15/4/23.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBDateTool.h"

@implementation NBDateTool

static NSDateFormatter *dateFormatterTemp;

+ (NSDateFormatter *)dateFormatter
{
    if (!dateFormatterTemp) {
        dateFormatterTemp = [[NSDateFormatter alloc] init];
        dateFormatterTemp.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return dateFormatterTemp;
}

/**
 *  给定一个秒数,返回一个以HH:mm:ss 如果不满一小时则为mm:ss 如果不满一分钟则为ss
 *
 *  @param timeInterval 总秒数
 *
 *  @return 指定格式的字符串
 */
+ (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval
{
    if (timeInterval < 60) { // 不到60秒
        return [NSString stringWithFormat:@"%d秒",(int)timeInterval];
    }else
    {
        if (timeInterval >= 60 && timeInterval < 3600) { // 1分钟 - 1小时内
            int minute = timeInterval / 60;
            int second = (int)timeInterval % 60;
            return [NSString stringWithFormat:@"%02d:%02d",minute,second];
        }else
        {
            int hour = (int)timeInterval / 3600;
            int hourLeft = (int)timeInterval % 3600;
            int minute = hourLeft / 60;
            int second = hourLeft % 60;
            return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];

        }
    }
    return nil;
}
@end
