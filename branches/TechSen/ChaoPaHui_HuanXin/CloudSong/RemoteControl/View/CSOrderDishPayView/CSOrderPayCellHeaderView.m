//
//  CSOrderPayCellHeaderView.m
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderPayCellHeaderView.h"
#import <Masonry.h>
#import "CSDefine.h"
@interface CSOrderPayCellHeaderView ()
@property(nonatomic, assign) BOOL didSetupConstraints;
@property(nonatomic, weak) UIButton *titleButton;
@property(nonatomic, weak) UILabel *subTitleLabel;
@property(nonatomic, weak) UIView *bottomDivider;
@end

@implementation CSOrderPayCellHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = WhiteColor_Alpha_6;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIButton *titleButton = [[UIButton alloc] init];
    [titleButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"pay_header_bar"] forState:UIControlStateNormal];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -12.0)];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleButton.userInteractionEnabled = NO;
    _titleButton = titleButton;
    [self addSubview:titleButton];
    
    UIView *bottomDivider = [[UIView alloc] init];
    bottomDivider.backgroundColor = WhiteColor_Alpha_6;
    _bottomDivider = bottomDivider;
    [self addSubview:bottomDivider];
}



- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self.bottomDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(TRANSFER_SIZE(20.0));
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-TRANSFER_SIZE(20.0));
        }];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    UILabel *subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel = subTitleLabel;
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = HEX_COLOR(0xffffff);
    subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [self addSubview:subTitleLabel];
}

- (void)setHiddenDivider:(BOOL)hiddenDivider
{
    _hiddenDivider = hiddenDivider;
    _bottomDivider.hidden = _hiddenDivider;
}


@end
