//
//  CSDiscoveryDataResponse.m
//  CloudSong
//
//  Created by EThank on 15/7/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSDiscoveryRecordsResponse.h"
#import "CSRecordsModel.h" 
#import <MJRefresh.h>

@implementation CSDiscoveryRecordsResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSRecordsModel class]};
}

@end
