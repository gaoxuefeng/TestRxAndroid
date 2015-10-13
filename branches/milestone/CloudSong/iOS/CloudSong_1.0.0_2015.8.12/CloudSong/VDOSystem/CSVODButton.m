//
//  CSVODButton.m
//  CloudSong
//
//  Created by youmingtaizi on 7/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSVODButton.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSVODButton () {
    UIImageView*    _iconView;
    UILabel*        _titleLabel;
}
@end

@implementation CSVODButton

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title image:(UIImage *)img {
    _titleLabel.text = title;
    _iconView.image = img;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _iconView = [[UIImageView alloc] init];
    [self addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconView.superview);
        make.top.equalTo(_iconView.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(25), TRANSFER_SIZE(25)));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
    _titleLabel.textColor = HEX_COLOR(0x9799a1);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel.superview);
        make.bottom.equalTo(_titleLabel.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(14));
    }];
}

@end
