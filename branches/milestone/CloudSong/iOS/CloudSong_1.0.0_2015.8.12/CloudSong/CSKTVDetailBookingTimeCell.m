//
//  CSKTVDetailBookingTimeCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVDetailBookingTimeCell.h"
#import <Masonry.h>
#import "CSDefine.h"

@interface CSKTVDetailBookingTimeCell () {
    UILabel*    _dateLabel;
    UILabel*    _startTimeLabel;
    UILabel*    _durationLabel;
}

@end

@implementation CSKTVDetailBookingTimeCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HEX_COLOR(0x1a1a1e);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setDate:(NSString *)date startTime:(NSString *)startTime duration:(NSString *)duration {
    _dateLabel.text = date;
    _startTimeLabel.text = startTime;
    _durationLabel.text = duration;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // 预约时间
    UILabel* timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    timeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
    timeLabel.text = @"预约时间:";
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.superview).offset(TRANSFER_SIZE(10));
        make.top.bottom.equalTo(timeLabel.superview);
    }];
    
    // 日期
    _dateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    _dateLabel.textColor = HEX_COLOR(0xff00ab);
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(TRANSFER_SIZE(8));
        make.top.bottom.equalTo(_dateLabel.superview);
    }];
    
    // 起唱时间
    _startTimeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_startTimeLabel];
    _startTimeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    _startTimeLabel.textColor = HEX_COLOR(0xff00ab);
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_startTimeLabel.superview).offset(TRANSFER_SIZE(20));
        make.top.bottom.equalTo(_startTimeLabel.superview);
    }];

    // K歌时长
    _durationLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_durationLabel];
    _durationLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    _durationLabel.textColor = HEX_COLOR(0xff00ab);
    _durationLabel.textAlignment = NSTextAlignmentRight;
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_durationLabel.superview).offset(TRANSFER_SIZE(-22));
        make.top.bottom.equalTo(_durationLabel.superview);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self.contentView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.superview).offset(TRANSFER_SIZE(-10));
        make.centerY.equalTo(arrow.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(8), TRANSFER_SIZE(13)));
    }];
}

@end
