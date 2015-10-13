//
//  NSDate+YS.h
//	ZhaiBuZhu
//  Created by sen on 15-1-9.
//  Copyright (c) 2014年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YS)
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
 *  返回hh:mm:ss格式是时间串
 */
- (NSString *)timeString;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;
@end
