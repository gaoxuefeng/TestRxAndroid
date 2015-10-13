//
//  NSString+Extension.m
//  ZhaiBuZhu
//
//  Created by sen on 14-10-13.
//  Copyright (c) 2014年 hikomobile. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
/**
 *  计算字符串尺寸的方法
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = font;
    CGSize stringSize = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return stringSize;
}

+ (NSString *)stringWithFloat:(float)num
{
    NSString *str;
    if (fmodf(num, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.0f",num];
    }
    else if (fmodf(num*10, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.1f",num];
    }
    else
    {
        str = [NSString stringWithFormat:@"%.2f",num];
    }
    return str;
}
@end
