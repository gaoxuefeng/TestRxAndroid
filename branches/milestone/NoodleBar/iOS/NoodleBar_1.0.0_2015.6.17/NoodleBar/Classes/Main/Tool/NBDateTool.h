//
//  NBDateTool.h
//  NoodleBar
//
//  Created by sen on 15/4/23.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDateTool : NSObject
// 返回一个dateFormatter对象
+ (NSDateFormatter *)dateFormatter;
/**
 *  给定一个秒数,返回一个以HH:mm:ss 如果不满一小时则为mm:ss 如果不满一分钟则为ss秒
 *
 *  @param timeInterval 总秒数
 *
 *  @return 指定格式的字符串
 */
+ (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval;
@end
