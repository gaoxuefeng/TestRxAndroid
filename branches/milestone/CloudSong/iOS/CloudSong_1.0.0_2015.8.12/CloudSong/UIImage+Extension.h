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

//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  截图
 */
+ (UIImage*)screenshotWithView:(UIView*)view;

- (UIImage *)getPartOfrect:(CGRect)partRect;

- (UIImage *)clipImageInRect:(CGRect)rect;

+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;

// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;
// 保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

/**
 *  圆形裁切
 *
 *  @param name        图片名
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return 裁切后的图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
