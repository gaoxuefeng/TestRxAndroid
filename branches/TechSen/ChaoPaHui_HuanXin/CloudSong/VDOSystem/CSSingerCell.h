//
//  CSSingerCell.h
//  CloudSong
//
//  Created by youmingtaizi on 6/6/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseTableViewCell.h"

@class CSSinger;

@interface CSSingerCell : CSBaseTableViewCell
- (void)setDataWithSinger:(CSSinger *)singer;
@end
