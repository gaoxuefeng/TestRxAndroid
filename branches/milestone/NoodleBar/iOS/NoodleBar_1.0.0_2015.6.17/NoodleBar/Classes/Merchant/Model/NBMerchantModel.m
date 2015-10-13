//
//  NBMerchantModel.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMerchantModel.h"
#import <MJExtension.h>
@implementation NBMerchantModel


+ (NSDictionary *)objectClassInArray
{
    return @{@"promots":[NBMerchantPromotModel class]};
}

@end
