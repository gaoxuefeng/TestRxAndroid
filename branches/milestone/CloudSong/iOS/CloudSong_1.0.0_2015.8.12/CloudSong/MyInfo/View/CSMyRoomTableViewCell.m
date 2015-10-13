//
//  CSMyRoomTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyRoomTableViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "UIImage+Extension.h"
#import <UIImageView+WebCache.h>
#define PICTURE_RADIUS TRANSFER_SIZE(20.0)
@interface CSMyRoomTableViewCell ()
@property(nonatomic, weak) UIView *centerLine;
@property(nonatomic, weak) UIView *bodyView;
@property(nonatomic, weak) UIImageView *picView;
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UILabel *shopNameLabel;
@property(nonatomic, weak) UIButton *addressButton;
//@property(nonatomic, weak) UIButton *distanceButton;
@property(nonatomic, weak) UIButton *joinCountButton;
@property(nonatomic, weak) UIButton *countDownButton;
@property(nonatomic, assign) BOOL didSetupConstaint;

@end


@implementation CSMyRoomTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"myRoomCell";
    CSMyRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSMyRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_COLOR(0x242329);
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self setupSubViews];
    }
    return self;
}
#pragma mark - Setup
- (void)setupSubViews
{
    [self setupBodyView];
    
    UIView *centerLine = [[UIView alloc] init];
    centerLine.backgroundColor = HEX_COLOR(0x19181b);
    [self.contentView addSubview:centerLine];
    _centerLine = centerLine;
    
    [self setupFooterView];
}

- (void)setupBodyView
{
    UIView *bodyView = [[UIView alloc] init];
    [self.contentView addSubview:bodyView];
    _bodyView = bodyView;
    
    
    // 头像
    UIImageView *picView = [[UIImageView alloc] init];
    picView.layer.cornerRadius = PICTURE_RADIUS;
    picView.layer.masksToBounds = YES;
    [bodyView addSubview:picView];
    _picView = picView;
    
    
    // 创建者昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    nameLabel.textColor = HEX_COLOR(0xdfdfe0);
    [bodyView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *shopNameLabel = [[UILabel alloc] init];
    shopNameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    shopNameLabel.textColor = HEX_COLOR(0xaaaaab);
    [bodyView addSubview:shopNameLabel];
    _shopNameLabel = shopNameLabel;
    
    // 倒计计时
    UIButton *countDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countDownButton setBackgroundImage:[[UIImage imageNamed:@"room_start_bg"] stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5] forState:UIControlStateNormal]; [countDownButton setBackgroundImage:[[UIImage imageNamed:@"room_end_bg"] stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5] forState:UIControlStateHighlighted];
    countDownButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    [countDownButton setTitleColor:HEX_COLOR(0xc1c1c1) forState:UIControlStateNormal];
//    [countDownButton setTitle:@"离开始还有3天" forState:UIControlStateNormal];
    [countDownButton setContentEdgeInsets:UIEdgeInsetsMake(0, TRANSFER_SIZE(20.0), 0, TRANSFER_SIZE(10.0))];
    countDownButton.userInteractionEnabled = NO;
    [_bodyView addSubview:countDownButton];
    _countDownButton = countDownButton;
}

- (void)setupFooterView
{
    
    // 地址
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addressButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [addressButton addTarget:self action:@selector(addressBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    addressButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    [addressButton setTitleColor:HEX_COLOR(0x959597) forState:UIControlStateNormal];
    [addressButton setImage:[[UIImage imageNamed:@"room_position_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    addressButton.imageEdgeInsets = UIEdgeInsetsMake(0, -TRANSFER_SIZE(10.0), 0, 0);
    [self.contentView addSubview:addressButton];
    _addressButton = addressButton;
    
    
//    // 距离
//    UIButton *distanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    distanceButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10.0)];
//    distanceButton.imageEdgeInsets = UIEdgeInsetsMake(0, -TRANSFER_SIZE(5.0), 0, 0);
//    [distanceButton setTitleColor:HEX_COLOR(0x959597) forState:UIControlStateNormal];
//    [distanceButton setImage:[[UIImage imageNamed:@"room_location_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [distanceButton setTitleColor:HEX_COLOR(0x959597) forState:UIControlStateNormal];
//    [self.contentView addSubview:distanceButton];
//    _distanceButton = distanceButton;
    
    // 参与人数
    UIButton *joinCountButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [joinCountButton addTarget:self action:@selector(joinCountBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [joinCountButton setImage:[[UIImage imageNamed:@"room_people_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [joinCountButton setTitleColor:HEX_COLOR(0x9799a1) forState:UIControlStateNormal];
    joinCountButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    joinCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -TRANSFER_SIZE(10.0), 0, 0);
    [self.contentView addSubview:joinCountButton];
    _joinCountButton = joinCountButton;
}

- (void)setItem:(CSMyRoomModel *)item
{
    _item = item;
    _nameLabel.text = item.reservationName;
    _shopNameLabel.text = item.ktvName;
    [_picView sd_setImageWithURL:[NSURL URLWithString:_item.reservationAvatarUrl]];
    [_countDownButton setTitle:item.discribe forState:UIControlStateNormal];
    _countDownButton.highlighted = item.starting;
    [_joinCountButton setTitle:[NSString stringWithFormat:@"参与人数 %d人",[item.joinCount intValue]] forState:UIControlStateNormal];
    [_addressButton setTitle:item.address forState:UIControlStateNormal];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!_didSetupConstaint) {

        [_bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bodyView.superview);
            make.height.mas_equalTo(TRANSFER_SIZE(70.0));
        }];
        
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_picView.superview);
            make.left.equalTo(_picView.superview).offset(TRANSFER_SIZE(15.0));
            make.size.mas_equalTo(CGSizeMake(PICTURE_RADIUS * 2, PICTURE_RADIUS * 2));
        }];
        
        CGFloat padding = TRANSFER_SIZE(3.0);
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_picView.mas_right).offset(TRANSFER_SIZE(10.0));
            make.bottom.equalTo(_picView.mas_centerY).offset(-padding);
//            make.right.equalTo(_countDownButton.mas_left).offset(-TRANSFER_SIZE(5.0));
            make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(120.0));
        }];
        
        [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_picView.mas_centerY).offset(padding);
        }];
        
        [_countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_countDownButton.superview).offset(TRANSFER_SIZE(12.0));
            make.right.equalTo(_countDownButton.superview);
        }];
        
        [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bodyView.mas_bottom);
            make.left.equalTo(_picView);
            make.right.equalTo(_centerLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        CGFloat footer_padding = TRANSFER_SIZE(9.0);
        [_addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerLine.mas_bottom).offset(footer_padding);
            make.left.equalTo(_addressButton.superview).offset(TRANSFER_SIZE(24.0));
            make.right.equalTo(_addressButton.superview).offset(-TRANSFER_SIZE(10.0));
        }];
//        
//        [_distanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_addressButton);
//            make.right.equalTo(_distanceButton.superview).offset(-TRANSFER_SIZE(5.0));
//        }];
        
        [_joinCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-footer_padding);
            
            make.left.equalTo(_addressButton);
        }];
        
        _didSetupConstaint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Action Methods
- (void)joinCountBtnOnClick
{
    if ([self.delegate respondsToSelector:@selector(myRoomTableViewCellJoinCountBtnOnClick:)]) {
        [self.delegate myRoomTableViewCellJoinCountBtnOnClick:self];
    }
}

- (void)addressBtnOnClick
{
    if ([self.delegate respondsToSelector:@selector(myRoomTableViewCellAddressBtnOnClick:)]) {
        [self.delegate myRoomTableViewCellAddressBtnOnClick:self];
    }
}
@end
