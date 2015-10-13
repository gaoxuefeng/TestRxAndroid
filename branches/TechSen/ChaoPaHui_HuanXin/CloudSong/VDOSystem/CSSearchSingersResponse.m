//
//  CSSearchSingersResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/6/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSearchSingersResponse.h"
#import <MJExtension.h>
#import "CSSinger.h"

@implementation CSSearchSingersResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSinger class]};
}

@end
