//
//  CSQRCodeReadHttpTool.m
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSQRCodeReadHttpTool.h"
#import "CSDefine.h"
@implementation CSQRCodeReadHttpTool
+ (void)bindingRoomWithParam:(CSRequest *)param success:(void(^)(CSBindingRoomResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithUrl:bindingRoomProtocol param:param resultClass:[CSBindingRoomResponseModel class] success:success failure:failure];
}
@end
