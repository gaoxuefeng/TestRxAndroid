//
//  CSDishModel.m
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDishModel.h"
#import <MJExtension.h>
@implementation CSDishModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"imgUrl":@"imgurl",@"type":@"gType",@"code":@"gCode",@"name":@"gName",@"price":@"gPrice",@"ID":@"goodsId",@"amount":@"num"};
}

@end
