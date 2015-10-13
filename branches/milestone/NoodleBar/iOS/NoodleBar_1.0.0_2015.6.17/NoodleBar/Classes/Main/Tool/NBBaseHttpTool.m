//
//  NBBaseHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBBaseHttpTool.h"
#import "NBCommon.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>



@implementation NBBaseHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    NBLog(@"%@",url);
    NBLog(@"%@",params);
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    // 设置请求超时时间为20s
    manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
    // 发送请求和处理
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NBLog(@"%@",responseObject);
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    NBLog(@"%@",url);
    NBLog(@"%@",params);
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置管理器支持text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    // 设置请求超时时间为20s
//    manager.requestSerializer = [AFJSONRequestSerializer ]
    
    manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
    
    // 发送请求和处理
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NBLog(@"%@",responseObject);
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
//        if (TIMEOUT_ERROR == error.code) {
//            [SVProgressHUD showErrorWithStatus:@"网络超时,请检查网络"];
//        }else
//        {
//            
//        }
//        [SVProgressHUD showErrorWithStatus:@"服务器嗝屁了,请稍等"];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  上传图片的请求类
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)params uploadData:(NSData *)uploadData success:(void (^)(id responseObj))success failure:(void (^)(NSError *))failure
{
    NBLog(@"%@",url);
    NBLog(@"%@",params);
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置管理器支持text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadData name:@"image_file" fileName:@"image_file.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
