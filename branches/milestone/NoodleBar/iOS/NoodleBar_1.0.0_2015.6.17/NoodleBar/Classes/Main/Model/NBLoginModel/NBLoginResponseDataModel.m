//
//  NBLoginResponseDataModel.m
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBLoginResponseDataModel.h"
#import <MJExtension.h>
@implementation NBLoginResponseDataModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
