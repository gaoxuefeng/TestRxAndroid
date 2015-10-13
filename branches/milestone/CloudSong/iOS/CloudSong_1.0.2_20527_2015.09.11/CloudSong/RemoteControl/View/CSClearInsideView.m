//
//  CSClearInsideView.m
//  CloudSong
//
//  Created by sen on 5/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSClearInsideView.h"

@implementation CSClearInsideView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, self.clearRect);
    
}
- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        //自动将事件传递到上一层
        return nil;
    }
    return hitView;
}
@end
