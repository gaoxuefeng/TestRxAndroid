//
//  NBAddressModel.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAddressModel.h"
#import <MJExtension.h>
@implementation NBAddressModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"addressID":@"addressid",@"name":@"uname",@"phone":@"phonenum",@"address":@"detailaddress",@"gender":@"sex"};
}
@end
