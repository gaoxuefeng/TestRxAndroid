//
//  CSHomeActivityTagResponse.m
//  CloudSong
//
//  Created by EThank on 15/8/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeActivityTagResponse.h"
#import "CSHomeActivityTagModel.h"
#import <MJRefresh.h>
@implementation CSHomeActivityTagResponse
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CSHomeActivityTagModel class]} ;
}

@end
