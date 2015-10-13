//
//  NBRequestModel.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBRequestModel.h"
#import "NBAccountTool.h"
#import <MJExtension.h>
@implementation NBRequestModel

- (NSString *)token
{
    return [NBAccountTool userToken];
}

- (NSString *)userid
{
    return [NBAccountTool userId];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cityName":@"cityname"};
}
@end
