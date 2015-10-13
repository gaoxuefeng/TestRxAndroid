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
    UIImageView *   _bldIdentityIcon ; // 宝乐迪标识图
    UILabel*        _nameLabel;
    
    UIImageView*    _imgView0; // 二级制从低位到高位的顺序是：团、促、卡、惠
    UIImageView*    _imgView1;
    UIImageView*    _imgView2;
    UIImageView*    _imgView3;
    
    UIImageView*    _ratingImgView;
    UILabel*        _priceLabel;
    
    UILabel*        _branchNameLabel;
    
    UILabel*        _discountLabel;
    
    UIButton*        _distanceBtn;
}
@end

@implementation CSKTVBookingCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.translatesAutoresizingMaskIntoConstraints = NO ;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsZero;
        [self setupSubViews];
    }
    return self;
}

- (void)updateConstraints {
    if (!_hasUpdatedContraints) {
        _hasUpdatedContraints = YES;
        // KTV图片
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.superview).offset(TRANSFER_SIZE(12));
            make.centerY.equalTo(_iconImageView.superview);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(78), TRANSFER_SIZE(54)));
        }];
        
        // 宝乐迪标识图
        [_bldIdentityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bldIdentityIcon.superview) ;
            make.top.equalTo(_bldIdentityIcon.superview) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(29), TRANSFER_SIZE(29))) ;
        }] ;
        // KTV名
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(TRANSFER_SIZE(12));
            make.top.equalTo(_iconImageView);
            make.height.mas_equalTo(TRANSFER_SIZE(15));
            make.right.mas_lessThanOrEqualTo(TRANSFER_SIZE(_nameLabel.superview.width - 72));
        }];
        
        // 团、促、卡、惠
        [_imgView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(TRANSFER_SIZE(9));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView0.mas_right).offset(TRANSFER_SIZE(3.5));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView1.mas_right).offset(TRANSFER_SIZE(3.5));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        [_imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView2.mas_right).offset(TRANSFER_SIZE(3.5));
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(13), TRANSFER_SIZE(13)));
        }];
        
        // 距离
        [_distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_distanceBtn.superview.mas_right).offset(TRANSFER_SIZE(-12));
            make.centerY.equalTo(_nameLabel.mas_centerY) ;
            make.height.mas_equalTo(TRANSFER_SIZE(10));
        }];

        // 星级
        [_ratingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(TRANSFER_SIZE(8));
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(53), TRANSFER_SIZE(9)));
        }];
        
        // 价格
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_ratingImgView.mas_right).offset(TRANSFER_SIZE(10));
            make.centerY.equalTo(_ratingImgView.mas_centerY);
            make.height.mas_equalTo(TRANSFER_SIZE(12));
            make.right.mas_lessThanOrEqualTo(_priceLabel.superview.mas_right).offset(TRANSFER_SIZE(-50));
        }];
        
        // 区名
        [_branchNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_ratingImgView.mas_bottom).offset(TRANSFER_SIZE(10));
            make.height.mas_equalTo(TRANSFER_SIZE(12));
            make.right.mas_lessThanOrEqualTo(_branchNameLabel.superview.mas_right).offset(TRANSFER_SIZE(-55));
        }];
        
        // 折扣
        [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_discountLabel.superview.mas_right).offset(TRANSFER_SIZE(-12));
            make.centerY.equalTo(_branchNameLabel.mas_centerY) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(40), TRANSFER_SIZE(15))) ;
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
    if (ktvModel.BLDKTVId != nil) {
        _bldIdentityIcon.hidden = NO ;
    }else{
        _bldIdentityIcon.hidden = YES ;
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:ktvModel.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_default_img"]];
    _nameLabel.text = ktvModel.KTVName;
    
    NSArray *icons = @[_imgView0, _imgView1, _imgView2, _imgView3];
    NSArray *imgs = @[[UIImage imageNamed:@"schedule_label_group"], [UIImage imageNamed:@"schedule_label_promotion"], [UIImage imageNamed:@"schedule_label_control"], [UIImage imageNamed:@"schedule_label_reserve"]];
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
    _discountLabel.layer.cornerRadius = 2.0 ;
    _discountLabel.layer.borderColor = HEX_COLOR(0xcd418f).CGColor ;
    _discountLabel.layer.borderWidth = 0.5 ;
    NSString *distance = [NSString stringWithFormat:@"%.1fkm", [ktvModel.distance floatValue] / 1000];
    [_distanceBtn setTitle:distance forState:UIControlStateNormal] ;
    
    [self updateConstraints];
}

- (void)setHiddenDistance:(BOOL)hiddenDistance
{
    _distanceBtn.hidden = hiddenDistance;
}

#pragma mark - Private Methods

- (void)setupSubViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 2.0;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _bldIdentityIcon = [[UIImageView alloc] init] ;
    _bldIdentityIcon.hidden = YES ;
    _bldIdentityIcon.image = [UIImage imageNamed:@"schedule_pic_title"] ;
    [_iconImageView addSubview:_bldIdentityIcon] ;
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _nameLabel.textColor = [UIColor whiteColor];
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
    _priceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
    _priceLabel.alpha = 0.6 ;
    [self.contentView addSubview:_priceLabel];

    _branchNameLabel = [[UILabel alloc] init];
    _branchNameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
    _branchNameLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
    _branchNameLabel.alpha = 0.6 ;
    [self.contentView addSubview:_branchNameLabel];
    
    _discountLabel = [[UILabel alloc] init];
    _discountLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10)];
    _discountLabel.textColor = HEX_COLOR(0xee29a7);
    _discountLabel.textAlignment = NSTextAlignmentCenter ;
    _discountLabel.alpha = 0.6 ;
    [self.contentView addSubview:_discountLabel];
    
    _distanceBtn = [[UIButton alloc] init];
    [_distanceBtn setImage:[UIImage imageNamed:@"schedule_distance"] forState:UIControlStateNormal] ;
    _distanceBtn.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10)];
    [_distanceBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.6] forState:UIControlStateNormal] ;
    [self.contentView addSubview:_distanceBtn];
}

@end
