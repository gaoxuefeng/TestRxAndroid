//
//  CSHotSingersCollectionViewCell.m
//  CloudSong
//
//  Created by youmingtaizi on 6/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSHotSingersCollectionViewCell.h"
#import "CSSinger.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "CSDefine.h"

@interface CSHotSingersCollectionViewCell ()
{
    UIImageView*   _iconImageView;
    UILabel*       _nameLabel;
}
@end

@implementation CSHotSingersCollectionViewCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setDataWithSingerItem:(CSSinger *)singerItem {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:singerItem.singerImageUrl] placeholderImage:[UIImage imageNamed:@"song_default_head"]] ;
    _nameLabel.text = singerItem.singerName;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = HEX_COLOR(0x151417);

    // icon
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.masksToBounds = YES ;
    _iconImageView.layer.cornerRadius = TRANSFER_SIZE(35)/2;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(35), TRANSFER_SIZE(35)));
        make.centerY.equalTo(_iconImageView.superview);
    }];
    
    // label
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _nameLabel.textColor = HEX_COLOR(0x9799a1);
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(10));
        make.top.bottom.equalTo(_nameLabel.superview);
        make.right.equalTo(_nameLabel.superview);
    }];
}

@end
