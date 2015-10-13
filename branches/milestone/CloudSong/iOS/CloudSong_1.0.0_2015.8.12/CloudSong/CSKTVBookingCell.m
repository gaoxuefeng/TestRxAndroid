//
//  CSKTVBookingCell.m
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVBookingCell.h"
#import "CSKTVModel.h"
#import "CSDefine.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface CSKTVBookingCell () {
    BOOL _hasUpdatedContraints;
    UIImageView*    _iconImageView;
    
    UILabel*        _nameLabel;
    
    UIImageView*    _imgView0; // 团、促、卡、惠
    UIImageView*    _imgView1;
    UIImageView*    _imgView2;
    UIImageView*    _imgView3;
    
    UIImageView*    _ratingImgView;
    UILabel*        _priceLabel;
    
    UILabel*        _branchNameLabel;
    
    UILabel*        _discountLabel;
    
    UILabel*        _distanceLabel;
}
@end

@implementation CSKTVBookingCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsZero;
        [self setupSubViews];
    }
    return self;
}

- (void)updateConstraints {
    if (!_hasUpdatedContraints) {
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(12));
            make.centerY.equalTo(_iconImageView.superview);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(78), TRANSFER_SIZE(54)));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(12));
            make.top.equalTo(_iconImageView);
            make.height.mas_equalTo(TRANSFER_SIZE(15));
            make.right.mas_lessThanOrEqualTo(TRANSFER_SIZE(_nameLabel.superview.width - 72));
        }];
        
        [_imgView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(TRANSFER_SIZE(9));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView0.mas_right).offset(TRANSFER_SIZE(5));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView1.mas_right).offset(TRANSFER_SIZE(5));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView2.mas_right).offset(TRANSFER_SIZE(5));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_ratingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(TRANSFER_SIZE(8));
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(53), TRANSFER_SIZE(9)));
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_ratingImgView.mas_right).offset(TRANSFER_SIZE(10));
            make.centerY.equalTo(_ratingImgView.mas_centerY);
            make.height.mas_equalTo(TRANSFER_SIZE(12));
            make.right.mas_lessThanOrEqualTo(_priceLabel.superview.mas_right).offset(TRANSFER_SIZE(-50));
        }];
        
        [_branchNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_ratingImgView.mas_bottom).offset(TRANSFER_SIZE(10));
            make.height.mas_equalTo(TRANSFER_SIZE(12));
            make.right.mas_lessThanOrEqualTo(_branchNameLabel.superview.mas_right).offset(TRANSFER_SIZE(-50));
        }];
        
        [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_discountLabel.superview.mas_right).offset(TRANSFER_SIZE(-12));
            make.top.equalTo(_discountLabel.superview.mas_top).offset(TRANSFER_SIZE(34));
            make.height.mas_equalTo(TRANSFER_SIZE(10));
        }];
        
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_distanceLabel.superview.mas_right).offset(TRANSFER_SIZE(-12));
            make.top.equalTo(_discountLabel.mas_bottom).offset(TRANSFER_SIZE(13));
            make.height.mas_equalTo(TRANSFER_SIZE(10));
        }];
    }
    [super updateConstraints];
}

#pragma mark - Public Methods

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier =  @"CSKTVBookingCell";
    CSKTVBookingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSKTVBookingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setDataithKTVModel:(CSKTVModel *)ktvModel {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:ktvModel.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_default_img"]];
    _nameLabel.text = ktvModel.KTVName;
    
    NSArray *icons = @[_imgView0, _imgView1, _imgView2, _imgView3];
    NSArray *imgs = @[[UIImage imageNamed:@"schedule_tuan"], [UIImage imageNamed:@"schedule_cu"], [UIImage imageNamed:@"schedule_ka"], [UIImage imageNamed:@"schedule_hui"]];
    NSInteger flag = [ktvModel.discountIconMeg integerValue];
    
    int numberOfFlag = 0;
    for (int pow = 0; pow < 4; ++pow) {
        // 每一个icon默认都是隐藏状态
        UIImageView* imgView = icons[pow];
        imgView.hidden = YES;
        
        // 显示icon
        if (flag & 1 << pow) {
            imgView = icons[numberOfFlag++];
            imgView.hidden = NO;
            
            // 设置icon图片
            imgView.image = imgs[pow];
        }
    }
    
    NSString *ratingImgName = [NSString stringWithFormat:@"schedule_star_%ld", [ktvModel.rating integerValue] / 5 + 1];
    _ratingImgView.image = [UIImage imageNamed:ratingImgName];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.0f/人", [ktvModel.price floatValue]];

    _branchNameLabel.text = ktvModel.address;
    
    _discountLabel.text = ktvModel.discountMeg;
    _discountLabel.text = @"6.9折起";
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", [ktvModel.distance floatValue] / 1000];
    
    [self updateConstraints];
}

- (void)setHiddenDistance:(BOOL)hiddenDistance
{
    _distanceLabel.hidden = hiddenDistance;
}

#pragma mark - Private Methods

- (void)setupSubViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 2.0;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _nameLabel.textColor = HEX_COLOR(0x9799a2);
    [self.contentView addSubview:_nameLabel];
    
    _imgView0 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView0];
    
    _imgView1 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView1];
    
    _imgView2 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView2];

    _imgView3 = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView3];
    
    _ratingImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_ratingImgView];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
    _priceLabel.textColor = HEX_COLOR(0x9799a2);
    [self.contentView addSubview:_priceLabel];

    _branchNameLabel = [[UILabel alloc] init];
    _branchNameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
    _branchNameLabel.textColor = HEX_COLOR(0x5a5b61);
    [self.contentView addSubview:_branchNameLabel];
    
    _discountLabel = [[UILabel alloc] init];
    _discountLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10)];
    _discountLabel.textColor = HEX_COLOR(0xcd418f);
    _discountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_discountLabel];
    
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10)];
    _distanceLabel.textColor = HEX_COLOR(0x5a5b61);
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_distanceLabel];
}

@end
