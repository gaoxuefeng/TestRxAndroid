//
//  CSSearchSongsBySingerResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 7/6/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSearchSongsBySingerResponse.h"
#import "CSSong.h"
#import <MJExtension.h>

@implementation CSSearchSongsBySingerResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSong class]};
}

@end
