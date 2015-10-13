//
//  CSMyRecordResponse.m
//  CloudSong
//
//  Created by EThank on 15/7/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyRecordResponse.h"
#import <MJRefresh.h>
#import "CSMyRecordModel.h"

@implementation CSMyRecordResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CSMyRecordModel class]} ;
}

@end
