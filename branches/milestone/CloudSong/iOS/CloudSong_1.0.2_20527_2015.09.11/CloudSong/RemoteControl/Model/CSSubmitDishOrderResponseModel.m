//
//  CSSubmitDishOrderResponseModel.m
//  CloudSong
//
//  Created by sen on 15/7/2.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSubmitDishOrderResponseModel.h"
#import "CSDishModel.h"
#import <MJExtension.h>
@implementation CSSubmitDishOrderResponseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"goodsList":[CSDishModel class]};
}

@end
