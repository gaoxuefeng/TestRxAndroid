//
//  NBLoginHttpTool.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBHttpTool.h"
#import "NBLoginResponseModel.h"
#import "NBAccountResponseModel.h"
#import "NBAddressResponseModel.h"
#import "NBAddressResponseModel.h"

@interface NBLoginHttpTool : NBHttpTool
/**
 *  获取登录验证码
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loginCodeWithParam:(NBRequestModel *)param success:(void(^)(NBLoginResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  校验验证码并登录
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)checkCodeAndLoginWithParam:(NBRequestModel *)param success:(void(^)(NBLoginResponseModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  获取用户信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getUserInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAccountResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取用户地址信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getUserAddressesInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  增加用户地址信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addUserAddressInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  删除用户地址信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteUserAddressInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  修改用户地址信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)editUserAddressInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  修改用户地址信息
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)submitFeedbackWithParam:(NBRequestModel *)param success:(void(^)(NBResponseModel *result))success failure:(void(^)(NSError *error))failure;

@end
