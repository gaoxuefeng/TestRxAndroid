//
//  NBOrderInfomationLabel.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderInfomationLabel.h"
#import "NBCommon.h"
@implementation NBOrderInfomationLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:13.f];
        self.textColor = HEX_COLOR(0x969696);
    }
    return self;
}

@end
