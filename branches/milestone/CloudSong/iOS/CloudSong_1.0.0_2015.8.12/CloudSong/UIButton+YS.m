//
//  UIButton+YS.m
//  CloudSong
//
//  Created by sen on 15/6/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "UIButton+YS.h"
#import <objc/runtime.h>
@implementation UIButton (YS)
+ (void)load
{
    Method customMethod = class_getClassMethod([UIButton class], @selector(buttonWithType:));
    Method originMethod = class_getClassMethod([UIButton class], @selector(custombuttonWithType:));
    method_exchangeImplementations(customMethod, originMethod);
}

+ (instancetype)custombuttonWithType:(UIButtonType)buttonType
{
    UIButton *button = [self custombuttonWithType:buttonType];
    button.exclusiveTouch = YES;
    return button;
}


@end
