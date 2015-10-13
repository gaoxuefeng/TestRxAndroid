//
//  CSSongsByCategoryResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongsByCategoryResponse.h"
#import "CSSong.h"
#import <MJExtension.h>

@implementation CSSongsByCategoryResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSong class]};
}

@end
