//
//  CSRecordPlayView.h
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDefine.h"

@class CSRecordPlayView ;

@protocol RecordPlayViewDelegate <NSObject>
@optional

// 控制播放状态（暂停、播放）
- (void)recordPlayView:(CSRecordPlayView *)recordPlayView playStatus:(CSPlayStatus)playStatus ;

// 改变进度（快进、退进）
- (void)recordPlayView:(CSRecordPlayView *)recordPlayView changeProgress:(CGFloat )progressValue ;

@end

@interface CSRecordPlayView : UIView


/** 总时长 */
@property (nonatomic, assign) double duration ;
@property (nonatomic, assign) id <RecordPlayViewDelegate> delegate ;

// 外界调用
- (void)removeTimer;
- (void)addTimer ;

@end
