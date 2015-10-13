//
//  CSSongCategoryCell.h
//  CloudSong
//
//  Created by youmingtaizi on 6/10/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSSongCategoryItem;

@interface CSSongCategoryCell : UICollectionViewCell
- (void)setDataWithCategory:(CSSongCategoryItem *)category;
@end
