//
//  CSOrderDishHttpTool.m
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderDishHttpTool.h"
@implementation CSOrderDishHttpTool
+ (void)dishesWithParam:(CSRequest *)param success:(void(^)(CSDishListResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    CSMyRoomInfoModel *roomInfo = GlobalObj.myRooms.firstObject;
    [self getWithNetWarningUrl:roomInfo.starting?DISH_LIST_KTV_URL:DISH_LIST_CLOUD_URL param:param resultClass:[CSDishListResponseModel class] success:success failure:failure];
}

/**
 *  提交酒水订单
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)submitDishOrderWithParam:(CSRequest *)param success:(void(^)(CSKTVDishListResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    CSMyRoomInfoModel *roomInfo = GlobalObj.myRooms.firstObject;
    [self getWithUrl:roomInfo.starting?SUBMIT_KTV_DISH_ORDER_URL:SUBMIT_DISH_ORDER_URL param:param resultClass:[CSKTVDishListResponseModel class] success:success failure:^(NSError *error) {
        [self submitCloudDishOrderWithParam:param success:success failure:failure];
    }];
}

+ (void)submitCloudDishOrderWithParam:(CSRequest *)param success:(void(^)(CSKTVDishListResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:SUBMIT_DISH_ORDER_URL param:param resultClass:[CSKTVDishListResponseModel class] success:success failure:failure];
}

///**
// *  提交酒水订单(KTV)
// *
// *  @param param   参数
// *  @param success 成功回调
// *  @param failure 失败回调
// */
//+ (void)submitKTVDishOrderWithParam:(CSRequest *)param success:(void(^)(CSKTVDishListResponseModel *result))success failure:(void(^)(NSError *error))failure
//{
//    [self getWithNetWarningUrl:SUBMIT_KTV_DISH_ORDER_URL param:param resultClass:[CSKTVDishListResponseModel class] success:success failure:failure];
//}

/**
 *  获取微信支付预订单号
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getWechatPrepayIDWithParam:(CSRequest *)param success:(void(^)(CSGetPrepayIdResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_WEICHAT_PREPAY_ID_URL param:param resultClass:[CSGetPrepayIdResponseModel class] success:success failure:failure];

}
@end
