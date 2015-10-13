//
//  CSHotSingersResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSHotSingersResponse.h"
#import "CSSinger.h"
#import <MJExtension.h>

@implementation CSHotSingersResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSinger class]};
}

@end
