//
//  NBCover.m
//  NoodleBar
//
//  Created by sen on 5/29/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBCover.h"

@implementation NBCover

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, self.clearRect);
}

@end
