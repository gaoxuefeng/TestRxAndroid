//
//  NBAddAddressButton.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAddAddressButton.h"
#import "NBCommon.h"
@implementation NBAddAddressButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{

    
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self setTitleColor:HEX_COLOR(0xf56800) forState:UIControlStateNormal];
    // 上分割线
    UIView *topDivider = [[UIView alloc] initForAutoLayout];
    topDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self addSubview:topDivider];
    [topDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [topDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] initForAutoLayout];
    bottomDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self addSubview:bottomDivider];
    [bottomDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [bottomDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    
    
    
}
@end
