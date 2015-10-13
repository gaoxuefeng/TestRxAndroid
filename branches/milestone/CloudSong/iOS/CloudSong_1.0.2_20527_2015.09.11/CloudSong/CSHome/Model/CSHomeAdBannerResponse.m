//
//  CSHomeAdBannerResponse.m
//  CloudSong
//
//  Created by EThank on 15/8/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeAdBannerResponse.h"
#import "CSHomeAdBannerModel.h"
#import <MJExtension.h>

@implementation CSHomeAdBannerResponse
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CSHomeAdBannerModel class]} ;
}
@end
