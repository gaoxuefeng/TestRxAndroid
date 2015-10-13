//
//  CSMyInfoHttpTool.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSMyCostResponseModel.h"
#import "CSRoomDetailResponseModel.h"
#import "CSRoomResponseModel.h"
#import "CSRoomMemberResponseModel.h"
@interface CSMyInfoHttpTool : CSBaseHttpTool
// 用去消费列表
+ (void)getCostListWithParam:(CSRequest *)param success:(void(^)(CSMyCostResponseModel *result))success failure:(void(^)(NSError *error))failure;
/** 包厢消费详情 */
+ (void)getRoomCostDetailWithParam:(CSRequest *)param success:(void(^)(CSRoomDetailResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 酒水消费详情 */
+ (void)getDishCostDetailWithParam:(CSRequest *)param success:(void(^)(CSRoomDetailResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 取消酒水订单 */
+ (void)cancelOrderWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 获取包厢列表 */
+ (void)getRoomsWithParam:(CSRequest *)param success:(void(^)(CSRoomResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** 包厢参与人列表 */
+ (void)getRoomMembersWithParam:(CSRequest *)param success:(void(^)(CSRoomMemberResponseModel *result))success failure:(void(^)(NSError *error))failure;

// 发送用户反馈
+ (void)sendFeedBackWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;

@end
