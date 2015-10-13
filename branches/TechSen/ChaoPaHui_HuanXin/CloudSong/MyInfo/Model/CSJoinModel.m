//
//  CSJoinModel.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSJoinModel.h"
#import <MJExtension.h>
@implementation CSJoinModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"nickName":@"userName",@"imageUrl":@"userIcon",@"phoneNum":@"userPhoneNum",@"gender":@"userGender"};
}

- (NSString *)date
{
    if (_date)
        return _date;
    
     double offsetSecond = [_serverTimeStamp doubleValue] - [_joinTimeStamp doubleValue];
    NSInteger days = offsetSecond / (24 * 3600);
    if (days > 0) {
        _date = [NSString stringWithFormat:@"已加入%ld天",days];
    }else
    {
        NSInteger hours = offsetSecond / 3600;
        if (hours > 0) {
            _date = [NSString stringWithFormat:@"已加入%ld小时",hours];
        }else
        {
            NSInteger minutes = offsetSecond / 60;
            if (minutes > 0) {
                _date = [NSString stringWithFormat:@"已加入%ld分钟",minutes];
            }else
            {
                _date = @"刚刚加入";
            }
        }
    }
    return _date;
}
@end
