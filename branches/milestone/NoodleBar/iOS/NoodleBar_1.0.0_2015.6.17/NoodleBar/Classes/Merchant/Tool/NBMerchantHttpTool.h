//
//  NBMerchantHttpTool.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBHttpTool.h"
#import "NBGetAppAdResponseModel.h"
#import "NBMerchantModel.h"
#import "NBMerchantsResponseModel.h"
#import "NBMerchantResponseModel.h"
@interface NBMerchantHttpTool : NBHttpTool
/**
 *  获取商户列表
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)merchantsByCityWithParam:(NBRequestModel *)param success:(void(^)(NBMerchantsResponseModel *result))success failure:(void(^)(NSError *error))failure;

+ (void)merchantWithParam:(NBRequestModel *)param success:(void(^)(NBMerchantResponseModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  获取应用广告列表
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getAppAdWithParam:(NBRequestModel *)param success:(void(^)(NBGetAppAdResponseModel *result))success failure:(void(^)(NSError *error))failure;
@end
