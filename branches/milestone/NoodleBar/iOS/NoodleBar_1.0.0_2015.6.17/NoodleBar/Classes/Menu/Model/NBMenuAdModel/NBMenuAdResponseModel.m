//
//  NBMenuAdResponseModel.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMenuAdResponseModel.h"
#import <MJExtension.h>
@implementation NBMenuAdResponseModel


+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[NBMenuAdModel class]};
}
@end
