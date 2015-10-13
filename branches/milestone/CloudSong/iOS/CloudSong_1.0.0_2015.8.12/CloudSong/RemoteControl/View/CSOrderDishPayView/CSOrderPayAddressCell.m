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
/** 姓名 */
@property(nonatomic, weak) UIButton *nameButton;
/** 电话 */
@property(nonatomic, weak) UIButton *phoneButton;
/** 地址 */
@property(nonatomic, weak) UILabel *addressLabel;

@property(nonatomic, assign) BOOL didSetupConstraint;

@end

@implementation CSOrderPayAddressCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x222126);
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
    
    UIButton *nameButton = [[UIButton alloc] init];
    nameButton.userInteractionEnabled = NO;
    nameButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    nameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [nameButton setTitle:GlobalObj.userInfo.nickName forState:UIControlStateNormal];
    [nameButton setImage:[UIImage imageNamed:@"pay_name"] forState:UIControlStateNormal];
    [nameButton setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    _nameButton = nameButton;
    [self addSubview:nameButton];
    
    UIButton *phoneButton = [[UIButton alloc] init];
    phoneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    phoneButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    phoneButton.userInteractionEnabled = NO;
    [phoneButton setTitle:GlobalObj.userInfo.phoneNum forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"pay_phone"] forState:UIControlStateNormal];
    [phoneButton setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _phoneButton = phoneButton;
    [self addSubview:phoneButton];
    
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
            [_nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameButton.superview).offset(padding);
                make.centerY.equalTo(_nameButton.superview).offset(TRANSFER_SIZE(3.0));
                make.width.mas_lessThanOrEqualTo(AUTOLENGTH(150.0));
            }];
            
            [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameButton.mas_right).offset(TRANSFER_SIZE(10.0));
                make.right.lessThanOrEqualTo(_phoneButton.superview).offset(-TRANSFER_SIZE(10.0));

                make.centerY.equalTo(_nameButton);
            }];
        }else
        {
            [_nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameButton.superview).offset(padding);
                make.top.equalTo(_nameButton.superview).offset(TRANSFER_SIZE(20.0));
                make.width.mas_lessThanOrEqualTo(AUTOLENGTH(150.0));
            }];
            
            [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_phoneButton.superview).offset(SCREENWIDTH * 0.7);
                make.left.equalTo(_nameButton.mas_right).offset(TRANSFER_SIZE(10.0));
                make.right.lessThanOrEqualTo(_phoneButton.superview).offset(-TRANSFER_SIZE(10.0));
                make.top.equalTo(_nameButton);

                
            }];
            
            [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_addressLabel.superview).offset(padding);
                make.top.equalTo(_nameButton.mas_bottom).offset(TRANSFER_SIZE(12.0));
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
