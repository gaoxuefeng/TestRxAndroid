//
//  CSGetPlayerDataResponse.m
//  CloudSong
//
//  Created by EThank on 15/7/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSDiscoveryPlayerResponse.h"
#import "CSPlayingModel.h"
#import <MJRefresh.h>

@implementation CSDiscoveryPlayerResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSPlayingModel class]};
}

@end
