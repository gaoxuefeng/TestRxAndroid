//
//  CSBookingRoomButton.m
//  CloudSong
//
//  Created by youmingtaizi on 7/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBookingRoomButton.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSBookingRoomButton () {
    UILabel*    _titleLabel;
}
@end

@implementation CSBookingRoomButton

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (NSString *)title
{
    return _titleLabel.text ;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title ;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = HEX_COLOR(0x222126);
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16)];
    _titleLabel.textColor = HEX_COLOR(0x9898a2);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(10));
        make.right.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(-10));
        make.top.equalTo(_titleLabel.superview);
        make.bottom.equalTo(_titleLabel.superview);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_next_icon"]];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.superview).offset(TRANSFER_SIZE(-10));
        make.centerY.equalTo(arrow.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(6), 10));
    }];
}

@end
