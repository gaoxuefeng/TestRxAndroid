//
//  NBPayResponseModel.m
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayResponseModel.h"
#import <MJExtension.h>
@implementation NBPayResponseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"order":@"data"};
}
@end
