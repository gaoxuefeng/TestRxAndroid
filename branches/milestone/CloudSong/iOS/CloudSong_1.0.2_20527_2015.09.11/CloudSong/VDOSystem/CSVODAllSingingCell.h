//
//  CSVODAllSingingCell.h
//  CloudSong
//
//  Created by youmingtaizi on 7/10/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseTableViewCell.h"

@protocol CSVODAllSingingCellDelegate;
@class CSSong;

@interface CSVODAllSingingCell : CSBaseTableViewCell
@property (nonatomic, weak)id<CSVODAllSingingCellDelegate>  delegate;
- (void)setDataWithSong:(CSSong *)song;
@end

@protocol CSVODAllSingingCellDelegate <NSObject>
- (void)allSingingCell:(CSVODAllSingingCell *)cell didSelectSong:(CSSong *)song;
@end
