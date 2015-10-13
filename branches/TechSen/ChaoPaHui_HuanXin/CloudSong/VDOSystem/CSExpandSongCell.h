//
//  CSExpandSongCell.h
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseTableViewCell.h"
#import "CSRoomSongData.h"

@class CSSong;
@interface CSExpandSongCell : CSBaseTableViewCell
- (void)setDataWithSong:(CSSong *)song;
- (void)setState:(BOOL)state;
@property(nonatomic,strong)CSRoomSongData * roomSong;
@property(nonatomic,strong)UIImageView * songPlaying;
@property(nonatomic,strong)UIButton*  arrowBut;
@end
