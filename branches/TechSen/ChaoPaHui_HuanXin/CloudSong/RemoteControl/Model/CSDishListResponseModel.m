//
//  CSDishListResponseModel.m
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDishListResponseModel.h"
#import <MJExtension.h>
@implementation CSDishListResponseModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[CSDishModel class]};
}
@end
