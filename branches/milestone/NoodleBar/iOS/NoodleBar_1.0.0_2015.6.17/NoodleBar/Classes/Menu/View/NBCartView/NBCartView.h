//
//  NBCartView.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCartButton.h"
#define CART_VIEW_HEIGHT 43.f
@interface NBCartView : UIView
@property(nonatomic, weak) NBCartButton *cartButton;
/**
 *  购物车view的高度约束
 */
@property(nonatomic, weak) NSLayoutConstraint *cartViewHeightConstraint;
/**
 *  支付按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)payButtonAddTarget:(id)target action:(SEL)sel;

@end
