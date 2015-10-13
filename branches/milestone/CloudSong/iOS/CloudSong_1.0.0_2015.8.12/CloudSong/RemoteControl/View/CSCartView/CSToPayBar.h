//
//  CSToPayBar.h
//  CloudSong
//
//  Created by sen on 5/26/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//  支付bar

#import <UIKit/UIKit.h>
#define TO_PAY_BAR_HEIGHT TRANSFER_SIZE(44.0)
@interface CSToPayBar : UIView
- (void)setPrice:(float)price;
/**
 *  支付按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)payButtonAddTarget:(id)target action:(SEL)sel;
@property(nonatomic, assign,getter = isCartShowing) BOOL cartShowing;
@property(nonatomic, copy) NSString *payButtonTitle;
/** 立即支付按钮 */
@property(nonatomic, weak) UIButton *payButton;
@end
