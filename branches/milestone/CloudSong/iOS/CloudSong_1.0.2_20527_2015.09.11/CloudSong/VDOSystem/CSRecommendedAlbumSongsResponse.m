//
//  CSRecommendedAlbumSongsResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/17/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRecommendedAlbumSongsResponse.h"
#import <MJExtension.h>
#import "CSSong.h"

@implementation CSRecommendedAlbumSongsResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data": [CSSong class]};
}

@end
