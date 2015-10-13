//
//  NBTopView.m
//  NoodleBar
//
//  Created by sen on 15/5/4.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBTopView.h"

@implementation NBTopView
- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        //自动将事件传递到上一层
        return nil;
    }
    return hitView;
}
@end
