//
//  NBMenuHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMenuHttpTool.h"
#import "NBCommon.h"
@implementation NBMenuHttpTool
/**
 *  获取菜品信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)dishesWithParam:(NBRequestModel *)param success:(void(^)(NBDishResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:DISHES_URL param:param resultClass:[NBDishResponseModel class] success:success failure:failure];
}

/**
 *  获取商户广告
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)adesWithParam:(NBRequestModel *)param success:(void(^)(NBMenuAdResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:ADES_URL param:param resultClass:[NBMenuAdResponseModel class] success:success failure:failure];
}
@end
