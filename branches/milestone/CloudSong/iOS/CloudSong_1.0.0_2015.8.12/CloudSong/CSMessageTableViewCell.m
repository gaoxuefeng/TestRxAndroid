//
//  CSMessageTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/7/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMessageTableViewCell.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSChatMessageModel.h"
#import <UIImageView+WebCache.h>

#define CIRCLE_RADIUS TRANSFER_SIZE(4.0)

@interface CSMessageTableViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraint;
/** 圆点 */
@property(nonatomic, weak) UIView *circleView;
/** 头像 */
@property(nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property(nonatomic, weak) UILabel *nickNameLabel;
/** 内容 */
@property(nonatomic, weak) UILabel *contentLabel;
/** 内容背景 */
@property(nonatomic, weak) UIView *contentBackgroundView;
/** 上竖线 */
@property(nonatomic, weak) UIView *upVLine;
/** 下竖线 */
@property(nonatomic, weak) UIView *bottomVLine;

@end

@implementation CSMessageTableViewCell
#pragma mark - Initialize
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = HEX_COLOR(0x332d58);
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
        
    }
    return self;
}

#pragma mark - Inherit
- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.contentView.superview);
            make.top.left.equalTo(self.contentView.superview);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView.superview).offset(TRANSFER_SIZE(36.0));
            make.top.equalTo(_iconView.superview).offset(TRANSFER_SIZE(5.0));
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(20.0), TRANSFER_SIZE(20.0)));
        }];

        
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView.mas_right).offset(TRANSFER_SIZE(9.0));
            make.centerY.equalTo(_iconView);
        }];
        
        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 2));
            make.centerY.equalTo(_iconView);
            make.centerX.equalTo(_upVLine);
        }];
        
        [_upVLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1 / [UIScreen mainScreen].scale);
//            make.centerX.equalTo(_circleView);
            make.left.equalTo(_upVLine.superview).offset(TRANSFER_SIZE(17.0));
            make.top.equalTo(_upVLine.superview);
            make.bottom.equalTo(_circleView.mas_top);
        }];
        [_bottomVLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1 / [UIScreen mainScreen].scale);
            make.centerX.equalTo(_upVLine);
            make.bottom.equalTo(_bottomVLine.superview);
            make.top.equalTo(_circleView.mas_bottom);
        }];
        
        [_contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconView.mas_bottom).offset(TRANSFER_SIZE(8.0));
            make.left.equalTo(_iconView);
            make.right.lessThanOrEqualTo(_contentBackgroundView.superview).offset(-TRANSFER_SIZE(12.0));
            make.bottom.equalTo(_contentBackgroundView.superview).offset(-TRANSFER_SIZE(5.0));
        }];
        
        CGFloat padding = TRANSFER_SIZE(10.0);
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentLabel.superview).insets(UIEdgeInsetsMake(padding, padding, padding, padding));
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //
//        [self.contentView setNeedsLayout];
//        [self.contentView layoutIfNeeded];
//        self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
}

#pragma mark - Setup
- (void)setupSubviews
{
    // 圆
    UIView *circleView = [[UIView alloc] init];
    circleView.layer.cornerRadius = CIRCLE_RADIUS;
    circleView.layer.masksToBounds = YES;
    circleView.backgroundColor = [UIColor purpleColor];
    _circleView = circleView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.backgroundColor = [UIColor grayColor];
    iconView.layer.cornerRadius = TRANSFER_SIZE(20.0) * 0.5;
    iconView.layer.masksToBounds = YES;
    _iconView = iconView;
    
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.numberOfLines = 1;
    nickNameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel = nickNameLabel;
    
    UIView *contentBackgroundView = [[UIView alloc] init];
    contentBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    contentBackgroundView.layer.cornerRadius = TRANSFER_SIZE(5.0);
    contentBackgroundView.layer.masksToBounds = YES;
    _contentBackgroundView = contentBackgroundView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.numberOfLines = 0;
    _contentLabel = contentLabel;
    
    UIView *upVLine = [[UIView alloc] init];
    upVLine.backgroundColor = HEX_COLOR(0x383156);
    _upVLine = upVLine;
    UIView *bottomVLine = [[UIView alloc] init];
    _bottomVLine = bottomVLine;
    bottomVLine.backgroundColor = HEX_COLOR(0x383156);
    
    [self.contentView addSubview:circleView];
    [self.contentView addSubview:upVLine];
    [self.contentView addSubview:bottomVLine];
    [self.contentView addSubview:iconView];
    [self.contentView addSubview:nickNameLabel];
    [self.contentView addSubview:contentBackgroundView];
    [contentBackgroundView addSubview:contentLabel];
}

#pragma mark - Public Methods
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell";
    CSMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setItem:(CSChatMessageModel *)item
{
    _item = item;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.headUrl]];
    _nickNameLabel.text = item.nickName;
    _contentLabel.text = item.content;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setTopLineHidden:(BOOL)topLineHidden
{
    _topLineHidden = topLineHidden;
    _upVLine.hidden = topLineHidden;
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden
{
    _bottomLineHidden = bottomLineHidden;
    _bottomVLine.hidden = bottomLineHidden;
}
@end
