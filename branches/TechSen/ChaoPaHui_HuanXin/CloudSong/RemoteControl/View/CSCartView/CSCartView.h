//
//  CSCartView.h
//  CloudSong
//
//  Created by sen on 15/5/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCartButton.h"

@interface CSCartView : UIView
@property(nonatomic, weak) CSCartButton *cartButton;
/**
 *  支付按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)payButtonAddTarget:(id)target action:(SEL)sel;
@end
