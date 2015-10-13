//
//  CSInRoomUserModel.m
//  CloudSong
//
//  Created by sen on 15/6/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInRoomUserModel.h"
#import "NSDate+Extension.h"

@implementation CSInRoomUserModel



- (void)setTime:(NSString *)time
{
    NSString *timeStr = nil;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    if ([date isToday]) {
        NSDateFormatter *dft = [[NSDateFormatter alloc] init];
        dft.dateFormat = @" HH : mm";
        timeStr = [dft stringFromDate:date];
    }else
    {
        NSDateFormatter *dft = [[NSDateFormatter alloc] init];
        dft.dateFormat = @"MM月dd日";
        timeStr = [dft stringFromDate:date];
    }
    _time = timeStr;
    
}

@end
