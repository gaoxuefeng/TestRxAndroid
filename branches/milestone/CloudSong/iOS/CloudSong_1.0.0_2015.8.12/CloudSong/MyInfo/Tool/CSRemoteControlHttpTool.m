//
//  CSRemoteControlHttpTool.m
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRemoteControlHttpTool.h"

@implementation CSRemoteControlHttpTool
+ (void)remoteControlWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithUrl:REMOTE_CONTROL_URL param:param resultClass:[CSBaseResponseModel class] success:success failure:failure];
}
@end
