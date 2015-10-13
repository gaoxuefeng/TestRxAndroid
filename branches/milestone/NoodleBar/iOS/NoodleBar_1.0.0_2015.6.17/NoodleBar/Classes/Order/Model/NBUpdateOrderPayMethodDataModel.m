//
//  NBUpdateOrderPayMethodDataModel.m
//  NoodleBar
//
//  Created by sen on 6/9/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBUpdateOrderPayMethodDataModel.h"
#import <MJExtension.h>
@implementation NBUpdateOrderPayMethodDataModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"merchantID":@"businessid",@"merchantName":@"businessname",@"price":@"money"};
}
@end
