//
//  CSRecommendedAlbumCollectionCell.m
//  CloudSong
//
//  Created by youmingtaizi on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRecommendedAlbumCollectionCell.h"
#import "CSDefine.h"
#import "CSRecommendedAlbum.h"
#import <Masonry.h>

@interface CSRecommendedAlbumCollectionCell () {
    UIImageView*   _imageView;
    UILabel*       _titleLabel;
}
@end

@implementation CSRecommendedAlbumCollectionCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setDataWithAlbum:(CSRecommendedAlbum *)album {
    _imageView.image = album.image;
    _titleLabel.text = album.listTypeName;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    _imageView.alpha = 1;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_imageView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(83));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [HEX_COLOR(0xffffff)colorWithAlphaComponent:.8];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel.superview);
        make.top.equalTo(_imageView.mas_bottom).offset(TRANSFER_SIZE(7));
        make.height.mas_equalTo(TRANSFER_SIZE(16));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configSelfUI];
}

- (void)configSelfUI {
    self.backgroundColor = [UIColor clearColor];
//    _titleLabel.textColor = [Color_Hex_97_99_a2 colorWithAlphaComponent:.5];
//    _titleLabel.font = [UIFont systemFontOfSize:13];
}


@end
