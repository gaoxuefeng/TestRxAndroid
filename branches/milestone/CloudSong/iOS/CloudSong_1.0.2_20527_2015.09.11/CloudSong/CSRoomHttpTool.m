//
//  CSRoomHttpTool.m
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomHttpTool.h"

@implementation CSRoomHttpTool

/** 获取房间动态 */
+ (void)getRoomStatusWithParam:(CSRequest *)param success:(void(^)(CSChatMessageResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithUrl:GET_KTV_ROOM_STATUS_URL param:param resultClass:[CSChatMessageResponseModel class] success:success failure:^(NSError *error) {
        [self getRoomStatusFromCloudWithParam:param success:success failure:failure];
    }];
}

/** 获取房间动态(云服) */
+ (void)getRoomStatusFromCloudWithParam:(CSRequest *)param success:(void(^)(CSChatMessageResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_CLOUD_ROOM_STATUS_URL param:param resultClass:[CSChatMessageResponseModel class] success:success failure:failure];
}

/** 发送房间消息 */
+ (void)sendChatMessageWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:SEND_KTV_STATUS_URL param:param resultClass:[CSBaseResponseModel class] success:success failure:failure];
}

/** 获取包厢详情 */
+ (void)getRoomInfoWithParam:(CSRequest *)param success:(void(^)(CSRoomInfoResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_ROOM_INFO_URL param:param resultClass:[CSRoomInfoResponseModel class] success:success failure:failure];
}

/** 获取房间二维码 */
+ (void)getRoomQRWithParam:(CSRequest *)param success:(void(^)(CSRoomQRResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_ROOM_QR_URL param:param resultClass:[CSRoomQRResponseModel class] success:success failure:failure];
}
@end
