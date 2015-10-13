//
//  CSSingerHeaderView.h
//  CloudSong
//
//  Created by EThank on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSSinger;
@protocol CSSingerHeaderViewDelegate;

@interface CSSingerHeaderView : UIView
@property (nonatomic, weak)id<CSSingerHeaderViewDelegate>  delegate;
@end

@protocol CSSingerHeaderViewDelegate <NSObject>
- (void)singerHeaderView:(CSSingerHeaderView *)view didSelectSinger:(CSSinger *)singer;
@end