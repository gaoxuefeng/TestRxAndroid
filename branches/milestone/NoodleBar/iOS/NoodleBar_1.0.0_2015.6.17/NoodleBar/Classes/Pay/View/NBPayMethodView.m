//
//  NBPayMethodView.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayMethodView.h"
#import "NBCommon.h"
#import "WXApi.h"


@interface NBPayMethodView ()
@property(nonatomic, weak) NBPayMethodCell *selectedPayCell;
@end

@implementation NBPayMethodView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UICOLOR_FROM_HEX(0xf3f3f3);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *titleView = [[UIView alloc] initForAutoLayout];
    titleView.backgroundColor = HEX_COLOR(0xf3f3f3);
    [self addSubview:titleView];
    
    [titleView autoSetDimension:ALDimensionHeight toSize:38.f];
    [titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    
    UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
    titleLabel.text = @"支付方式";
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textColor = HEX_COLOR(0x464646);
    [titleView addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
    
    // 微信支付
    NBPayMethodCell *wechatCell = nil;
    // 支付方式
    if ([WXApi isWXAppInstalled]) {
        wechatCell = [[NBPayMethodCell alloc] initWithPayType:NBPayMethodTypeWechat];
        [self addSubview:wechatCell];
        [wechatCell autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 54.0f)];
        [wechatCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [wechatCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleView];
        [wechatCell addTarget:self action:@selector(payMethodOnClick:) forControlEvents:UIControlEventTouchUpInside];
        wechatCell.selected = YES;
        
    }
    
    
    // 支付宝支付
    NBPayMethodCell *alipayCell = [[NBPayMethodCell alloc] initWithPayType:NBPayMethodTypeAlipay];
    [self addSubview:alipayCell];
    [alipayCell autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 54.0f)];
    [alipayCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [alipayCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wechatCell?wechatCell:titleView];
    [alipayCell addTarget:self action:@selector(payMethodOnClick:) forControlEvents:UIControlEventTouchUpInside];
    alipayCell.selected = ![WXApi isWXAppInstalled];
    _selectedPayCell = [WXApi isWXAppInstalled]?wechatCell:alipayCell;
//    // 支付宝客户端支付
//    NBPayMethodCell *alipayClientCell = [[NBPayMethodCell alloc] initWithPayType:NBPayMethodTypeAlipayClient];
//    [self addSubview:alipayClientCell];
//    [alipayClientCell autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 45.5f)];
//    [alipayClientCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [alipayClientCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:alipayCell];
//    [alipayClientCell addTarget:self action:@selector(payMethodOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)payMethodOnClick:(NBPayMethodCell *)payMethodCell
{   _selectedPayCell.selected = NO;
    payMethodCell.selected = YES;
    _selectedPayCell = payMethodCell;
}


- (NBPayMethodType)payMethodType
{
    return _selectedPayCell.payType;
}
@end
