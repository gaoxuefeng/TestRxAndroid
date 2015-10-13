//
//  NBOrderHttpTool.h
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBHttpTool.h"
#import "NBOrderResponseModel.h"
#import "NBOrderDetailResponseModel.h"
#import "NBDeleteOrderResponseModel.h"
#import "NBUpdateOrderPayMethodResponse.h"
@interface NBOrderHttpTool : NBHttpTool
/**
 *  获取所有订单
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getAllOrderesWithParam:(NBRequestModel *)param success:(void(^)(NBOrderResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取指定订单详情
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getOrderDetailWithParam:(NBRequestModel *)param success:(void(^)(NBOrderDetailResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  删除指定订单详情
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteOrderWithParam:(NBRequestModel *)param success:(void(^)(NBDeleteOrderResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  修改订单支付方式
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)updateOrderPayMethodWithParam:(NBRequestModel *)param success:(void(^)(NBUpdateOrderPayMethodResponse *result))success failure:(void(^)(NSError *error))failure;
@end
