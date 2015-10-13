//
//  NBPayMethodCell.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayMethodCell.h"

#define H_MARGIN 15.f
@interface NBPayMethodCell()
//@property(nonatomic, weak) UIButton *cellButton;
@property(nonatomic, weak) UIImageView *selectedImage;
@end

@implementation NBPayMethodCell

- (instancetype)initWithPayType:(NBPayMethodType)payType
{
    _payType = payType;
    if (self = [self init]) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.backgroundColor = RANDOM_COLOR;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
//    UIButton *cellButton = [[UIButton alloc] initForAutoLayout];
//    [self addSubview:cellButton];
//    _cellButton = cellButton;
//    [cellButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // 上分割线
    UIView *topDivider = [[UIView alloc] initForAutoLayout];
    [self addSubview:topDivider];
    topDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [topDivider autoSetDimension:ALDimensionHeight toSize:.5f];
    [topDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    // 图标

    NSString *iconName;
    NSString *topTitle;
    NSString *bottomTitle;
    switch (_payType) {
        case NBPayMethodTypeAlipay:
            iconName = @"pay_alipay_icon";
            topTitle = @"支付宝支付";
            bottomTitle = @"推荐有支付宝账号的用户使用";
            break;
        case NBPayMethodTypeWechat:
            iconName = @"pay_wechat_icon";
            topTitle = @"微信支付";
            bottomTitle = @"推荐有微信账号的用户使用";
            break;
        default:
            break;
    }
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [self addSubview:iconView];
    [iconView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [iconView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    
    // 上标题
    UILabel *topTitleLabel = [[UILabel alloc] initForAutoLayout];
    [self addSubview:topTitleLabel];
    topTitleLabel.text = topTitle;
    topTitleLabel.font = [UIFont systemFontOfSize:14.f];
    topTitleLabel.textColor = HEX_COLOR(0x595757);
    [topTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:9.0];
    [topTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconView withOffset:10.f];
    

    // 下标题
    UILabel *bottomTitleLabel = [[UILabel alloc] initForAutoLayout];
    [self addSubview:bottomTitleLabel];
    bottomTitleLabel.text = bottomTitle;
    bottomTitleLabel.font = [UIFont systemFontOfSize:11.f];
    bottomTitleLabel.textColor = HEX_COLOR(0x595757);
    [bottomTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topTitleLabel withOffset:4.0];
    [bottomTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconView withOffset:10.f];
    
    UIImageView *selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_method_selected"]];
    [self addSubview:selectedImage];
    selectedImage.hidden = YES;
    _selectedImage = selectedImage;
    
    [selectedImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [selectedImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.f];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _selectedImage.hidden = !selected;
}



@end
