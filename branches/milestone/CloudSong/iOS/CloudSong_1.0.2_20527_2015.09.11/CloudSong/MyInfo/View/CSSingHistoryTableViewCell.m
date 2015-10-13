//
//  CSSingHistoryTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSingHistoryTableViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface CSSingHistoryTableViewCell ()
@property(nonatomic, weak) UIImageView *picView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *subTitleLabel;
@property(nonatomic, weak) UIView *titleView;
@property(nonatomic, weak) UIButton *addButton;
@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation CSSingHistoryTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"historySongCell";
    CSSingHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSSingHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = HEX_COLOR(0x1d1c21);
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UIImageView *picView = [[UIImageView alloc] init];
    picView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.1];
    picView.layer.cornerRadius = TRANSFER_SIZE(3.0);
    picView.layer.masksToBounds = YES;
    [self.contentView addSubview:picView];
    _picView = picView;
    
    UIView *titleView = [[UIView alloc] init];
    [self.contentView addSubview:titleView];
    _titleView = titleView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    titleLabel.textColor = HEX_COLOR(0x9799a1);
    [titleView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
    subTitleLabel.textColor = HEX_COLOR(0x4c4d53);
    [titleView addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [addButton setImage:[[UIImage imageNamed:@"song_selected_btn_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [addButton setImage:[UIImage imageNamed:@"song_selected_btn_normal"] forState:UIControlStateNormal];
//    [addButton setImage:[UIImage imageNamed:@"song_selected_btn_press"] forState:UIControlStateHighlighted];

    [self.contentView addSubview:addButton];
    _addButton = addButton;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x18171b);
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
}

- (void)setItem:(CSSong *)item
{
    _item = item;
    [_picView sd_setImageWithURL:[NSURL URLWithString:item.songImageUrl]];
    _titleLabel.text = item.songName;
    _subTitleLabel.text = [NSString stringWithFormat:@"%@-%@",item.language,[item.singers.firstObject singerName]];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_picView.superview);
            make.left.equalTo(_picView.superview).offset(TRANSFER_SIZE(10.0));
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(51.0), TRANSFER_SIZE(51.0)));
        }];
        
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_picView.mas_right).offset(TRANSFER_SIZE(10.0));
            make.centerY.equalTo(_titleView.superview);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_titleLabel.superview);
            make.right.mas_lessThanOrEqualTo(_titleLabel.superview);
            make.bottom.equalTo(_subTitleLabel.mas_top).offset(-TRANSFER_SIZE(7.0));
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_subTitleLabel.superview);
            make.right.mas_lessThanOrEqualTo(_subTitleLabel.superview);
        }];
        
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_addButton.superview);
            make.right.equalTo(_addButton.superview).offset(-TRANSFER_SIZE(9.0));
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(_bottomLine.superview);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}


@end
