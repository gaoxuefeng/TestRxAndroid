//
//  CSPlayerView.h
//  CloudSong
//
//  Created by EThank on 15/6/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  中间黑色光盘视图

#import <UIKit/UIKit.h>

@interface CSPlayerView : UIView
/** 顶部播放杆view */
@property (nonatomic, weak) UIImageView *playerNeedleView ;
// 传递一个模型
//@property (nonatomic, strong) Model *model ;
// 重写model的set方法

// 供外界调用以便控制其状态
- (void)removeLink ;
- (void)addLink ;

@end
