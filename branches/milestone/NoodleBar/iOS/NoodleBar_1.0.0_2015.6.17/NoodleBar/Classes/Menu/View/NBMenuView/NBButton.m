//
//  NBButton.m
//  NoodleBar
//
//  Created by sen on 15/4/16.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBButton.h"

@implementation NBButton

- (void)setHighlighted:(BOOL)highlighted
{

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.exclusiveTouch = YES;
    }
    return self;
}
@end
