//
//  NBHttpTool.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBRequestModel.h"
@interface NBHttpTool : NSObject
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)postForUploadWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass uploadImage:(UIImage *)image success:(void (^)(id responseObj))success failure:(void (^)(NSError *))failure;
@end
