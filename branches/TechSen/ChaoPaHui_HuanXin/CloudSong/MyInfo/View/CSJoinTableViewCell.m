//
//  CSJoinTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSJoinTableViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#define PICTURE_RADIUS TRANSFER_SIZE(25.0)
@interface CSJoinTableViewCell ()
@property(nonatomic, weak) UIImageView *picView;
@property(nonatomic, weak) UIView *titleView;
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UIImageView *genderView;
@property(nonatomic, weak) UILabel *phoneLabel;
@property(nonatomic, weak) UILabel *dateLabel;
@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, assign) BOOL didSetupConstraint;

@end


@implementation CSJoinTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"joinCell";
    CSJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSJoinTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_COLOR(0x222126);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x141417);
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
    
    UIImageView *picView = [[UIImageView alloc] init];
//    picView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.1];
    picView.layer.cornerRadius = PICTURE_RADIUS;
    picView.layer.masksToBounds = YES;
    [self.contentView addSubview:picView];
    _picView = picView;
    
    UIView *titleView = [[UIView alloc] init];
    [self.contentView addSubview:titleView];
    _titleView = titleView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
    nameLabel.textColor = HEX_COLOR(0x717379);
    [titleView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UIImageView *genderView = [[UIImageView alloc] init];
    [titleView addSubview:genderView];
    _genderView = genderView;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
    phoneLabel.textColor = HEX_COLOR(0x505056);
    [titleView addSubview:phoneLabel];
    _phoneLabel = phoneLabel;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = HEX_COLOR(0xff41ab);
    dateLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
    [self.contentView addSubview:dateLabel];
    _dateLabel = dateLabel;
}

- (void)setItem:(CSJoinModel *)item
{
    _item = item;
    _nameLabel.text = item.nickName;
    _phoneLabel.text = item.phoneNum;
    _dateLabel.text = item.date;
    [_picView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
    NSString *genderName = nil;
    if ([item.gender isEqualToString:@"男"]) {
        genderName = @"mine_man";
    }else
    {
        genderName = @"mine_female";
    }
    _genderView.image = [UIImage imageNamed:genderName];
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints
{
    if (!_didSetupConstraint) {        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_bottomLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_picView.superview);
            make.left.equalTo(_picView.superview).offset(TRANSFER_SIZE(10.0));
            make.size.mas_equalTo(CGSizeMake(PICTURE_RADIUS * 2, PICTURE_RADIUS * 2));
        }];
        
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView.superview);
            make.left.equalTo(_picView.mas_right).offset(TRANSFER_SIZE(10.0));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_nameLabel.superview);
            make.bottom.equalTo(_phoneLabel.mas_top).offset(-TRANSFER_SIZE(2.0));
            make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(130.0));
        }];
        
        [_genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameLabel);
            make.left.equalTo(_nameLabel.mas_right).offset(TRANSFER_SIZE(5.0));
        }];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_phoneLabel.superview);
        }];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_dateLabel.superview);
            make.right.equalTo(_dateLabel.superview).offset(-TRANSFER_SIZE(20.0));
        }];

        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}




@end
