//
//  NBToPayView.m
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBToPayView.h"
#import "NBCommon.h"
#import "NBButton.h"
#define PRICE_LABEL_MARGIN 69.f
#define PRICE_LABEL_MARGIN_WITH_CART_SHOWING 60.f

@interface NBToPayView ()
/**
 *  分割线
 */
@property(nonatomic, weak) UIView *divider;
/**
 *  购物车状态Label
 */
@property(nonatomic, weak) UILabel *cartMessageLabel;
/**
 *  支付按钮
 */
@property(nonatomic, weak) NBButton  *payButton;

/**
 *  总价
 */
@property(nonatomic, weak) UILabel *totalPriceLabel;
/**
 *  总价标题
 */
@property(nonatomic, weak) UILabel *totalPriceTitle;

@end

@implementation NBToPayView


- (void)setCartShowing:(BOOL)cartShowing
{
    
    if (cartShowing) {
        _totalPriceTitle.hidden = NO;
    }else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _totalPriceTitle.hidden = YES;
        });
    }
    
    
    
    
    
//    if (cartShowing) {
//        _totalPriceTitle.hidden = NO;
//    }
//    [UIView animateWithDuration:.1f animations:^{
//        _totalPriceLabel.x = cartShowing?PRICE_LABEL_MARGIN_WITH_CART_SHOWING:PRICE_LABEL_MARGIN;
//    } completion:^(BOOL finished) {
//        if (!cartShowing) {
//            _totalPriceTitle.hidden = YES;
//        }
//    }];

}

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 分割线
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = HEX_COLOR(0xa5a5a5);
        [self addSubview:divider];
        _divider = divider;
        
        // 购物车信息Label
        UILabel *cartMessageLabel = [[UILabel alloc] init];
        cartMessageLabel.text = @"购物车是空的";
        cartMessageLabel.font = [UIFont systemFontOfSize:11.f];
        cartMessageLabel.textColor = [UIColor grayColor];
        [self addSubview:cartMessageLabel];
        _cartMessageLabel = cartMessageLabel;
        
        // 总价Label
        UILabel *totalPriceLabel = [[UILabel alloc] init];
        totalPriceLabel.font = [UIFont systemFontOfSize:16];
        totalPriceLabel.textColor = HEX_COLOR(0xec681a);
        totalPriceLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:totalPriceLabel];
        totalPriceLabel.hidden = YES;
        _totalPriceLabel = totalPriceLabel;
        
        // 总价标题
        UILabel *totalPriceTitle = [[UILabel alloc] init];
        totalPriceTitle.text = @"总计:";
        totalPriceTitle.font = [UIFont systemFontOfSize:16.f];
        totalPriceTitle.textColor = HEX_COLOR(0x444444);
        [self addSubview:totalPriceTitle];
        totalPriceTitle.hidden = YES;
        _totalPriceTitle = totalPriceTitle;
        
        // 支付按钮
        NBButton *payButton = [[NBButton alloc] init];
        payButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payButton setBackgroundImage:[UIImage imageNamed:@"menu_to_pay"] forState:UIControlStateNormal];
        [payButton setBackgroundImage:[UIImage imageNamed:@"menu_to_pay_disable"] forState:UIControlStateDisabled];
        payButton.enabled = NO;
        [self addSubview:payButton];
        _payButton = payButton;
    }
    return self;
}


#pragma mark - public
- (void)setPrice:(float)price
{
    if (price > 0.f) {
        _payButton.enabled = YES;
        _cartMessageLabel.hidden = YES;
        _totalPriceLabel.hidden = NO;
        _totalPriceLabel.text = [NSString stringWithFormat:@"￥ %@",[NSString stringWithFloat:price]];
        
    }else
    {
        _payButton.enabled = NO;
        _cartMessageLabel.hidden = NO;
        _totalPriceLabel.hidden = YES;
    }
}

- (void)payButtonAddTarget:(id)target action:(SEL)sel
{
    [_payButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - private
- (void)layoutSubviews
{
    
    // 分割线
    self.divider.frame = CGRectMake(0, 0, self.width, .5f);
    
    // 购物车信息
    CGSize cartMsgSize = [NSString sizeWithString:_cartMessageLabel.text font:_cartMessageLabel.font maxSize:MAXSIZE];
    CGFloat cartMsgW = cartMsgSize.width;
    CGFloat cartMsgH = cartMsgSize.height;
    CGFloat cartMsgX = 63.f;
    CGFloat cartMsgY = (self.height - cartMsgH) * 0.5;
    _cartMessageLabel.frame = CGRectMake(cartMsgX, cartMsgY, cartMsgW, cartMsgH);
    
    // 总价信息
    CGFloat totalPriceLabelW = 150;
    CGFloat totalPriceLabelH = 32;
    CGFloat totalPriceLabelX = PRICE_LABEL_MARGIN;
    CGFloat totalPriceLabelY = (self.height - totalPriceLabelH) * 0.5;
    _totalPriceLabel.frame = CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH);
    
    // 总计标题
    CGFloat totalPriceTitleW = 50;
    CGFloat totalPriceTitleH = 32;
    CGFloat totalPriceTitleX = 14;
    CGFloat totalPriceTitleY = (self.height - totalPriceTitleH) * 0.5;
    _totalPriceTitle.frame = CGRectMake(totalPriceTitleX, totalPriceTitleY, totalPriceTitleW, totalPriceTitleH);
    
    // 支付按钮
    CGFloat payBtnW = _payButton.currentBackgroundImage.size.width;
    CGFloat payBtnH = _payButton.currentBackgroundImage.size.height;
    CGFloat payBtnX = self.width - payBtnW - 9;
    CGFloat payBtnY = (self.height - payBtnH) * 0.5;
    _payButton.frame = CGRectMake(payBtnX, payBtnY, payBtnW, payBtnH);
}

@end
