//
//  CSSearchSongsResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/6/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSearchSongsResponse.h"
#import <MJExtension.h>
#import "CSSong.h"

@implementation CSSearchSongsResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSong class]};
}

@end
