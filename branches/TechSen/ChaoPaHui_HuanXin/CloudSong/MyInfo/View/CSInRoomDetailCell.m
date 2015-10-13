//
//  CSInRoomDetailCell.m
//  CloudSong
//
//  Created by sen on 15/7/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInRoomDetailCell.h"
#import <Masonry.h>
#import "CSDefine.h"
@interface CSInRoomDetailCell ()
@property(nonatomic, weak) UIImage *image;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *contentLabel;
@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, assign) BOOL didSetupConstraint;


@end


@implementation CSInRoomDetailCell

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon
{
    _title = title;
    _image = icon;
    
    
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


#pragma mark - Setup
- (void)setupSubViews
{
    
    if (_image) {
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = _image;
        [self addSubview:iconView];
        _iconView = iconView;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HEX_COLOR(0xada5a7);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = _title;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = HEX_COLOR(0xada5a7);
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.superview);
            make.left.equalTo(_iconView.mas_right).offset(6.0);
        }];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.mas_centerY);
            make.left.equalTo(_iconView.superview);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.superview);
            make.bottom.equalTo(_contentLabel.superview);
            make.left.equalTo(_contentLabel.superview).offset(85.0);
            make.right.equalTo(_contentLabel.superview);
        }];
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void)setContentColor:(UIColor *)contentColor
{
    _contentColor = contentColor;
    _contentLabel.textColor = contentColor;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = content;
}

@end
