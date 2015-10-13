//
//  CSHomeActivityResponse.m
//  CloudSong
//
//  Created by EThank on 15/7/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeActivityResponse.h"
#import "CSActivityModel.h"
#import <MJExtension.h>

@implementation CSHomeActivityResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CSActivityModel class]} ;
}

@end
