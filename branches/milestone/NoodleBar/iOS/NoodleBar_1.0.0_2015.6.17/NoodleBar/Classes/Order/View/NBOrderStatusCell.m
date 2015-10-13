//
//  NBOrderStatusCell.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderStatusCell.h"
#import "NBCommon.h"
#define H_MARGIN 15.f
@interface NBOrderStatusCell ()
@property(nonatomic, weak) UIButton *statusButton;
@end

@implementation NBOrderStatusCell


- (instancetype)initWithStatus:(NBOrderStatusType)statusType
{
    if (self = [self init]) {
        _statusType = statusType;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setStatusType:(NBOrderStatusType)statusType
{
    _statusType = statusType;
    NSString *statusStr = nil;
    NSString *statusIconName = nil;
    switch (statusType) {
        case NBOrderStatusTypeNotPay:
            statusStr = @"待支付，请在提交订单后15分钟内完成。";
            statusIconName = @"order_status_notpay";
            break;
        case NBOrderStatusTypeCancel:
            statusStr = @"订单已取消。";
            statusIconName = @"pay_method_selected";
            break;
        case NBOrderStatusTypeJustPay:
            statusStr = @"成功付款,请等待餐厅确认接单。";
            statusIconName = @"pay_method_selected";
            break;
        case NBOrderStatusTypeInMaking:
            statusStr = @"餐厅已接单,正在制作中。";
            statusIconName = @"order_status_in_making";
            break;
        case NBOrderStatusTypeWaitingForTaking:
            statusStr = @"餐厅已准备就绪,正在配送中。";
            statusIconName = @"order_status_wait_take";
            break;
        case NBOrderStatusTypeDone:
            statusStr = @"已完成订单。";
            statusIconName = @"pay_method_selected";
            break;
        default:
            break;
    }
    [_statusButton setImage:[UIImage imageNamed:statusIconName] forState:UIControlStateNormal];
    [_statusButton setTitle:statusStr forState:UIControlStateNormal];
}

- (void)setupSubViews
{
    // 状态图文
    UIButton *statusButton = [[UIButton alloc] init];
    statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10.f, 0, 0);
    statusButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [statusButton setTitleColor:HEX_COLOR(0x969696) forState:UIControlStateNormal];
    _statusButton = statusButton;
    statusButton.userInteractionEnabled = NO;
    [self addSubview:statusButton];
    [statusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [statusButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN + 10];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] initForAutoLayout];
    bottomDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self addSubview:bottomDivider];
    [bottomDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [bottomDivider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    [bottomDivider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:H_MARGIN];
    [bottomDivider autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

@end
