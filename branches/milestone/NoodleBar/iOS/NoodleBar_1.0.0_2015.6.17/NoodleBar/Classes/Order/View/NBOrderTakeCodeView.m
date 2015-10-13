//
//  NBOrdertakeCodeView.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrdertakeCodeView.h"

@interface NBOrderTakeCodeView()
@property(nonatomic, weak) UIButton *takeCodeButton;

@end

@implementation NBOrderTakeCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews
{
    UIButton *takeCodeButton = [[UIButton alloc] initForAutoLayout];
    [takeCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    takeCodeButton.titleLabel.font = [UIFont systemFontOfSize:26.f];
    _takeCodeButton = takeCodeButton;
    [self addSubview:takeCodeButton];
    [takeCodeButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [takeCodeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:31.f];
    
    UILabel *takeCodeLabel = [[UILabel alloc] initForAutoLayout];
    takeCodeLabel.text = @"取餐号";
    takeCodeLabel.font = [UIFont systemFontOfSize:15.f];
    takeCodeLabel.textColor = HEX_COLOR(0x777777);
    [self addSubview:takeCodeLabel];
    [takeCodeLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [takeCodeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:22.f];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] initForAutoLayout];
    bottomDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self addSubview:bottomDivider];
    [bottomDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [bottomDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
}

- (void)setStatusType:(NBOrderStatusType)statusType
{
    _statusType = statusType;
    NSString *bgName = nil;
    switch (statusType) {
        case NBOrderStatusTypeJustPay:
            bgName = @"order_just_pay";
            break;
        case NBOrderStatusTypeInMaking:
            bgName = @"order_in_make";
            break;
        case NBOrderStatusTypeWaitingForTaking:
            bgName = @"order_wait_take";
            break;
        default:
            break;
    }
    [_takeCodeButton setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
}
- (void)setTakeCode:(NSString *)takeCode
{
    _takeCode = takeCode;
    [_takeCodeButton setTitle:takeCode forState:UIControlStateNormal];
}
@end
