//
//  CSSettingTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/6/13.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSettingTableViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSSettingTableViewCell()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, weak) UIImageView *arrowView;
@property(weak, nonatomic) UIView *bottomLine;

@property(nonatomic, assign) BOOL didSetupConstraint;

@end


@implementation CSSettingTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"settingCell";
    CSSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    self.backgroundColor = WhiteColor_Alpha_2;
//    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font  = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.textColor = HEX_COLOR(0xffffff);
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self.contentView addSubview:arrowView];
    _arrowView = arrowView;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = WhiteColor_Alpha_6;
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
}

- (void)setItem:(CSSettingItem *)item
{
    _item = item;
    _titleLabel.text = item.title;
//    _arrowView.hidden = !item.option;
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(TRANSFER_SIZE(20.0));
        }];
        
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-TRANSFER_SIZE(20.0));
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_bottomLine.superview);
            make.left.equalTo(self.contentView).offset(TRANSFER_SIZE(20.0));
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setBottomLineHidden:(BOOL)bottomLineHidden
{
    _bottomLineHidden = bottomLineHidden;
    _bottomLine.hidden = bottomLineHidden;
}

@end
