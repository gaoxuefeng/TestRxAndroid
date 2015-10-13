//
//  CSUtil.h
//  CloudSong
//
//  Created by youmingtaizi on 5/15/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface CSUtil : NSObject
+ (BOOL)isLaterThanIOSVersion:(CGFloat)version include:(BOOL)include;
+ (NSString *)relativeDescriptionOfDate:(NSDate *)date;
+ (void)hideEmptySeparatorForTableView:(UITableView *)tableView;
+ (NSString *)pathForButtonInfos;
+ (NSString *)pathForAllSingSongs;
+ (NSString *)pathForRecommendedAlbums;
/**
 *  获取最近的可以预定KTV的时间，判断逻辑如下：
 *  1. 如果当前时间在KTV开始营业时间之前（或者就是开始时间），则返回开始营业时间
 *  2. 如果当前时间在KTV开始营业时间之后，但是是在KTV结束营业时间之前的1小时时间之内，则取当前时间到30min之前的时间段内的整点或者半点时间
 *  3. 如果当前时间是在KTV营业时间结束之后，则取明天的开始营业时间
 *  @return 可以预定KTV的最早时间
 */
+ (NSDate *)ealiestAvailableDateWithOpenTime:(NSDate *)openTime closeTime:(NSDate *)closeTime;
+ (NSDateFormatter *)defaultFullDateFormattor;
+ (NSDateFormatter *)defaultDateFormattor;
+ (NSDateFormatter *)defaultTimeFormattor;
+ (NSDateFormatter *)defaultDateWithUnitFormattor;
@end
