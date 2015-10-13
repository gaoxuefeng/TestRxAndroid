//
//  CSAboutUsCell.m
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSAboutUsCell.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSAboutUsCell ()
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL didSetupConstaint;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *subTitleLabel;
@property(nonatomic, weak) UIImageView *arrowView;
@property(nonatomic, weak) UIView *bottomLine;
@end

@implementation CSAboutUsCell

- (instancetype)initWithTitle:(NSString *)title
{
    _title = title;
    return [self init];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
        [self setupSubViews];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tapGr];
    }
    return self;
}
#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.text = _title;
    titleLabel.textColor = HEX_COLOR(0x8e8e8f);
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x3f2757);
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    arrowView.image = [UIImage imageNamed:@"mine_arrow"];
    [self addSubview:arrowView];
    _arrowView = arrowView;
}


- (void)updateConstraints
{
    if (!_didSetupConstaint) {
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.superview);
            make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(10.0));
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_bottomLine.superview);
            make.left.equalTo(_bottomLine.superview).offset(_fullWidthDivider?0:TRANSFER_SIZE(10.0));
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_subTitleLabel.superview);
            make.right.equalTo(_subTitleLabel.superview).offset(-TRANSFER_SIZE(10.0));
        }];
        
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_arrowView.superview);
            make.right.equalTo(_arrowView.superview).offset(-TRANSFER_SIZE(10.0));
        }];
        _didSetupConstaint = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Public
- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    if (subTitle.length > 0) {
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
        subTitleLabel.text = subTitle;
        subTitleLabel.textColor = HEX_COLOR(0xa93275);
        [self addSubview:subTitleLabel];
        _subTitleLabel = subTitleLabel;
        _arrowView.hidden = YES;
    }else
    {
        _arrowView.hidden = NO;
    }
    
}

- (void)setFullWidthDivider:(BOOL)fullWidthDivider
{
    _fullWidthDivider = fullWidthDivider;
}


#pragma mark - Action
- (void)tap
{
    if (self.option) {
        self.option();
    }
}
@end
