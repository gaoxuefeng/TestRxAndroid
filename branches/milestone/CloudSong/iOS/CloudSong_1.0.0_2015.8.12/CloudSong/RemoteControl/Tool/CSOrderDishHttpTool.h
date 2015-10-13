//
//  CSOrderDishHttpTool.h
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSRequest.h"
#import "CSDishListResponseModel.h"
#import "CSSubmitDishOrderResponseModel.h"
#import "CSKTVDishListResponseModel.h"
#import "CSGetPrepayIdResponseModel.h"
@interface CSOrderDishHttpTool : CSBaseHttpTool
/**
 *  获取菜品信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)dishesWithParam:(CSRequest *)param success:(void(^)(CSDishListResponseModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  提交酒水订单
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)submitDishOrderWithParam:(CSRequest *)param success:(void(^)(CSKTVDishListResponseModel *result))success failure:(void(^)(NSError *error))failure;

///**
// *  提交酒水订单(KTV服)
// *
// *  @param param   参数
// *  @param success 成功回调
// *  @param failure 失败回调
// */
//+ (void)submitKTVDishOrderWithParam:(CSRequest *)param success:(void(^)(CSKTVDishListResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取微信支付预订单号
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getWechatPrepayIDWithParam:(CSRequest *)param success:(void(^)(CSGetPrepayIdResponseModel *result))success failure:(void(^)(NSError *error))failure;

@end
