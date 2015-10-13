//
//  NBPayHttpTool.m
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayHttpTool.h"
#import "NBCommon.h"
@implementation NBPayHttpTool
+ (void)submitOrderWithParam:(NBRequestModel *)param success:(void(^)(NBPayResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:SUBMIT_ORDER_URL param:param resultClass:[NBPayResponseModel class] success:success failure:failure];
}

+ (void)getTakeCodeWithParam:(NBRequestModel *)param success:(void(^)(NBGetTakeCodeResponseModel *result))success failure:(void(^)(NSError *error))failure
{
    [self postWithUrl:GET_TAKE_CODE_URL param:param resultClass:[NBGetTakeCodeResponseModel class] success:success failure:failure];
}
@end
