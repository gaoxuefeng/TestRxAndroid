//
//  NBCartButton.m
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCartButton.h"
#import "NBCommon.h"

int const radius = 7.f;

@interface NBCartButton ()
/**
 *  购物车数量Label
 */
@property(nonatomic, weak) UILabel *cartAmountLabel;

@property(nonatomic, assign) int amount;

@end


@implementation NBCartButton


#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"menu_cart_full"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"menu_cart_empty"] forState:UIControlStateDisabled];
        
        UILabel *cartAmountLabel = [[UILabel alloc] init];
        cartAmountLabel.hidden = YES;
        cartAmountLabel.textAlignment = NSTextAlignmentCenter;
        cartAmountLabel.textColor = [UIColor whiteColor];
        cartAmountLabel.font = [UIFont systemFontOfSize:7.5f];
        cartAmountLabel.backgroundColor = HEX_COLOR(0xe84018);
        cartAmountLabel.layer.cornerRadius = radius;
        cartAmountLabel.layer.masksToBounds = YES;
        [self addSubview:cartAmountLabel];
        _cartAmountLabel = cartAmountLabel;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{

}


#pragma mark - public
- (void)setAmount:(int)amount
{
    if (amount) {
        _cartAmountLabel.hidden = NO;
        _cartAmountLabel.text = [NSString stringWithFormat:@"%d",amount];
        return;
    }
    _cartAmountLabel.hidden = YES;
}


#pragma mark - private
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat cartAmountLabelW = radius * 2;
    CGFloat cartAmountLabelH = cartAmountLabelW;
    CGFloat cartAmountLabelX = self.width - cartAmountLabelW;
    CGFloat cartAmountLabelY = 0;
    _cartAmountLabel.frame = CGRectMake(cartAmountLabelX, cartAmountLabelY, cartAmountLabelW, cartAmountLabelH);
}

@end
