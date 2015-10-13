//
//  NBPayMerchantCell.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayMerchantCell.h"
#import "NBCommon.h"

@interface NBPayMerchantCell ()

@property(nonatomic, weak) UIButton *actionButton;
@end

@implementation NBPayMerchantCell

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
    UILabel *textLabel = [[UILabel alloc] initForAutoLayout];
    textLabel.font = [UIFont systemFontOfSize:15.f];
    textLabel.textColor = HEX_COLOR(0x464646);
    [self addSubview:textLabel];
    [textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
    _textLabel = textLabel;
    
    UIView *divider = [[UIView alloc] initForAutoLayout];
    [self addSubview:divider];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    // 右箭头
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_cell_next"]];
    [self addSubview:arrowImage];
    [arrowImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [arrowImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.f];
}



@end
