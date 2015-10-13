//
//  CSHttpTool.h
//  CloudSong
//
//  Created by EThank on 15/4/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error)) failure;

+ (void)post:(NSString *)url parameters:(NSDictionary *)params uploadData:(NSData *)uploadData success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
