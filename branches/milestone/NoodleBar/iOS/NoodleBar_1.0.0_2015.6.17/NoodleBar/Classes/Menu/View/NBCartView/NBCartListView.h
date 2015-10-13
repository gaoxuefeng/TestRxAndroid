//
//  NBCartListView.h
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCartListHeaderView.h"
#define CART_LIST_CELL_HEIGHT 43.f
@interface NBCartListView : UIView

@property(nonatomic, strong) NSMutableArray *items;


/**
 *  清空全部按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)cleanAllBtnaddTarget:(id)target Action:(SEL)sel;
@end
