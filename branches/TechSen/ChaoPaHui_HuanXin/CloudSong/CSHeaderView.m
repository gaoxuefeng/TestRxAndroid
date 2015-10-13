//
//  CSHeaderView.m
//  CloudSong
//
//  Created by Ethank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHeaderView.h"
#import "CSFindThemeModel.h"
#import "CSDefine.h"

@implementation CSHeaderView
- (instancetype)init{
    self = [super init];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        
        [self addSubview:_scrollView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat scrollViewX = TRANSFER_SIZE(8);
    CGFloat scrollViewY = TRANSFER_SIZE(9);
    CGFloat scrollViewW = SCREENWIDTH - 2*TRANSFER_SIZE(8);
    CGFloat scrollViewH = TRANSFER_SIZE(140);
    _scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
}
- (void)setThemeModel:(CSFindThemeModel *)themeModel
{
    
}
@end
