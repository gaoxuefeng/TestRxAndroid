//
//  NBOrderDetailResponseDataModel.m
//  NoodleBar
//
//  Created by sen on 15/4/30.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderDetailResponseDataModel.h"
#import <MJExtension.h>
@implementation NBOrderDetailResponseDataModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"orderDetails":[NBDishModel class]};
}


- (void)setIntervaltime:(int )intervaltime
{
    _intervaltime = intervaltime / 1000;
}

@end
