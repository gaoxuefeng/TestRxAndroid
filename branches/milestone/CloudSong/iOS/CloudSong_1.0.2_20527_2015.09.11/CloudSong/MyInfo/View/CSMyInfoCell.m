//
//  CSMyInfoCell.m
//  CloudSong
//
//  Created by sen on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSMyInfoCell.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSMyInfoCell ()
{
    UIImage *_icon;
    NSString *_title;
    NSString *_subTitle;
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UIImageView *_arrowView;
    UIView *_bottomDivider;
    BOOL _didSetupConstraint;
}
@end

@implementation CSMyInfoCell
#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle
{
    _icon = icon;
    _title = title;
    _subTitle = subTitle;
    return [self init];
}

#pragma mark - Setup
- (void)setupSubViews
{
    _iconView = [[UIImageView alloc] init];
    _iconView.image = _icon;
    [self addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _titleLabel.textColor = HEX_COLOR(0xffffff);
    _titleLabel.text = _title;
    [self addSubview:_titleLabel];
    
    _arrowView = [[UIImageView alloc] init];
    _arrowView.image = [UIImage imageNamed:@"mine_arrow"];
    [self addSubview:_arrowView];
    
    _bottomDivider = [[UIView alloc] init];
    _bottomDivider.backgroundColor = HEX_COLOR(0x3f2757);
    [self addSubview:_bottomDivider];
    
    if (_subTitle) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
        _subTitleLabel.textColor = HEX_COLOR(0x393940);
        _subTitleLabel.text = @"未绑定";
        [self addSubview:_subTitleLabel];
    }
    
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(TRANSFER_SIZE(17.0));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_iconView.mas_right).offset(TRANSFER_SIZE(15.0));
        }];
        
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-TRANSFER_SIZE(23.0));
        }];
        
        [_bottomDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(_arrowView.mas_left).offset(-TRANSFER_SIZE(10.0));
        }];
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

@end
