//
//  CSGetSongsByLanguageResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSGetSongsByLanguageResponse.h"
#import "CSSong.h"
#import <MJExtension.h>

@implementation CSGetSongsByLanguageResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSong class]};
}

@end
