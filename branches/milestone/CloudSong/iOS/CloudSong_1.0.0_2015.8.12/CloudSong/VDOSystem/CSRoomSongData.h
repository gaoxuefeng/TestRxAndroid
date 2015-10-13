//
//  CSRoomSongData.h
//  CloudSong
//
//  Created by youmingtaizi on 6/5/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSSong;

@interface CSRoomSongData : NSObject
@property (nonatomic, strong)CSSong*    song;
@property (nonatomic, strong)NSNumber*  roomSongId;
@property (nonatomic, strong)NSString*  headUrl;
@property (nonatomic, strong)NSString*  userName;


@end
