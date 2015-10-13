//
//  CSInRoomStatusTableViewCell.m
//  CloudSong
//
//  Created by sen on 15/6/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInRoomStatusTableViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "UIImage+Extension.h"
#import "CSMessageView.h"
#define CIRCLE_RADIUS 5.5
@interface CSInRoomStatusTableViewCell ()
@property(nonatomic, weak) UILabel *timeLabel;
/** 小圆圈 */
@property(nonatomic, weak) UIView *circleView;
/* 竖线 */
@property(nonatomic, weak) UIView *vLine;

/** 用户名 */
@property(nonatomic, weak) UIButton *nameButton;

@property(nonatomic, weak) CSMessageView *messageView;

@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSInRoomStatusTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"inRoomCell";
    CSInRoomStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSInRoomStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:10.0];
    timeLabel.textColor = HEX_COLOR(0x8e8e8f);
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UIView *circleView = [[UIView alloc] init];
    circleView.backgroundColor = [UIColor clearColor];
    if (_circleColor) {
        _circleView.layer.borderColor = _circleColor.CGColor;
    }
    circleView.layer.borderWidth = 2.0;
    circleView.layer.cornerRadius = CIRCLE_RADIUS;
    circleView.layer.masksToBounds = YES;
    [self.contentView addSubview:circleView];
    _circleView = circleView;
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = HEX_COLOR(0x4a494d);
    vLine.layer.cornerRadius = 1.0;
    vLine.layer.masksToBounds = YES;
    [self.contentView addSubview:vLine];
    _vLine = vLine;
    
    
    CSMessageView *messageView = [[CSMessageView alloc] init];
    [self.contentView addSubview:messageView];
    _messageView = messageView;

}

#pragma mark - Public Methods
- (void)setItem:(CSInRoomUserModel *)item
{
    _item = item;
    _timeLabel.text = item.time;
    _messageView.content = [NSString stringWithFormat:@"%@进入了房间",item.nickName];
    [self updateConstraintsIfNeeded];
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    _circleView.layer.borderColor = circleColor.CGColor;
}

- (void)setHiddenVLine:(BOOL)hiddenVLine
{
    _hiddenVLine = hiddenVLine;
    _vLine.hidden = hiddenVLine;
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel.superview).offset(16.0);
            make.top.equalTo(_timeLabel.superview).offset(7.0);
        }];
        
        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeLabel);
            make.left.equalTo(_circleView.superview).offset(67.0);
            make.size.mas_equalTo(CGSizeMake(CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 2));
        }];
        
        [_vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_circleView.mas_bottom).offset(8.0);
            make.bottom.equalTo(_vLine.superview).offset(-1.0);
            make.centerX.equalTo(_circleView);
            make.width.mas_equalTo(1.5);
        }];
        

        
        [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_messageView.superview);
            make.left.equalTo(_messageView.superview).offset(94.0);
            make.right.lessThanOrEqualTo(_messageView.superview).offset(-10.0);
        }];
        

        
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}



@end
