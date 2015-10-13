//
//  NSString+Extension.h
//  ZhaiBuZhu
//
//  Created by sen on 14-10-13.
//  Copyright (c) 2014年 hikomobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (NSString *)stringWithFloat:(float)num;
@end
