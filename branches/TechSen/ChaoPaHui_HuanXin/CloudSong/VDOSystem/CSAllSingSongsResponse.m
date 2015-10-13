//
//  CSAllSingSongsResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSAllSingSongsResponse.h"
#import <MJExtension.h>
#import "CSSong.h"

@implementation CSAllSingSongsResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSong class]};
}

@end
