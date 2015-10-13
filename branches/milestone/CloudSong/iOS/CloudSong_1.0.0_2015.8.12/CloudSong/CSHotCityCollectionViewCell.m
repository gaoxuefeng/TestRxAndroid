//
//  CSHotCityCollectionViewCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSHotCityCollectionViewCell.h"
#import "CSDefine.h"
#import <Masonry.h>
#import <UIKit/UIKit.h>

@interface CSHotCityCollectionViewCell () {
    UILabel*    _titleLabel;
}
@end

@implementation CSHotCityCollectionViewCell

#pragma mark - Life Cycle 

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = HEX_COLOR(0x9799a1);
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
    _titleLabel.textColor = HEX_COLOR(0x9799a1);
    _titleLabel.backgroundColor = HEX_COLOR(0x1c1c20);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(TRANSFER_SIZE(.5));
        make.right.equalTo(self).offset(TRANSFER_SIZE(-.5));
        make.top.equalTo(self).offset(TRANSFER_SIZE(.5));
        make.bottom.equalTo(self).offset(TRANSFER_SIZE(-.5));
    }];
}

@end
