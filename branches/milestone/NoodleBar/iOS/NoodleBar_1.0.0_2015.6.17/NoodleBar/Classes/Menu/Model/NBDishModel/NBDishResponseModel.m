//
//  NBDishResponseModel.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBDishResponseModel.h"
#import <MJExtension.h>
@implementation NBDishResponseModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[NBDishModel class]};
}

@end
