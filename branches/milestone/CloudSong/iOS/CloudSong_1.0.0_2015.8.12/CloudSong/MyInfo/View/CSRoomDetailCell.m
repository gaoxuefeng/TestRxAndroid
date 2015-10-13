//
//  CSRoomDetailCell.m
//  CloudSong
//
//  Created by sen on 15/6/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomDetailCell.h"
#import <Masonry.h>
#import "CSDefine.h"
@interface CSRoomDetailCell ()
@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSRoomDetailCell

- (instancetype)initWithTitle:(NSString *)title
{
    _title = title;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = CSRoomDetailCellTypeNomal;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10.0)];
    titleLabel.text = _title;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        switch (_type) {
            case CSRoomDetailCellTypeNomal:
            {
                [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(_titleLabel.superview);
                }];
                
                [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_titleLabel.mas_bottom).offset(TRANSFER_SIZE(5.0));
                    make.bottom.equalTo(_contentLabel.superview);
                    make.left.equalTo(_contentLabel.superview).offset(TRANSFER_SIZE(5.0));
                    make.right.equalTo(_contentLabel.superview).offset(-TRANSFER_SIZE(5.0));
                }];

                break;
            }
            case CSRoomDetailCellTypeParallel:
            {
                [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(_titleLabel.superview);
                }];
                
                CGSize titleSize = [NSString sizeWithString:_titleLabel.text font:_titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentLabel.superview);
                    make.bottom.equalTo(_contentLabel.superview);
                    make.left.equalTo(_contentLabel.superview).offset(titleSize.width);
                    make.right.equalTo(_contentLabel.superview).offset(-TRANSFER_SIZE(5.0));
                }];

                break;
            }
            default:
                break;
        }
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

- (void)setType:(CSRoomDetailCellType)type
{
    _type = type;
    _contentLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10.0)];
}

@end
