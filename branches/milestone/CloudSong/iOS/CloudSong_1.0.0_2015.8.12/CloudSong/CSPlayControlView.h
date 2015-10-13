//
//  CSPlayControlView.h
//  CloudSong
//
//  Created by EThank on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  播放控件视图

#import <UIKit/UIKit.h>
#import "CSDefine.h"

@class CSPlayControlView ;
@protocol PlayControlViewDelegate <NSObject>
@optional
// 控制播放状态（暂停、播放）
- (void)playControlView:(CSPlayControlView *)playControlView playStatus:(CSPlayStatus)playStatus ;
// 改变进度（快进、退进）
- (void)playControlView:(CSPlayControlView *)playControlView changeProgress:(CGFloat )progressValue ;
@end

@interface CSPlayControlView : UIView

/** 播放暂停按钮 */
@property (nonatomic, weak) UIButton *playPauseBtn ;
@property (nonatomic, assign)double playTime;
/** 总时长 */
@property (nonatomic, assign) double duration ;
@property (nonatomic, weak) id <PlayControlViewDelegate> delegate ;

- (void)setDuration:(NSTimeInterval)duration;
- (void)setPlayTime:(NSTimeInterval)playTime;
- (void)setProgress:(float)progress;
@end
