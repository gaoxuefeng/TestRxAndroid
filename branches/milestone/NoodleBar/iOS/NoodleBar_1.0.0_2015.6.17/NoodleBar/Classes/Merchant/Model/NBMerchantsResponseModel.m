//
//  NBMerchantsResponseModel.m
//  NoodleBar
//
//  Created by sen on 6/3/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBMerchantsResponseModel.h"
#import <MJExtension.h>
@implementation NBMerchantsResponseModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[NBMerchantModel class]};
}
@end
