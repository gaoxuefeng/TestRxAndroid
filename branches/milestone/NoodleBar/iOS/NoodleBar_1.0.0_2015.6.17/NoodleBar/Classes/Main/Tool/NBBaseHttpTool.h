//
//  NBBaseHttpTool.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBBaseHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)post:(NSString *)url parameters:(NSDictionary *)params uploadData:(NSData *)uploadData success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
