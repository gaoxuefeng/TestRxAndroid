//
//  UIColor+Extension.h
//  ZhaiBuZhu
//
//  Created by sen on 14-10-12.
//  Copyright (c) 2014年 hikomobile. All rights reserved.
//  UIColor分类,封装了16进制颜色的方法

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
/**
 *  根据输入的6位16进制显示颜色
 *
 *  @param color 输入的6位16进制的参数
 *
 *  @return UIColor颜色
 */
+ (UIColor *)colorWithHexString: (NSString *)color;
@end
