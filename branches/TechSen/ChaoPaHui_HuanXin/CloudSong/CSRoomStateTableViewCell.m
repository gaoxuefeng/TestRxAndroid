//
//  CSRoomStateTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/7/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomStateTableViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSChatMessageModel.h"

@interface CSRoomStateTableViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraint;
/** 内容 */
@property(nonatomic, weak) UILabel *contentLabel;
/** 内容背景 */
@property(nonatomic, weak) UIView *contentBackgroundView;
@property(nonatomic, weak) UIView *vLine;
@end

@implementation CSRoomStateTableViewCell
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
        [_contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.center.equalTo(_contentBackgroundView.superview);
//            make.top.bottom.equalTo(_contentBackgroundView.superview).offset(TRANSFER_SIZE(7.0));
//            make.bottom.bottom.equalTo(_contentBackgroundView.superview).offset(TRANSFER_SIZE(-7.0));
        }];
        
        [_vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_vLine.superview);
            make.width.mas_equalTo(1 / [UIScreen mainScreen].scale);
            make.left.equalTo(_vLine.superview).offset(17.0);
        }];
        
        CGFloat h_padding = TRANSFER_SIZE(10.0);
        CGFloat v_padding = TRANSFER_SIZE(4.0);
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentLabel.superview).insets(UIEdgeInsetsMake(v_padding, h_padding, v_padding, h_padding));
        }];
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Setup
- (void)setupSubviews
{
    UIView *contentBackgroundView = [[UIView alloc] init];
    contentBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    contentBackgroundView.layer.cornerRadius = TRANSFER_SIZE(5.0);
    contentBackgroundView.layer.masksToBounds = YES;
    _contentBackgroundView = contentBackgroundView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(9.0)];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.numberOfLines = 0;
    _contentLabel = contentLabel;
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = HEX_COLOR(0x383156);
    _vLine = vLine;

    [self.contentView addSubview:vLine];
    [self.contentView addSubview:contentBackgroundView];
    [contentBackgroundView addSubview:contentLabel];
}



#pragma mark - Public Methods
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"roomStateCell";
    CSRoomStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSRoomStateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setItem:(CSChatMessageModel *)item
{
    _item = item;
    _contentLabel.text = item.content;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    _vLine.hidden = hiddenLine;
}

@end
