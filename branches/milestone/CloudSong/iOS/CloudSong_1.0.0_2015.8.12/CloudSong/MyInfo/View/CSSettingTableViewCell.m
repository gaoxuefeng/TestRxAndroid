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
    self.contentView.backgroundColor = HEX_COLOR(0x222126);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font  = [UIFont systemFontOfSize:TRANSFER_SIZE(16.0)];
    titleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self.contentView addSubview:arrowView];
    _arrowView = arrowView;
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
            make.right.equalTo(self.contentView).offset(-TRANSFER_SIZE(27.0));
        }];
        
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

@end
