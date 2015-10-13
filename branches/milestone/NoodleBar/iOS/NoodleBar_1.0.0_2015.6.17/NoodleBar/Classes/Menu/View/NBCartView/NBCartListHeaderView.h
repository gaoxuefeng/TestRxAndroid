//
//  NBCartListHeaderView.h
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CART_HEADER_HEIGHT 30.f
@interface NBCartListHeaderView : UIView


/**
 *  清空全部按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)cleanAllBtnaddTarget:(id)target action:(SEL)sel;
@end
