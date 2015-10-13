//
//  CSOrderInfoView.m
//  CloudSong
//
//  Created by sen on 15/6/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSOrderInfoView.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSOrderPayCellHeaderView.h"
#import "CSKTVBookingOrder.h"
@interface CSOrderInfoViewCell ()

@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation CSOrderInfoViewCell

- (instancetype)initWithTitle:(NSString *)title
{
    _title = title;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    [self addSubview:titleLabel];
    if (_title.length > 0) {
        titleLabel.text = _title;
    }
    _titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [self addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = WhiteColor_Alpha_6;
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;
}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine
{
    _hiddenBottomLine = hiddenBottomLine;
    if (hiddenBottomLine) {
        _bottomLine.hidden = YES;
    }
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
}


- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_titleLabel.superview);
            make.width.mas_equalTo(TRANSFER_SIZE(67.0));
        }];
        
        CGFloat subPadding = TRANSFER_SIZE(5.0);
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_subTitleLabel.superview);
            make.left.equalTo(_titleLabel.mas_right);
            make.right.equalTo(_subTitleLabel.superview).offset(-subPadding);
            make.top.greaterThanOrEqualTo(_subTitleLabel.superview).offset(2 * subPadding);
            make.bottom.lessThanOrEqualTo(_subTitleLabel.superview).offset(-2 * subPadding);
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_bottomLine.superview);
            make.left.equalTo(_titleLabel.mas_right);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

@end



@interface CSOrderInfoView ()
@property(nonatomic, assign) BOOL didSetupConstraint;

@property(nonatomic, weak) CSOrderPayCellHeaderView *headerView;
//@property(nonatomic, weak) CSOrderInfoViewCell *topicCell;
@property(nonatomic, weak) CSOrderInfoViewCell *timeCell;
@property(nonatomic, weak) CSOrderInfoViewCell *roomCell;
@property(nonatomic, weak) CSOrderInfoViewCell *priceCell;
@property(nonatomic, weak) CSOrderInfoViewCell *shopCell;
@property(nonatomic, weak) CSOrderInfoViewCell *addressCell;
@end

@implementation CSOrderInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = WhiteColor_Alpha_4;
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    CSOrderPayCellHeaderView *headerView = [[CSOrderPayCellHeaderView alloc] init];
    headerView.title = @"订单信息";
    headerView.backgroundColor = WhiteColor_Alpha_4;
    [self addSubview:headerView];
    _headerView = headerView;

    
//    // 主题
//    CSOrderInfoViewCell *topicCell = [[CSOrderInfoViewCell alloc] initWithTitle:@"主题"];
//    topicCell.subTitleLabel.textColor = HEX_COLOR(0xb5b7bf);
//    [self addSubview:topicCell];
//    _topicCell = topicCell;
    // 时间
    CSOrderInfoViewCell *timeCell = [[CSOrderInfoViewCell alloc] initWithTitle:@"时间"];
    timeCell.subTitleLabel.textColor = HEX_COLOR(0xa63476);
    [self addSubview:timeCell];
    _timeCell = timeCell;
    // 包厢
    CSOrderInfoViewCell *roomCell = [[CSOrderInfoViewCell alloc] initWithTitle:@"房间"];
    roomCell.subTitleLabel.textColor = HEX_COLOR(0xffffff);
    [self addSubview:roomCell];
    _roomCell = roomCell;
    // 价格
    CSOrderInfoViewCell *priceCell = [[CSOrderInfoViewCell alloc] initWithTitle:@"价格"];
    priceCell.subTitleLabel.textColor = HEX_COLOR(0xa63476);
    
    [self addSubview:priceCell];
    _priceCell = priceCell;
    // 门店
    CSOrderInfoViewCell *shopCell = [[CSOrderInfoViewCell alloc] initWithTitle:@"门店"];
    shopCell.subTitleLabel.textColor = HEX_COLOR(0xffffff);
    [self addSubview:shopCell];
    _shopCell = shopCell;
    // 地址
    CSOrderInfoViewCell *addressCell = [[CSOrderInfoViewCell alloc] initWithTitle:@"地址"];
    
    addressCell.subTitleLabel.textColor = HEX_COLOR(0xffffff);
    [self addSubview:addressCell];
    addressCell.hiddenBottomLine = YES;
    _addressCell = addressCell;
    
}


- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_headerView.superview);
            make.height.mas_equalTo(TRANSFER_SIZE(38.0));
        }];
        
//        [_topicCell mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(_topicCell.superview);
//            make.top.equalTo(_headerView.mas_bottom);
//            make.height.mas_equalTo(52.0);
//        }];
        
        
        CGFloat cellHeight = TRANSFER_SIZE(40.0);
        [_timeCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_timeCell.superview);
            make.top.equalTo(_headerView.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(cellHeight);
        }];
        
        [_roomCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_roomCell.superview);
            make.top.equalTo(_timeCell.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(cellHeight);
        }];
        
        [_priceCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_priceCell.superview);
            make.top.equalTo(_roomCell.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(cellHeight);
        }];
        
        [_shopCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_shopCell.superview);
            make.top.equalTo(_priceCell.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(cellHeight);
        }];
        
        [_addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_addressCell.superview);
            make.top.equalTo(_shopCell.mas_bottom);
            make.height.mas_greaterThanOrEqualTo(cellHeight);
            make.bottom.equalTo(_addressCell.superview);
        }];
        
        
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setItem:(CSKTVBookingOrder *)item
{
    _item = item;
//    _topicCell.subTitle = item.theme;
    _roomCell.subTitle = item.boxTypeName;
    _timeCell.subTitle = item.totalTime;
    if (item.price.floatValue > 0) {
        _priceCell.subTitle = [NSString stringWithFormat:@"￥ %@",[NSString stringWithFloat:[_item.price floatValue]]];
    }
    _shopCell.subTitle = item.KTVName;
    _addressCell.subTitle = item.address;
}

@end
