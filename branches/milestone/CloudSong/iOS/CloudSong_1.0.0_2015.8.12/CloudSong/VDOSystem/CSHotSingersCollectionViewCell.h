//
//  CSHotSingersCollectionViewCell.h
//  CloudSong
//
//  Created by youmingtaizi on 6/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseCollectionViewCell.h"

@class CSSinger;

@interface CSHotSingersCollectionViewCell : CSBaseCollectionViewCell
- (void)setDataWithSingerItem:(CSSinger *)singerItem;
@end
