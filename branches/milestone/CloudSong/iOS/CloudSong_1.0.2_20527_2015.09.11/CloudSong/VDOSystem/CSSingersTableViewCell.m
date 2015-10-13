//
//  CSSingersTableViewCell.m
//  CloudSong
//
//  Created by EThank on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSingersTableViewCell.h"
#import "UITableViewCell+Extension.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSSingersTableViewCell () {
    UIImageView*    _backgroundImageView;
    UILabel*        _titleLabel;
}
@end

@implementation CSSingersTableViewCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
        self.textLabel.textColor = HEX_COLOR(0xffffff);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setCellType:(CSSingersTableViewCellType)type {
    if (type == CSSingersTableViewCellTypeSingle)
        _backgroundImageView.image = [[UIImage imageNamed:@"singer_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)];
    else {
        if (type == CSSingersTableViewCellTypeTop)
            _backgroundImageView.image = [[UIImage imageNamed:@"singer_bg_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
        else if (type == CSSingersTableViewCellTypeBottom)
            _backgroundImageView.image = [[UIImage imageNamed:@"singer_bg_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
        else
            _backgroundImageView.image = [[UIImage imageNamed:@"singer_bg_mid"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _backgroundImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_backgroundImageView];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundImageView.superview).offset(TRANSFER_SIZE(10));
        make.right.equalTo(_backgroundImageView.superview).offset(TRANSFER_SIZE(-10));
        make.top.bottom.equalTo(_backgroundImageView.superview);
    }];;
    
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _titleLabel.textColor = HEX_COLOR(0xffffff);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(25));
        make.top.bottom.equalTo(_titleLabel.superview);
        make.right.equalTo(_titleLabel.superview);
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self.contentView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowView.superview).offset(TRANSFER_SIZE(-28));
        make.centerY.equalTo(arrowView.superview);
    }];
}

@end
