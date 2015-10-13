//
//  CSSongCategoryCell.m
//  CloudSong
//
//  Created by youmingtaizi on 6/10/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongCategoryCell.h"
#import <Masonry.h>
#import "CSDefine.h"
#import <UIImageView+WebCache.h>
#import "CSSongCategoryItem.h"

@interface CSSongCategoryCell () {
    UIImageView*    _icon;
    UILabel*        _title;
}
@end

@implementation CSSongCategoryCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setDataWithCategory:(CSSongCategoryItem *)category {
    [_icon sd_setImageWithURL:[NSURL URLWithString:category.imageSrc] placeholderImage:[UIImage imageNamed:@""]];
    _title.text = category.listTypeName;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _icon = [[UIImageView alloc] init];
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_icon.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(93));
    }];

    _title = [[UILabel alloc] init];
    [self.contentView addSubview:_title];
    _title.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(13)];
    _title.textColor = HEX_COLOR(0xb5b7bf);
    _title.textAlignment = NSTextAlignmentCenter;
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_title.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(13));
    }];

}

@end
