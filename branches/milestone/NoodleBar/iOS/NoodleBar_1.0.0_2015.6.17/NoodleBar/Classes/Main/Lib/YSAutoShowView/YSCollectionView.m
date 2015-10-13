//
//  YSCollectionView.m
//  YSAutoShowView
//
//  Created by Sen on 15/3/23.
//  Copyright (c) 2015年 Sen. All rights reserved.
//

#import "YSCollectionView.h"

@implementation YSCollectionView



- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
@end
