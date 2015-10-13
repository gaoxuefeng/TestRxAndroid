//
//  CSBaseHttpTool.h
//  CloudSong
//
//  Created by EThank on 15/4/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSRequest.h"
#import "CSRequestUrl.h"
@interface CSBaseHttpTool : NSObject
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)getWithNetWarningUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)postForUploadWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass uploadImage:(UIImage *)image success:(void (^)(id responseObj))success failure:(void (^)(NSError *))failure;
@end
