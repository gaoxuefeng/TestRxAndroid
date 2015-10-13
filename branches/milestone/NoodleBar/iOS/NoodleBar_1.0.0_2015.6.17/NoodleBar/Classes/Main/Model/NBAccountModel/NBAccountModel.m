//
//  NBAccountModel.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAccountModel.h"
#import <MJExtension.h>
#import "NBAccountTool.h"
@implementation NBAccountModel

- (NSMutableArray *)addresses
{
    if (!_addresses) {
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"gender":@"sex"};
}


//+ (NSDictionary *)objectClassInArray
//{
//    return @{
//        @"addresses":[NBAccountModel class]
//    };
//}

- (void)setToken:(NSString *)token
{
    _token = token;
    [NBAccountTool setUserToken:_token];
}


@end
