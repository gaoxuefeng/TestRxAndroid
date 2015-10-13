//
//  CSMyCostResponseModel.m
//  CloudSong
//
//  Created by sen on 15/7/6.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyCostResponseModel.h"
#import <MJExtension.h>
#import "CSMyCostModel.h"
@implementation CSMyCostResponseModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[CSMyCostModel class]};
}
@end
