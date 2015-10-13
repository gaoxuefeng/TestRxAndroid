//
//  CSSong.m
//  CloudSong
//
//  Created by youmingtaizi on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSong.h"
#import <MJExtension.h>

@implementation CSSong

+ (NSDictionary *)objectClassInArray {
    return @{@"singers" : [CSSinger class]};
}

//+ (NSDictionary *)replacedKeyFromPropertyName {
//    return @{@"identifier" : @"songId"};
//}

@end
