//
//  CSBaseResponseDataModel.m
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSKTVDishListResponseDataModel.h"
#import <MJExtension.h>
#import "CSKTVDishResponseModel.h"
@implementation CSKTVDishListResponseDataModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"goodsList":[CSKTVDishResponseModel class]};
}
@end
