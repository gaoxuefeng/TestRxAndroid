//
//  NBLoginHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBLoginHttpTool.h"
#import "NBCommon.h"
@implementation NBLoginHttpTool
+ (void)loginCodeWithParam:(NBRequestModel *)param success:(void(^)(NBLoginResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_LOGIN_CODE_URL param:param resultClass:[NBLoginResponseModel class] success:success failure:failure];
}

+ (void)checkCodeAndLoginWithParam:(NBRequestModel *)param success:(void(^)(NBLoginResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:CHECK_LOGIN_CODE_URL param:param resultClass:[NBLoginResponseModel class] success:success failure:failure];
}

+ (void)getUserInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAccountResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_USER_INFO_URL param:param resultClass:[NBAccountResponseModel class] success:success failure:failure];
}

+ (void)getUserAddressesInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_USER_ADDRESSES_URL param:param resultClass:[NBAddressResponseModel class] success:success failure:failure];
}

+ (void)addUserAddressInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:ADD_USER_ADDRESSES_URL param:param resultClass:[NBAddressResponseModel class] success:success failure:failure];
}
+ (void)deleteUserAddressInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:DELETE_USER_ADDRESSES_URL param:param resultClass:[NBAddressResponseModel class] success:success failure:failure];
}

+ (void)editUserAddressInfoWithParam:(NBRequestModel *)param success:(void(^)(NBAddressResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:EDIT_USER_ADDRESSES_URL param:param resultClass:[NBAddressResponseModel class] success:success failure:failure];
}
+ (void)submitFeedbackWithParam:(NBRequestModel *)param success:(void(^)(NBResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:SUBMIT_FEEDBACK_URL param:param resultClass:[NBResponseModel class] success:success failure:failure];
}
@end
