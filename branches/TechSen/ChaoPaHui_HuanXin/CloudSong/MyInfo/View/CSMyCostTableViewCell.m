//
//  CSMyCostTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/6/16.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyCostTableViewCell.h"
#import <Masonry.h>
#import "CSDefine.h"


@interface CSMyCostTableViewCell ()
@property(nonatomic, weak) UIView *headerView;
@property(nonatomic, weak) UIView *bodyView;
@property(nonatomic, weak) UIView *timeView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *dateLabel;
@property(nonatomic, weak) UILabel *timeLabel;
@property(nonatomic, weak) UILabel *statusLabel;
@property(nonatomic, weak) UIView *centerLine;
@property(nonatomic, weak) UIView *topLine;
@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation CSMyCostTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"costCell";
    CSMyCostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSMyCostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = HEX_COLOR(0x222126);
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UIView *headerView = [[UIView alloc] init];
    [self.contentView addSubview:headerView];
    _headerView = headerView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.textColor = HEX_COLOR(0xe0dfe2);
    [headerView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIView *bodyView = [[UIView alloc] init];
    [self.contentView addSubview:bodyView];
    _bodyView = bodyView;
    
    UIView *timeView = [[UIView alloc] init];
    [bodyView addSubview:timeView];
    _timeView = timeView;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    dateLabel.textColor = HEX_COLOR(0xbfbcc4);
    [timeView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    timeLabel.textColor = HEX_COLOR(0xbfbcc4);
    [timeView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    statusLabel.textColor = HEX_COLOR(0xf03da2);
    [bodyView addSubview:statusLabel];
    _statusLabel = statusLabel;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = HEX_COLOR(0x3b2a51);
    [self.contentView addSubview:topLine];
    _topLine = topLine;
    
    UIView *centerLine = [[UIView alloc] init];
    centerLine.backgroundColor = topLine.backgroundColor;
    [self.contentView addSubview:centerLine];
    _centerLine = centerLine;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = topLine.backgroundColor;
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
}

- (void)setItem:(CSMyCostModel *)item
{
    _item = item;
    _titleLabel.text = item.KTVName;
    _dateLabel.text = item.day;
    _timeLabel.text = item.hours;
    NSString *statusStr;
    switch ([item.payState integerValue]) {
        case CSMyCostStatusTypeNotPay:
            statusStr = @"未支付";
            break;
        case CSMyCostStatusTypeHasPayDisableRefunding:
            statusStr = @"已支付";
            break;
        case CSMyCostStatusTypeHasPayEnableRefunding:
            statusStr = @"已支付";
            break;
        case CSMyCostStatusTypeRefunding:
            statusStr = @"退款中";
            break;
        case CSMyCostStatusTypeInCost:
            statusStr = @"已消费";
            break;
        case CSMyCostStatusTypeCanceled:
            statusStr = @"已取消";
            break;
        default:
            break;
    }
    _statusLabel.text = statusStr;
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_topLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topLine.mas_bottom);
            make.left.right.equalTo(_headerView.superview);
            make.height.mas_equalTo(TRANSFER_SIZE(32.0));
        }];
        
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeView.superview);
            make.left.equalTo(_timeView.superview).offset(TRANSFER_SIZE(20.0));
        }];
        
        [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom);
            make.left.right.equalTo(_centerLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [_bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerLine.mas_bottom);
            make.left.right.equalTo(_bodyView.superview);
            make.bottom.equalTo(_bottomLine.mas_top);
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_bottomLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.superview);
            make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(10.0));
        }];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_dateLabel.superview);
            make.right.lessThanOrEqualTo(_dateLabel.superview);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_timeLabel.superview);
            make.top.equalTo(_dateLabel.mas_bottom);
            make.right.lessThanOrEqualTo(_timeLabel.superview);
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_statusLabel.superview);
            make.right.equalTo(_statusLabel.superview).offset(-TRANSFER_SIZE(20.0));
        }];
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}
@end
