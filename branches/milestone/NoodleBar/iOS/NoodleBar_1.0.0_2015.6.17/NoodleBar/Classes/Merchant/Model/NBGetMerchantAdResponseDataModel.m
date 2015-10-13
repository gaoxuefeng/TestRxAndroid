//
//  NBGetMerchantAdResponseDataModel.m
//  NoodleBar
//
//  Created by sen on 6/2/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBGetMerchantAdResponseDataModel.h"
#import <MJExtension.h>
@implementation NBGetMerchantAdResponseDataModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"pictureurlList":[NBMerchantPictureModel class],@"promots":[NBMerchantPromotModel class]};
}
@end
