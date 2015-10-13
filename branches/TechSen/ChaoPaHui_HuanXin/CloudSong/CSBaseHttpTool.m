//
//  CSBaseHttpTool.m
//  CloudSong
//
//  Created by EThank on 15/4/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseHttpTool.h"
#import "CSHttpTool.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
@implementation CSBaseHttpTool
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    [CSHttpTool get:url params:[param isKindOfClass:[NSMutableDictionary class]]?param:[param keyValues] success:^(id responseObj) {
        if (success) {
            if (responseObj != nil) {
                id result = [resultClass objectWithKeyValues:responseObj];
                success(result);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithNetWarningUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    [self getWithUrl:url param:param resultClass:resultClass success:success failure:^(NSError *error) {
        if (failure) {
            switch (error.code) {
                case NET_WORK_TIME_OUT:
                    [SVProgressHUD showErrorWithStatus:@"网络超时,请稍后再试"];
                    break;
                case NET_WORK_ERROR:
                case NET_WORK_BREAK:
                case NET_WORK_BREAK_1:
                    [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
                    break;
                default:
                    [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld",error.code]];
                    break;
            }
            failure(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    [CSHttpTool post:url params:[param isKindOfClass:[NSMutableDictionary class]]?param:[param keyValues] success:^(id responseObj) {
        if (success) {
            id result = [resultClass objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postForUploadWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass uploadImage:(UIImage *)image success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    [CSHttpTool post:url parameters:[param isKindOfClass:[NSMutableDictionary class]]?param:[param keyValues] uploadData:data success:^(id responseObj) {
        if (success) {
            id result = [resultClass objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}
@end
