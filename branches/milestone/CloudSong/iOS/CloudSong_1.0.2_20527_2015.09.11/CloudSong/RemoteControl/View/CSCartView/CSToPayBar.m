//
//  CSToPayBar.m
//  CloudSong
//
//  Created by sen on 5/26/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//  支付bar

#import "CSToPayBar.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSToPayBar ()
@property(nonatomic, assign) BOOL didSetupConstraint;
/** 总价Label  */
@property(nonatomic, weak) UILabel *totalPriceLabel;
/** 空购物车Label */
@property(nonatomic, weak) UILabel *emptyCartLabel;
/** 总价Label水平约束 */
@property(nonatomic, strong) MASConstraint *totalPriceLabelXconstraint;
@end

@implementation CSToPayBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x43246b);
        [self setupSubViews];
    }
    return self;
}

- (void)setPayButtonTitle:(NSString *)payButtonTitle
{
    _payButtonTitle = payButtonTitle;
    [_payButton setTitle:payButtonTitle forState:UIControlStateNormal];
}

- (void)setupSubViews
{    
    // 立即支付按钮
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    payButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    _payButton = payButton;
    [payButton setTitleColor:HEX_COLOR(0xf2f2f2) forState:UIControlStateNormal];
    payButton.backgroundColor = HEX_COLOR(0x85265f);
    [self addSubview:payButton];
    
    // 空购物车Label
    UILabel *emptyCartLabel = [[UILabel alloc] init];
    emptyCartLabel.text = @"购物车是空的";
    emptyCartLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    emptyCartLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:emptyCartLabel];
    _emptyCartLabel = emptyCartLabel;
    
    // 总金额Label
    UILabel *totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel  = totalPriceLabel;
    totalPriceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    totalPriceLabel.textColor = HEX_COLOR(0xf2f2f2);
    totalPriceLabel.hidden = YES;
    [self addSubview:totalPriceLabel];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(TRANSFER_SIZE(108.0));
        }];
        
        [self.emptyCartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(TRANSFER_SIZE(82.0));
        }];
        
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            self.totalPriceLabelXconstraint = make.left.equalTo(self).offset(TRANSFER_SIZE(82.0));
        }];
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setCartShowing:(BOOL)cartShowing
{
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.totalPriceLabelXconstraint.offset = cartShowing?TRANSFER_SIZE(15.0):TRANSFER_SIZE(82.0);
        [self layoutIfNeeded];
    }];
}

- (void)payButtonAddTarget:(id)target action:(SEL)sel
{
    [_payButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPrice:(float)price
{
    if (price > 0.f) {
//        _payButton.enabled = YES;
        _emptyCartLabel.hidden = YES;
        _totalPriceLabel.hidden = NO;
        _totalPriceLabel.text = [NSString stringWithFormat:@"合计:￥ %@",[NSString stringWithFloat:price]];
    }else
    {
//        _payButton.enabled = NO;
        _emptyCartLabel.hidden = NO;
        _totalPriceLabel.hidden = YES;
    }
}

@end
