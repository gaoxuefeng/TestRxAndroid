//
//  NBPayTotalPriceCell.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayTotalPriceCell.h"
#import "NBCommon.h"
#define H_MARGIN 15.f

@interface NBPayTotalPriceCell()
@property(nonatomic, weak) UILabel *priceLabel;
@property(nonatomic, weak) UILabel *discountPriceLabel;
@property(nonatomic, weak) UIView *labelLine;

@end

@implementation NBPayTotalPriceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR(0xf3f3f3);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *totalPriceView = [[UIView alloc] initForAutoLayout];
    [self addSubview:totalPriceView];
    totalPriceView.backgroundColor = [UIColor whiteColor];
    [totalPriceView autoSetDimension:ALDimensionHeight toSize:40.f];
    [totalPriceView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
    titleLabel.text = @"合计:";
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor = HEX_COLOR(0x969696);
    [totalPriceView addSubview:titleLabel];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 上分割线
    UIView *topDivider = [[UIView alloc] initForAutoLayout];
    [totalPriceView addSubview:topDivider];
    topDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [topDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [topDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] initForAutoLayout];
    [totalPriceView addSubview:bottomDivider];
    bottomDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [bottomDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [bottomDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] initForAutoLayout];
    priceLabel.font = [UIFont systemFontOfSize:9.f];
    priceLabel.textColor = HEX_COLOR(0x969696);
    [totalPriceView addSubview:priceLabel];
    _priceLabel = priceLabel;
    [priceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [priceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:H_MARGIN + 1];
    
    UIView *labelLine = [[UIView alloc] init];
    _labelLine = labelLine;
    labelLine.backgroundColor = HEX_COLOR(0x969696);
    [priceLabel addSubview:labelLine];
    [labelLine autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:priceLabel];
    [labelLine autoSetDimension:ALDimensionHeight toSize:1.0];
    [labelLine autoCenterInSuperview];
    // 折扣价
    UILabel *discountPriceLabel = [[UILabel alloc] init];
    discountPriceLabel.font = [UIFont systemFontOfSize:14.f];
    discountPriceLabel.textColor = HEX_COLOR(0xd90808);
    [totalPriceView addSubview:discountPriceLabel];
    _discountPriceLabel = discountPriceLabel;
    [discountPriceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [discountPriceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:priceLabel withOffset:-10];
}

- (void)setPrice:(CGFloat)price
{
    _price = price;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:price]];
    
}

- (void)setDiscountPrice:(CGFloat)discountPrice
{
    _discountPrice = discountPrice;
    _discountPriceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:discountPrice]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([_discountPriceLabel.text isEqualToString:_priceLabel.text])
    {
        _priceLabel.font = [UIFont systemFontOfSize:14.f];
        [_labelLine removeFromSuperview];
        [_discountPriceLabel removeFromSuperview];
    }
}

@end
