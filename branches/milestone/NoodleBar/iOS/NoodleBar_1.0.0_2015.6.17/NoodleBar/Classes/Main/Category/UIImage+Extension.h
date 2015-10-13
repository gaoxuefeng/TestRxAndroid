//
//  UIImage+Extension.h
//  ZhaiBuZhu
//
//  Created by sen on 14-10-12.
//  Copyright (c) 2014年 hikomobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
- (UIImage *)resizedImage;

/** 返回一张纯色图 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
