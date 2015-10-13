//
//  NBToPayView.h
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBToPayView : UIView

- (void)setPrice:(float)price;

/**
 *  支付按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)payButtonAddTarget:(id)target action:(SEL)sel;

@property(nonatomic, assign,getter = isCartShowing) BOOL cartShowing;
@end
