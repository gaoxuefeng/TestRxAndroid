//
//  NBMerchantTopCell.m
//  NoodleBar
//
//  Created by sen on 15/4/17.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMerchantTopCell.h"
#import "NBCommon.h"
#import "CWStarRateView.h"
#import <UIImageView+WebCache.h>

@interface NBMerchantTopCell()
/**
 *  商户图片
 */
@property(nonatomic, weak) UIImageView *merchantImageView;
/**
 *  商户名称
 */
@property(nonatomic, weak) UILabel *merchantNameLabel;
/**
 *  营业时间
 */
@property(nonatomic, weak) UILabel *openTimeLabel;
/**
 *  评分图
 */
@property(nonatomic, weak) CWStarRateView *starRateView;
/**
 *  评分数
 */
@property(nonatomic, weak) UILabel *ratingLabel;
@end


@implementation NBMerchantTopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubView];
        
       
    }
    return self;
}

- (void)setupSubView
{
    // 商户图片
    UIImageView *merchantImageView = [UIImageView newAutoLayoutView];
    _merchantImageView = merchantImageView;
    merchantImageView.layer.cornerRadius = 2.f;
    merchantImageView.layer.masksToBounds = YES;
    [self addSubview:merchantImageView];
    [merchantImageView autoSetDimensionsToSize:CGSizeMake(112.f, 90.f)];
    [merchantImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [merchantImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.f];
    
    // 商户名称
    UILabel *merchantNameLabel = [UILabel newAutoLayoutView];
    _merchantNameLabel = merchantNameLabel;

    merchantNameLabel.textColor = HEX_COLOR(0x231815);
    merchantNameLabel.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:merchantNameLabel];
    [merchantNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:merchantImageView withOffset:12.f];
    [merchantNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22.f];
    
    // 营业时间
    UILabel *openTimeLabel = [UILabel newAutoLayoutView];
    _openTimeLabel = openTimeLabel;
    [self addSubview:openTimeLabel];
    openTimeLabel.font = [UIFont systemFontOfSize:15.f];
    openTimeLabel.textColor = HEX_COLOR(0x595757);
    [openTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:merchantNameLabel withOffset:12.f];
    [openTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:merchantNameLabel];
    
    // 评分
    // 1.评分图
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(135, 80, 60, 10) numberOfStars:5];
    _starRateView = starRateView;
    starRateView.userInteractionEnabled = NO;
    starRateView.allowIncompleteStar = YES;
    starRateView.hasAnimation = NO;
    [self addSubview:starRateView];
    
    // 2.评分数
    UILabel *ratingLabel = [UILabel newAutoLayoutView];
    _ratingLabel = ratingLabel;
    [self addSubview:ratingLabel];
    ratingLabel.textColor = HEX_COLOR(0x9fa0a0);
    ratingLabel.font = [UIFont systemFontOfSize:10.f];
    [ratingLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:starRateView withOffset:5.f];
    [ratingLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:starRateView];
    
    // 下分割线
    UIView *bottomDivider = [UIView newAutoLayoutView];
    [self addSubview:bottomDivider];
    [bottomDivider autoSetDimension:ALDimensionHeight toSize:0.5f];
    bottomDivider.backgroundColor = HEX_COLOR(0xc1c1c1);
    [bottomDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
}

- (void)setItem:(NBMerchantModel *)item
{
    _item = item;
    [_merchantImageView sd_setImageWithURL:[NSURL URLWithString:_item.pictureuri] placeholderImage:[UIImage imageNamed:@"merchant_placeholder"]];
    _merchantNameLabel.text = _item.name;
    _openTimeLabel.text = [NSString stringWithFormat:@"营业时间:  %@",_item.bussinesstime];
    _starRateView.scorePercent = [_item.level floatValue] /5.f;
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f",[_item.level floatValue]];
}



@end
