//
//  CSSingerCell.m
//  CloudSong
//
//  Created by youmingtaizi on 6/6/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSingerCell.h"
#import "CSSinger.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "CSDefine.h"

@interface CSSingerCell () {
    UIImageView*   _iconImageView;
    UILabel*       _nameLabel;
}
@end

@implementation CSSingerCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setDataWithSinger:(CSSinger *)singer {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:singer.singerImageUrl] placeholderImage:[UIImage imageNamed:@"song_default_head"]] ;
    _nameLabel.text = singer.singerName;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.cornerRadius = TRANSFER_SIZE(20);
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(10));
        make.centerY.equalTo(_iconImageView.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(40), TRANSFER_SIZE(40)));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _nameLabel.textColor = HEX_COLOR(0xffffff);
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(8));
        make.centerY.equalTo(_nameLabel.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(300), TRANSFER_SIZE(17)));
    }];
}

@end
