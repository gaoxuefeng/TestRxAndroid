//
//  CSRecommendedAlbumsData.m
//  CloudSong
//
//  Created by youmingtaizi on 6/5/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRecommendedAlbumsData.h"
#import <MJExtension.h>
#import "CSRecommendedAlbum.h"

@implementation CSRecommendedAlbumsData

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"albums" : @"theme"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"albums" : [CSRecommendedAlbum class]};
}

@end
