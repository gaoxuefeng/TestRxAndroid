//
//  CSRoomSongsResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/5/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRoomSongsResponse.h"
#import <MJExtension.h>
#import "CSRoomSongData.h"

@implementation CSRoomSongsResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSRoomSongData class]};
}

@end
