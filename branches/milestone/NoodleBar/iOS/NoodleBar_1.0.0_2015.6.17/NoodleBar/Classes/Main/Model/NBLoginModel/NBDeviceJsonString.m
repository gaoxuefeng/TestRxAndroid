//
//  NBDeviceJsonString.m
//  NoodleBar
//
//  Created by sen on 15/5/4.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBDeviceJsonString.h"
#import "APService.h"
@implementation NBDeviceJsonString

- (NSString *)registrationID
{
    return [APService registrationID];
}

@end
