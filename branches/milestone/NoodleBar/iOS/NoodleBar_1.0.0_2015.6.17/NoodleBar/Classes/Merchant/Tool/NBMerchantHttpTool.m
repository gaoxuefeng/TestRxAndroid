//
//  NBMerchantHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMerchantHttpTool.h"
#import "NBCommon.h"
@implementation NBMerchantHttpTool
/**
 *  获取商户信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)merchantsByCityWithParam:(NBResponseModel *)param success:(void(^)(NBMerchantsResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:MERCHANT_URL param:param resultClass:[NBMerchantsResponseModel class] success:success failure:failure];
}

+ (void)merchantWithParam:(NBResponseModel *)param success:(void(^)(NBMerchantResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_MERTHANT_BY_ID_URL param:param resultClass:[NBMerchantResponseModel class] success:success failure:failure];
}

/**
 *  获取APP广告
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getAppAdWithParam:(NBResponseModel *)param success:(void(^)(NBGetAppAdResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:APP_ADS_URL param:param resultClass:[NBGetAppAdResponseModel class] success:success failure:failure];
}
@end
