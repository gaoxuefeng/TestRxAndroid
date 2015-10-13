//
//  CSMyCostDishTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyCostDishTableViewCell.h"
#import <Masonry.h>
#import "CSDefine.h"

@interface CSMyCostDishTableViewCell ()
@property(nonatomic, weak) UIView *headerView;
@property(nonatomic, weak) UIView *bodyView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *contentLabel;
@property(nonatomic, weak) UILabel *statusLabel;
@property(nonatomic, weak) UIView *centerLine;
@property(nonatomic, weak) UIView *topLine;
@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, weak) UIImageView *signView;
@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSMyCostDishTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"dishCostCell";
    CSMyCostDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSMyCostDishTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
    
    UIImageView *signView = [[UIImageView alloc] init];
    signView.image = [UIImage imageNamed:@"mine_consume_drinks"];
    [headerView addSubview:signView];
    _signView = signView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.textColor = HEX_COLOR(0xe0dfe2);
    [headerView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    
    UIView *bodyView = [[UIView alloc] init];
    [self.contentView addSubview:bodyView];
    _bodyView = bodyView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    contentLabel.textColor = HEX_COLOR(0xbfbcc4);
    [bodyView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
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
    _contentLabel.text = item.content;
    NSString *statusStr;
    
    switch ([item.payState integerValue]) {
        case CSMyCostDishStatusTypeNotPay:
            statusStr = @"未支付";
            break;
        case CSMyCostDishStatusTypeHasPay:
            statusStr = @"已支付";
            break;
        case CSMyCostDishStatusTypeRefunding:
            statusStr = @"退款中";
            break;
        case CSMyCostDishStatusTypeDone:
            statusStr = @"已消费";
            break;
        case CSMyCostDishStatusTypeCanceled:
            statusStr = @"已取消";
            break;
        default:
            break;
    }
    
//    switch ([item.payState integerValue]) {
//        case CSMyCostStatusTypeNotPay:
//            statusStr = @"未支付";
//            break;
//        case CSMyCostStatusTypeHasPayDisableRefunding:
//            statusStr = @"已支付";
//            break;
//        case CSMyCostStatusTypeHasPayEnableRefunding:
//            statusStr = @"已支付";
//            break;
//        case CSMyCostStatusTypeRefunding:
//            statusStr = @"退款中";
//            break;
//        case CSMyCostStatusTypeInCost:
//            statusStr = @"已消费";
//            break;
//        case CSMyCostStatusTypeCanceled:
//            statusStr = @"已取消";
//            break;
//        default:
//            break;
//    }
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
        
        [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_signView.superview);
            make.right.equalTo(_signView.superview).offset(-TRANSFER_SIZE(20.0));
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_contentLabel.superview);
            make.left.equalTo(_contentLabel.superview).offset(TRANSFER_SIZE(20.0));
            make.width.lessThanOrEqualTo(_contentLabel.superview).offset(-AUTOLENGTH(TRANSFER_SIZE(150.0)));
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
        
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_statusLabel.superview);
            make.right.equalTo(_statusLabel.superview).offset(-TRANSFER_SIZE(20.0));
        }];
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

@end
