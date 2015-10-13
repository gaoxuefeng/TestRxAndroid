//
//  CSKTVDetailTuangouCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVDetailTuangouCell.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSTuanGouItem.h"
#import <UIImageView+WebCache.h>

@interface CSKTVDetailTuangouCell () {
    UIImageView*    _iconImageView;
    UILabel*        _titleLabel;
    UILabel*        _sellNumLabel;
    UILabel*        _discountPriceLabel;
    UILabel*        _originalPriceLabel;
}
@end

@implementation CSKTVDetailTuangouCell

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

- (void)setDataWithTuanGouItem:(CSTuanGouItem *)tuanGouItem {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:tuanGouItem.photoUrl] placeholderImage:nil];
    _titleLabel.text = tuanGouItem.instruction;
    _sellNumLabel.text = [NSString stringWithFormat:@"已售%d", [tuanGouItem.seledNum intValue]];
    _discountPriceLabel.text = tuanGouItem.price;
    _originalPriceLabel.text = tuanGouItem.oldPrice;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // 团
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.cornerRadius = 2;
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(12));
        make.centerY.equalTo(_iconImageView.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(79), TRANSFER_SIZE(53)));
    }];
    
    // title
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
    _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(8));
        make.right.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(-13));
        make.top.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(12));
        make.height.mas_equalTo(TRANSFER_SIZE(14));
    }];
    
    // sell number
    _sellNumLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_sellNumLabel];
    _sellNumLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
    _sellNumLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    [_sellNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(8));
        make.top.equalTo(_titleLabel.mas_bottom).offset(TRANSFER_SIZE(23));
        make.height.mas_equalTo(TRANSFER_SIZE(12));
    }];

    // sell discount price
    _discountPriceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_discountPriceLabel];
    _discountPriceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _discountPriceLabel.textColor = HEX_COLOR(0xff00ab);
    _discountPriceLabel.textAlignment = NSTextAlignmentRight;
    [_discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_discountPriceLabel.superview).offset(TRANSFER_SIZE(-13));
        make.centerY.equalTo(_discountPriceLabel.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(15));
    }];

    _originalPriceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_originalPriceLabel];
    _originalPriceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
    _originalPriceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    _originalPriceLabel.textAlignment = NSTextAlignmentRight;
    [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_discountPriceLabel);
        make.top.equalTo(_discountPriceLabel.mas_bottom).offset(TRANSFER_SIZE(1));
        make.height.mas_equalTo(TRANSFER_SIZE(12));
    }];
    
    UIView *line = [[UIView alloc] init];
    [_originalPriceLabel addSubview:line];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line.superview);
        make.centerY.equalTo(line.superview);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Public Methods

- (void)setNumberOfTuangou:(NSInteger)number {
    _titleLabel.text = [NSString stringWithFormat:@"团购（%ld）", number];
}

@end
