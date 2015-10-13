//
//  CSOrderPayAddressCell.m
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderPayAddressCell.h"
#import <Masonry.h>
#import "CSDefine.h"

@interface CSOrderPayAddressCell ()
@property(nonatomic, assign) CSOrderPayAddressCellType type;

/** 顶部彩带 */
@property(nonatomic, weak) UIView *topView;
/** 姓名icon  */
@property(weak, nonatomic) UIImageView *nameIcon;
/** 姓名 */
@property(nonatomic, weak) UILabel *nameLabel;
/** 电话icon  */
@property(weak, nonatomic) UIImageView *phoneIcon;
/** 电话 */
@property(nonatomic, weak) UILabel *phoneLabel;
/** 地址 */
@property(nonatomic, weak) UILabel *addressLabel;


@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSOrderPayAddressCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = WhiteColor_Alpha_4;
        [self setupSubViews];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (instancetype)initWithType:(CSOrderPayAddressCellType)type
{
    _type = type;
    return [self init];
}

- (void)setupSubViews
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"pay_color_bar"]];
    _topView = topView;
    [self addSubview:topView];

    UIImageView *nameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_name"]];
    _nameIcon = nameIcon;
    [self addSubview:nameIcon];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = GlobalObj.userInfo.nickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _nameLabel = nameLabel;
    [self addSubview:nameLabel];
//    nameLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    nameLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    [nameLabel setTitle:GlobalObj.userInfo.nickName forState:UIControlStateNormal];
//    [nameLabel setImage:[UIImage imageNamed:@"pay_name"] forState:UIControlStateNormal];
//    [nameLabel setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
//    nameLabel.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
//    [nameLabel.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//    _nameLabel = nameLabel;
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_phone"]];
    _phoneIcon = phoneIcon;
    [self addSubview:phoneIcon];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = GlobalObj.userInfo.phoneNum;
    phoneLabel.textColor = [UIColor whiteColor];
    phoneLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _phoneLabel = phoneLabel;
    [self addSubview:phoneLabel];
//    UIButton *phoneLabel = [[UIButton alloc] init];
//    phoneLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    phoneLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    phoneLabel.userInteractionEnabled = NO;
//    [phoneLabel setTitle:GlobalObj.userInfo.phoneNum forState:UIControlStateNormal];
//    [phoneLabel setImage:[UIImage imageNamed:@"pay_phone"] forState:UIControlStateNormal];
//    [phoneLabel setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
//    phoneLabel.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
//    _phoneLabel = phoneLabel;
//    [self addSubview:phoneLabel];
    
    if (_type == CSOrderPayAddressCellTypeReserve) return;
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
    addressLabel.textColor = HEX_COLOR(0x7b7b82);
    _addressLabel = addressLabel;
    [self addSubview:addressLabel];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        CGFloat padding = TRANSFER_SIZE(15.0);
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(TRANSFER_SIZE(6.0));
        }];
        if (_type == CSOrderPayAddressCellTypeReserve) {
            
            [_nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameIcon.superview).offset(padding);
                make.size.mas_equalTo(_nameIcon.image.size);
                make.centerY.equalTo(_nameLabel.superview).offset(TRANSFER_SIZE(3.0));
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameIcon.mas_right).offset(TRANSFER_SIZE(5.0));
                make.centerY.equalTo(_nameIcon);
                make.width.mas_lessThanOrEqualTo(AUTOLENGTH(150.0));
            }];
            [_phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel.mas_right).offset(TRANSFER_SIZE(10.0));
                make.size.mas_equalTo(_phoneIcon.image.size);
                make.centerY.equalTo(_nameIcon);
            }];
            
            
            [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_phoneIcon.mas_right).offset(TRANSFER_SIZE(5.0));
                make.right.lessThanOrEqualTo(_phoneLabel.superview).offset(-TRANSFER_SIZE(10.0));
                make.centerY.equalTo(_nameIcon);
            }];
        }else
        {
            [_nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameIcon.superview).offset(padding);
                make.size.mas_equalTo(_nameIcon.image.size);
//                make.centerY.equalTo(_nameLabel.superview).offset(TRANSFER_SIZE(3.0));
                make.top.equalTo(_nameIcon.superview).offset(TRANSFER_SIZE(20.0));
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameIcon.mas_right).offset(TRANSFER_SIZE(5.0));
                make.centerY.equalTo(_nameIcon);
                make.width.mas_lessThanOrEqualTo(AUTOLENGTH(150.0));
            }];
            [_phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel.mas_right).offset(TRANSFER_SIZE(10.0));
                make.size.mas_equalTo(_phoneIcon.image.size);
                make.centerY.equalTo(_nameIcon);
            }];
            
            
            [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_phoneIcon.mas_right).offset(TRANSFER_SIZE(5.0));
                make.right.lessThanOrEqualTo(_phoneLabel.superview).offset(-TRANSFER_SIZE(10.0));
                make.centerY.equalTo(_nameIcon);
            }];
//            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_nameLabel.superview).offset(padding);
//                make.top.equalTo(_nameLabel.superview).offset(TRANSFER_SIZE(20.0));
//                make.width.mas_lessThanOrEqualTo(AUTOLENGTH(150.0));
//            }];
//            
//            [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.left.equalTo(_phoneLabel.superview).offset(SCREENWIDTH * 0.7);
//                make.left.equalTo(_nameLabel.mas_right).offset(TRANSFER_SIZE(10.0));
//                make.right.lessThanOrEqualTo(_phoneLabel.superview).offset(-TRANSFER_SIZE(10.0));
//                make.top.equalTo(_nameLabel);
//
//                
//            }];
//            
            [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_addressLabel.superview).offset(padding);
                make.top.equalTo(_nameLabel.mas_bottom).offset(TRANSFER_SIZE(12.0));
                make.bottom.equalTo(_addressLabel.superview).offset(-TRANSFER_SIZE(16.0));
            }];

        }
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setAddress:(NSString *)address
{
    if (_type != CSOrderPayAddressCellTypedrinks) return;
    _address = address;
    _addressLabel.text = address;
    
}

@end
