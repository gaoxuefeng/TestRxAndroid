//
//  CSPaletteView.h
//  CloudSong
//
//  Created by sen on 15/7/7.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPaletteView : UIView
/** 线条粗细 */
@property(nonatomic, assign) CGFloat lineWidth;
/** 线条颜色 */
@property(nonatomic, copy) UIColor *lineColor;

/** 返回上一步操作 */
- (void)previous;
/** 清空画板 */
- (void)clear;

- (UIImage *)getImageFromPalette;

@end
