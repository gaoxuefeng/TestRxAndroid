//
//  CSLoginHttpTool.h
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSRequest.h"
#import "CSBaseResponseModel.h"
#import "CSUserDataWrapperModel.h"
#import "CSImageUploadingResponseModel.h"
@interface CSLoginHttpTool : CSBaseHttpTool

//获取登录验证码
+ (void)loginCodeWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;
//验证短信验证码
+ (void)checkSmsCodeWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;
//注册
+ (void)userRegisterWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;

//登录
+ (void)userLoginWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;

// 动态密码登陆
+ (void)dynamicLoginWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;

// 修改密码
+ (void)alterPwdWithParam:(CSRequest *)param success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;


//第三方登录
+ (void)threePartLoginWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;
//绑定
+ (void)userBindingWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;

//完善个人资料
+ (void)userProfileWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;

//// 上传用户头像
//+ (void)uploadIconWithParam:(CSRequest *)param uploadImage:(UIImage *)image success:(void(^)(CSBaseResponseModel *result))success failure:(void(^)(NSError *error))failure;

/** base64字符串形式上传图片 */
+ (void)uploadIconWithParam:(CSRequest *)param  success:(void(^)(CSImageUploadingResponseModel *result))success failure:(void(^)(NSError *error))failure;

// 获取用户资料
+ (void)getUserInfoWithParam:(CSRequest *)param success:(void(^)(CSUserDataWrapperModel *result))success failure:(void(^)(NSError *error))failure;



@end
