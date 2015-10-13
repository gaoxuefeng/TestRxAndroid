//
//  CSRecommendedAlbumCollectionCell.h
//  CloudSong
//
//  Created by youmingtaizi on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
// 推荐专辑

#import "CSBaseCollectionViewCell.h"

@class CSRecommendedAlbum;

@interface CSRecommendedAlbumCollectionCell : CSBaseCollectionViewCell
- (void)setDataWithAlbum:(CSRecommendedAlbum *)album;
@end
