//
//  CSSegmentControl.h
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSSegmentControl;
@protocol CSSegmentControlDelegate <NSObject>


/**
 *  此方法用于获取当前被选中索引
 *
 *  @param selectedIndex 被选中索引
 */
- (void)selectedChanged:(NSInteger)selectedIndex;
@end



@interface CSSegmentControl : UIView
/** 标题 */
@property(nonatomic, strong ,readonly) NSArray *titles;
/** 选中状态下文字颜色 */
@property(nonatomic, strong) UIColor *selectedTitleColor;
/** 未选中状态下文字颜色 */
@property(nonatomic, strong) UIColor *titleColor;
/** 滑块颜色 */
@property(nonatomic, strong) UIColor *blockColor;
/** 滑块内边距 */
@property(nonatomic, assign) UIEdgeInsets blockEdgeInsets;
/** 滑块高度 */
@property(nonatomic, assign) CGFloat blockHeight;
/** 当前索引 默认为0*/
@property(nonatomic, assign ,readonly) NSInteger currentIndex;
/** 滑块距离左边的距离 */
@property(nonatomic, assign) CGFloat blockX;
/** 被托管的scrollView 不能为空*/
@property(nonatomic, weak) UIScrollView *scrollView;

/** 代理 */
@property(nonatomic, weak) id<CSSegmentControlDelegate> delegate;


- (instancetype)initWithTitles:(NSArray *)titles;


- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;
@end
