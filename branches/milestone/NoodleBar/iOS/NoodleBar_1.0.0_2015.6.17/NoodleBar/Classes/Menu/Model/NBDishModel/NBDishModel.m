//
//  NBDishModel.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBDishModel.h"
#import <MJExtension.h>
@implementation NBDishModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"dishID":@"dishid",@"name":@"dishname",@"soldAmount":@"soldnum",@"amount":@"dishnum",@"type":@"dishtype",@"merchantID":@"businessid",@"actualPrice":@"unitprice"};
}

@end
