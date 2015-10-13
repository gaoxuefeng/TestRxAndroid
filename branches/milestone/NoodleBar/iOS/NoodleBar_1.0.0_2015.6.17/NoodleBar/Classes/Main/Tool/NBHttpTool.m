//
//  NBHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBHttpTool.h"
#import "NBBaseHttpTool.h"
#import <MJExtension.h>
@implementation NBHttpTool
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    [NBBaseHttpTool get:url params:[param keyValues] success:^(id responseObj) {
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

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure
{
    [NBBaseHttpTool post:url params:[param keyValues] success:^(id responseObj) {
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
    [NBBaseHttpTool post:url parameters:[param keyValues] uploadData:data success:^(id responseObj) {
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
