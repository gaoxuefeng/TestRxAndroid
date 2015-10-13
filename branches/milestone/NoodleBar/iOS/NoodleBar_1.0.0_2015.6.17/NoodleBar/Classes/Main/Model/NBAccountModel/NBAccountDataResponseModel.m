//
//  NBAccountDataResponseModel.m
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAccountDataResponseModel.h"
#import <MJExtension.h>
@implementation NBAccountDataResponseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"addresses":@"address",@"account":@"userinfo"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"addresses":[NBAddressModel class]};
}
@end
