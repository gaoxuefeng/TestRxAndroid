//
//  CSSearchButton.m
//  CloudSong
//
//  Created by youmingtaizi on 7/6/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSearchButton.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSSearchButton () {
    UILabel*    _titleLabel;
    UIImageView*    _arrowImgView;
}
@end

@implementation CSSearchButton

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setSelectedState:(BOOL)selected {
    _titleLabel.textColor = selected ? HEX_COLOR(0x71407a) : [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.4];
    _arrowImgView.image = [UIImage imageNamed:selected ? @"search_up" : @"search_down"];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _titleLabel.textColor = HEX_COLOR(0x71407a);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(54));
        make.top.bottom.equalTo(_titleLabel.superview);
    }];
    
    _arrowImgView = [[UIImageView alloc] init];
    [self addSubview:_arrowImgView];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TRANSFER_SIZE(92));
        make.centerY.equalTo(_arrowImgView.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(10), TRANSFER_SIZE(6)));
    }];
}

@end
