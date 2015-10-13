//
//  NBGetAppAdResponseModel.m
//  NoodleBar
//
//  Created by sen on 6/2/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBGetAppAdResponseModel.h"
#import <MJExtension.h>
@implementation NBGetAppAdResponseModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[NBMerchantPictureModel class]};
}
@end
