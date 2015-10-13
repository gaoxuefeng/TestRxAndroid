//
//  CSMyInfoHttpTool.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyInfoHttpTool.h"

@implementation CSMyInfoHttpTool
// 用去消费列表
+ (void)getCostListWithParam:(CSRequest *)param success:(void(^)(CSMyCostResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_COST_LIST_URL param:param resultClass:[CSMyCostResponseModel class] success:success failure:failure];
}

+ (void)getRoomCostDetailWithParam:(CSRequest *)param success:(void(^)(CSRoomDetailResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_ROOM_COST_DETAIL_URL param:param resultClass:[CSRoomDetailResponseModel class] success:success failure:failure];
}

/** 取消酒水订单 */
+ (void)cancelOrderWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:CANCEL_ORDER_URL param:param resultClass:[CSBaseResponseModel class] success:success failure:failure];
}

/** 酒水消费详情 */
+ (void)getDishCostDetailWithParam:(CSRequest *)param success:(void(^)(CSRoomDetailResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_DISH_COST_DETAIL_URL param:param resultClass:[CSRoomDetailResponseModel class] success:success failure:failure];
}

/** 获取包厢列表 */
+ (void)getRoomsWithParam:(CSRequest *)param success:(void(^)(CSRoomResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_ROOM_LIST_URL param:param resultClass:[CSRoomResponseModel class] success:success failure:failure];
}

/** 包厢参与人列表 */
+ (void)getRoomMembersWithParam:(CSRequest *)param success:(void(^)(CSRoomMemberResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_ROOM_MEMBER_LIST_URL param:param resultClass:[CSRoomMemberResponseModel class] success:success failure:failure];
}

// 发送用户反馈
+ (void)sendFeedBackWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:SEND_FEEDBACK_URL param:param resultClass:[CSBaseResponseModel class] success:success failure:failure];
}
@end
