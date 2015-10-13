//
//  CSKTVDetailTuangouLabelCell.m
//  CloudSong
//
//  Created by youmingtaizi on 7/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVDetailTuangouLabelCell.h"
#import <Masonry.h>
#import "CSDefine.h"

@interface CSKTVDetailTuangouLabelCell () {
    UILabel*    _titleLabel;
}
@end

@implementation CSKTVDetailTuangouLabelCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_COLOR(0x1a1a1e);
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // 团
    UIImageView *tuanImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_tuan"]];
    [self.contentView addSubview:tuanImgView];
    [tuanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tuanImgView.superview).offset(TRANSFER_SIZE(10));
        make.centerY.equalTo(tuanImgView.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
    }];

    // 团购
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
    _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tuanImgView.mas_right).offset(TRANSFER_SIZE(10));
        make.top.bottom.equalTo(_titleLabel.superview);
    }];
}

#pragma mark - Public Methods

- (void)setNumberOfTuangou:(NSInteger)number {
    _titleLabel.text = [NSString stringWithFormat:@"团购（%ld）", number];
}

@end
