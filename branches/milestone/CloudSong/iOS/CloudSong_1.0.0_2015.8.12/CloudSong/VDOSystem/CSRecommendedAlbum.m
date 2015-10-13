//
//  CSAlbum.m
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRecommendedAlbum.h"
#import <MJExtension.h>

@implementation CSRecommendedAlbum

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"identifier" : @"themeId"};
}

+ (NSArray *)ignoredPropertyNames {
    return @[@"image"];
}

@end
