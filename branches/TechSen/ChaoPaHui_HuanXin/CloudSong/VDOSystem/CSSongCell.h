//
//  CSSongCell.h
//  CloudSong
//
//  Created by youmingtaizi on 7/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseTableViewCell.h"

@protocol CSSongCellDelegate;
@class CSSong;

@interface CSSongCell : CSBaseTableViewCell
@property (nonatomic, weak)id<CSSongCellDelegate>  delegate;
- (void)setDataWithSong:(CSSong *)song;
@end

@protocol CSSongCellDelegate <NSObject>
- (void)songCell:(CSSongCell *)cell didSelectSong:(CSSong *)song;

@end
