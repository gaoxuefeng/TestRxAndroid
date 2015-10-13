//
//  CSNewSongsResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSNewSongsResponse.h"
#import "CSSong.h"
#import <MJExtension.h>

@implementation CSNewSongsResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSong class]};
}

@end
