//
//  CoverView.h
//  TeMe
//
//  Created by dyLiu on 15/3/23.
//  Copyright (c) 2015年 dyLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFindThemeModel.h"
@class BgView;
// 加载前的本地图片占位符，此为图片文件名
#define CoverViewDefaultImage @"schedule_scroll_default_img"

/**
 * 用于创建UIScrollView和UIPageControl的图片展示封面
 * 支持循环滚动，动画，异步加载图片
 */
@interface CoverView : UIView<UIScrollViewDelegate>

// 主要的可视化控件
@property (nonatomic, strong)BgView * bgView;
@property (nonatomic, strong)UILabel * periodLab;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *models; // 一个包含CSFindThemeModel的数组
@property (nonatomic, copy) NSString *placeholderImageNamed; // 图片载入前的本地占位图片名字符串
@property (nonatomic, copy) void(^callBlock)(NSInteger); // 点击后的调用的block
@property (nonatomic, copy) void(^scrollViewCallBlock)(NSInteger); // 视图滚动后回调
@property (nonatomic, assign) UIViewAnimationOptions animationOption; // 动画选项（可选）
@property (nonatomic, assign) UIViewContentMode imageViewsContentMode; // 图片的内容模式，默认为UIViewContentModeScaleToFill

- (id)initWithModels:(NSArray *)models andFrame:(CGRect)frame;

/**
 * 快速创建CoverView
 * @param models是一个包含CoverModel的数组
 * @param placeholderImageNamed为图片加载前的本地占位图片名
 */
+ (id)coverViewWithModels:(NSArray *)models andFrame:(CGRect)frame andPlaceholderImageNamed:(NSString *)placeholderImageNamed andClickdCallBlock:(void (^)(NSInteger index))callBlock;


/** 如果用init创建CoverView，则需要更新视图才能够正常使用 */
- (void)updateView;

/** 设置图片点击后的块回调 */
- (void)setCallBlock:(void (^)(NSInteger index))callBlock;

/** 视图滚动后的回调 */
- (void)setScrollViewCallBlock:(void (^)(NSInteger index))scrollViewCallBlock;

/** 设置自动播放 */
- (void)setAutoPlayWithDelay:(NSTimeInterval)second;

/** 停止或恢复自动播放（在设置了自动播放时才有效） */
- (void)stopAutoPlayWithBOOL:(BOOL)isStopAutoPlay;

/**
 * 设置切换时的动画选项，不设置则默认为scrollView滚动动画
 * 提供的动画类型有：
 *   UIViewAnimationOptionTransitionNone
 *   UIViewAnimationOptionTransitionFlipFromLeft
 *   UIViewAnimationOptionTransitionFlipFromRight
 *   UIViewAnimationOptionTransitionCurlUp
 *   UIViewAnimationOptionTransitionCurlDown
 *   UIViewAnimationOptionTransitionCrossDissolve
 *   UIViewAnimationOptionTransitionFlipFromTop
 *   UIViewAnimationOptionTransitionFlipFromBottom
 */
- (void)setAnimationOption:(UIViewAnimationOptions)animationOption;


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
