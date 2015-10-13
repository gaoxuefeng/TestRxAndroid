//
//  CSLoginHttpTool.m
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSLoginHttpTool.h"
#import "CSRequestUrl.h"
#import "CSDefine.h"
@implementation CSLoginHttpTool

//获取登录验证码
+ (void)loginCodeWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:GET_SMS_CODE_URL param:param resultClass:[CSBaseResponseModel class] success:success failure:failure];
}
//验证短信验证码
+ (void)checkSmsCodeWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
[self getWithNetWarningUrl:CHECK_SMS_CODE_URL param:param resultClass:[CSBaseResponseModel class] success:success failure:failure];
}
//注册
+ (void)userRegisterWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:USER_REGISTER_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}
//// 上传用户头像 */
//+ (void)uploadIconWithParam:(CSRequest *)param uploadImage:(UIImage *)image success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
//{
//    [self postForUploadWithUrl:PIC_UPLOAD_URL param:param resultClass:[CSBaseResponseModel class] uploadImage:image success:success failure:failure];
//}

/** base64字符串形式上传图片 */
+ (void)uploadIconWithParam:(CSRequest *)param success:(void(^)(CSImageUploadingResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:PIC_UPLOAD_URL param:param resultClass:[CSImageUploadingResponseModel class] success:success failure:failure];
}

//登录
+ (void)userLoginWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:USER_LOGIN_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}

// 动态密码登陆
+ (void)dynamicLoginWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:DYNAMIC_LOGIN_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}

// 修改密码
+ (void)alterPwdWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:ALTER_PWD_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}

//第三方登录
+ (void)threePartLoginWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:USER_THREE_PART_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}

//绑定
+ (void)userBindingWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:USER_Binding_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}

//完善个人资料
+ (void)userProfileWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    [self getWithNetWarningUrl:USER_PROFILE_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
}

// 获取用户资料
+ (void)getUserInfoWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure
{
    if (GlobalObj.token.length>0) {
        [self getWithUrl:GET_USER_INFO_URL param:param resultClass:[CSUserDataWrapperModel class] success:success failure:failure];
    }
    
}



@end
