//
//  CSMarkBookTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/7/31.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMarkBookTableViewCell.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSMarkBookModel.h"
@interface CSMarkBookTableViewCell ()
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UILabel *dateLabel;
@property(nonatomic, weak) UIImageView *arrowView;
@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSMarkBookTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"inRoomCell";
    CSMarkBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSMarkBookTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubviews
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.numberOfLines = 1;
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    nameLabel.textColor = HEX_COLOR(0xf0f0f0);
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.numberOfLines = 1;
    dateLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    dateLabel.textColor = HEX_COLOR(0xa9a9aa);
    [self.contentView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self.contentView addSubview:arrowView];
    _arrowView = arrowView;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x18171b);
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
}


#pragma mark - Public Methods
- (void)setItem:(CSMarkBookModel *)item
{
    _item = item;
    _nameLabel.text = item.ktvName;
    _dateLabel.text = item.date;
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_nameLabel.superview.mas_centerY).offset(-TRANSFER_SIZE(2.0));
            make.left.equalTo(_nameLabel.superview).offset(TRANSFER_SIZE(10.0));
        }];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dateLabel.superview.mas_centerY).offset(TRANSFER_SIZE(2.0));
            make.left.equalTo(_dateLabel.superview).offset(TRANSFER_SIZE(10.0));
        }];
        
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_arrowView.superview);
            make.right.equalTo(_arrowView.superview).offset(-TRANSFER_SIZE(10.0));
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_bottomLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}
@end




