//
//  CSPayTypeCell.m
//  CloudSong
//
//  Created by sen on 5/30/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSPayTypeCell.h"
#import <Masonry.h>
@interface CSPayTypeCell ()
@property(nonatomic, weak) UIImageView *picView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *subTitleLabel;
@property(nonatomic, weak) UIImageView *signView;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation CSPayTypeCell
#pragma mark - Init
- (instancetype)initWithType:(CSPayMethodType)payMethodType
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x222126);
        self.payMethodType = payMethodType;
    }
    return self;
}

- (void)setPayMethodType:(CSPayMethodType)payMethodType
{
    _payMethodType = payMethodType;
    
    NSString *imageName = nil;
    NSString *title = nil;
    NSString *subTitle = nil;
    switch (payMethodType) {
        case CSPayMethodTypeAlipay:
            self.tag = CSPayMethodTypeAlipay;
            imageName = @"pay_alipay_icon";
            title = @"支付宝支付";
            subTitle = @"推荐有支付宝账号的用户使用";
            break;
        case CSPayMethodTypeWechat:
            self.tag = CSPayMethodTypeWechat;
            imageName = @"pay_wechat_icon";
            title = @"微信支付";
            subTitle = @"推荐有微信账号的用户使用";
            break;
        default:
            break;
    }
    
    UIImageView *picView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _picView = picView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.textColor = HEX_COLOR(0xb5b7bf);
    titleLabel.text = title;
    _titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    subTitleLabel.textColor = HEX_COLOR(0x67676e);
    subTitleLabel.text = subTitle;
    _subTitleLabel = subTitleLabel;
    
    UIImageView *signView = [[UIImageView alloc] init];
    signView.image = [UIImage imageNamed:@"pay_choice_btn"];
    signView.highlightedImage = [UIImage imageNamed:@"pay_choice_btn_selected"];
    _signView =signView;
    
    [self addSubview:picView];
    [self addSubview:titleLabel];
    [self addSubview:subTitleLabel];
    [self addSubview:signView];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(TRANSFER_SIZE(15.0));
        }];
        
        CGFloat margin = TRANSFER_SIZE(13.0);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.picView.mas_top);
            make.left.equalTo(self.picView.mas_right).offset(margin);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.picView.mas_right).offset(margin);
            make.bottom.equalTo(self.picView.mas_bottom);
        }];
        
        [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-TRANSFER_SIZE(26.0));
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.signView.highlighted = _selected;
}

#pragma mark - Touch Events

- (void)addTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGR];
}

@end
