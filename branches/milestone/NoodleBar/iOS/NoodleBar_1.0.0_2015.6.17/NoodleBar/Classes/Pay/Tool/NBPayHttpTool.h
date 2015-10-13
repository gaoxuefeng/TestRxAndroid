//
//  NBPayHttpTool.h
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBHttpTool.h"
#import "NBPayResponseModel.h"
#import "NBGetTakeCodeResponseModel.h"
@interface NBPayHttpTool : NBHttpTool
/**
 *  提交订单
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)submitOrderWithParam:(NBRequestModel *)param success:(void(^)(NBPayResponseModel *result))success failure:(void(^)(NSError *error))failure;



/**
 *  支付成功,修改订单状态
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getTakeCodeWithParam:(NBRequestModel *)param success:(void(^)(NBGetTakeCodeResponseModel *result))success failure:(void(^)(NSError *error))failure;
@end
