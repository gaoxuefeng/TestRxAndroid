//
//  NBAddressResponseModel.m
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAddressResponseModel.h"
#import <MJExtension.h>
@implementation NBAddressResponseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"address":@"data"};
}
//
//+ (NSDictionary *)objectClassInArray
//{
//    return @{@"addressed":[NBAddressModel class]};
//}
@end
