//
//  CSCircleImageSelectorView.m
//  CloudSong
//
//  Created by sen on 15/6/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCircleImageSelectorView.h"

@interface CSCircleImageSelectorView ()
@property(nonatomic, assign) CGRect circleRect;
@end

@implementation CSCircleImageSelectorView


- (instancetype)initWithCircleRect:(CGRect)rect
{
    _circleRect =  rect;

    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGFloat borderW = _circleRect.size.width + 2;
    CGFloat borderH = _circleRect.size.height + 2;
    CGFloat borderX = _circleRect.origin.x - 1;
    CGFloat bodderY = _circleRect.origin.y - 1;
    CGContextAddEllipseInRect(ctx, CGRectMake(borderX, bodderY, borderW, borderH));
    CGContextFillPath(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextAddEllipseInRect(ctx, _circleRect);
    CGContextFillPath(ctx);
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
