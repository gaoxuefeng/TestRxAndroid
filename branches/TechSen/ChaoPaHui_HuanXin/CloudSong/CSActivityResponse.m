//
//  CSActivityResponse.m
//  CloudSong
//
//  Created by 汪辉 on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSActivityResponse.h"
#import <MJExtension.h>
#import "CSActivityModel.h"

@implementation CSActivityResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSActivityModel class]};
}
@end
