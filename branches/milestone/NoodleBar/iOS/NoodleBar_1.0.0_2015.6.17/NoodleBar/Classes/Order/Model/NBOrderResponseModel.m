//
//  NBOrderResponseModel.m
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderResponseModel.h"
#import <MJExtension.h>
@implementation NBOrderResponseModel


+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[NBOrderModel class]};
}
@end
