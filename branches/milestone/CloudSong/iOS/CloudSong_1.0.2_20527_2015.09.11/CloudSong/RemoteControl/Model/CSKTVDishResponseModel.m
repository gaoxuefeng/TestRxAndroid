//
//  CSKTVDishResponseModel.m
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSKTVDishResponseModel.h"
#import <MJExtension.h>
@implementation CSKTVDishResponseModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"amount":@"num",@"name":@"gName",@"price":@"gPrice"};
}
@end
