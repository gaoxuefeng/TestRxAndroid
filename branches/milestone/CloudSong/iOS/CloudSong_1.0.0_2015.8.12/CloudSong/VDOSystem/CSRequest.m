//
//  CSRequest.m
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRequest.h"
#import <MJExtension.h>
#import "Header.h"
//#import "CSDishModel.h"
@implementation CSRequest

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"password":@"passWord",@"ID":@"id",@"alterPassword":@"newPassword"};
}

//+ (NSDictionary *)objectClassInArray
//{
//    return @{@"goodsList":[CSDishModel class]};
//}

- (NSString *)token
{
    return GlobalObj.token;
}

- (NSString *)dev
{
    return @"1";
}

- (NSString *)did
{
    return [PublicMethod idfa];
}

- (NSString *)rom
{
    return [UIDevice currentDevice].systemVersion;
}





@end
