//
//  NBOrderHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderHttpTool.h"
#import "NBCommon.h"
@implementation NBOrderHttpTool
+ (void)getAllOrderesWithParam:(NBRequestModel *)param success:(void(^)(NBOrderResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_ALL_ORDERES_URL param:param resultClass:[NBOrderResponseModel class] success:success failure:failure];
}

+ (void)getOrderDetailWithParam:(NBRequestModel *)param success:(void(^)(NBOrderDetailResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_ORDERES_DETAIL_URL param:param resultClass:[NBOrderDetailResponseModel class] success:success failure:failure];
}

+ (void)deleteOrderWithParam:(NBRequestModel *)param success:(void(^)(NBDeleteOrderResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:DELETE_ORDERE_URL param:param resultClass:[NBDeleteOrderResponseModel class] success:success failure:failure];
}

/**
 *  修改订单支付方式
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)updateOrderPayMethodWithParam:(NBRequestModel *)param success:(void(^)(NBUpdateOrderPayMethodResponse *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:UPDATE_ORDERE_PAY_METHOD_URL param:param resultClass:[NBUpdateOrderPayMethodResponse class] success:success failure:failure];
}
@end
