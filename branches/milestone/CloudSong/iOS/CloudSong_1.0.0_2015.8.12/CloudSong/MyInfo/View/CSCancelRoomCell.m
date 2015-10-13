//
//  CSCancelRoomCell.m
//  CloudSong
//
//  Created by sen on 15/6/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCancelRoomCell.h"
#import <Masonry.h>
#import "CSDefine.h"
@interface CSCancelRoomCell ()
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *contentLabel;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation CSCancelRoomCell


- (instancetype)initWithTitle:(NSString *)title
{
    _title = title;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x212025);
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textColor = HEX_COLOR(0x67686e);
    titleLabel.text = _title;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = HEX_COLOR(0x9799a1);
    contentLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;
}
- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.superview);
            make.left.equalTo(_titleLabel.superview).offset(13.0);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_contentLabel.superview);
            make.left.equalTo(_contentLabel.superview).offset(77.0);
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
