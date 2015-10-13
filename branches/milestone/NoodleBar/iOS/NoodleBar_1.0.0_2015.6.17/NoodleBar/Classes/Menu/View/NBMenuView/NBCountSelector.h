//
//  NBCountSelector.h
//  NoodleBar
//
//  Created by TechSen on 15/4/9.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBCountSelector;

@protocol NBCountSelectorDelegate <NSObject>
@optional
/**
 *  数量改变回调方法
 *
 *  @param countSelector 数量选择器
 *  @param count         数量
 */
- (void)countSelector:(NBCountSelector *)countSelector DidClickBtnToChangeCount:(int)count;


//- (void)countSelector:(NBCountSelector *)countSelector plusButtonDidClick:(UIButton *)button;


@end

@interface NBCountSelector : UIView
/**
 *  可设置的数量
 */
@property(nonatomic, assign) int amount;
@property(nonatomic, weak) id<NBCountSelectorDelegate> delegate;
///**
// *  数量选择器宽度约束
// */
//@property(nonatomic, weak) NSLayoutConstraint *countSelectorWidthConstraint;

@end
