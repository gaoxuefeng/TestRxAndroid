//
//  NBPayAddressView.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayAddressView.h"
#import "NBCommon.h"
@interface NBPayAddressView()
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UILabel *phoneLabel;
@property(nonatomic, weak) UILabel *addressLabel;
@property(nonatomic, weak) UIButton *addressCell;
/** 新增地址Label */
@property(nonatomic, weak) UILabel *addAddressLabel;
@property(nonatomic, weak) UIImageView *topImageView;
@property(nonatomic, weak) UIImageView *arrowImage;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UIView *addressContainer;
@end

@implementation NBPayAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR(0xf3f3f3);
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews
{
    UIButton *addressCell = [[UIButton alloc] initForAutoLayout];
    addressCell.backgroundColor = [UIColor whiteColor];
    [self addSubview:addressCell];
    _addressCell = addressCell;
    
    // 花纹
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:iPhone6?[UIImage imageNamed:@"pay_letter_line_6"]:[UIImage imageNamed:@"pay_letter_line"]];
    [addressCell addSubview:topImageView];
    _topImageView = topImageView;
    
    
    
    // 新增地址
    UILabel *addAddressLabel = [[UILabel alloc] initForAutoLayout];
    addAddressLabel.text = @"新增地址";
    addAddressLabel.font = [UIFont systemFontOfSize:15.f];
    addAddressLabel.textColor = HEX_COLOR(0x464646);
    [addressCell addSubview:addAddressLabel];
    _addAddressLabel = addAddressLabel;
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12.f];
    nameLabel.textColor = HEX_COLOR(0x848484);
    [addressCell addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    // 电话
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = [UIFont systemFontOfSize:12.f];
    phoneLabel.textColor = HEX_COLOR(0x848484);
    [addressCell addSubview:phoneLabel];
    _phoneLabel = phoneLabel;
    
    UIView *addressContainer = [[UIView alloc] init];
    addressContainer.userInteractionEnabled = NO;
    [addressCell addSubview:addressContainer];
    _addressContainer = addressContainer;
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.numberOfLines = 2;
    addressLabel.font = [UIFont systemFontOfSize:12.f];
    addressLabel.textColor = HEX_COLOR(0x848484);
    [addressContainer addSubview:addressLabel];
    [addressLabel setPreferredMaxLayoutWidth:SCREEN_WIDTH - 50];
    _addressLabel = addressLabel;
    
    // 右箭头
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_cell_next"]];
    [addressCell addSubview:arrowImage];
    _arrowImage = arrowImage;
}

#pragma mark - public
- (void)addTarget:(id)target action:(SEL)action
{
    [_addressCell addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setItem:(NBAddressModel *)item
{
    _item = item;
    if (item == nil) {
        _addAddressLabel.hidden = NO;
    }else
    {
        _addAddressLabel.hidden = YES;
    }
    
    // 设置名字
    _nameLabel.text = item.name;
    // 设置电话号码
    _phoneLabel.text = item.phone;
    // 设置标题
    _addressLabel.text = item.address;
}

- (void)setTableCode:(NSString *)tableCode
{
    self.userInteractionEnabled = NO;
    _addAddressLabel.hidden = NO;
    _arrowImage.hidden = YES;
    _addAddressLabel.text = [NSString stringWithFormat:@"桌位号:%@",tableCode];
    

}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.addressCell autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.addressCell autoSetDimension:ALDimensionHeight toSize:60.0 relation:NSLayoutRelationGreaterThanOrEqual];
//        [self.addressCell autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.addressLabel withOffset:8 relation:NSLayoutRelationGreaterThanOrEqual];
        [self.addressContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.addressContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.phoneLabel];
        
        [self.topImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        [self.addAddressLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.addAddressLabel.superview withOffset:5.f];
        [self.addAddressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
        
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14.f];
        [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topImageView withOffset:8.f];
        [self.nameLabel autoSetDimension:ALDimensionWidth toSize:150.0 relation:NSLayoutRelationLessThanOrEqual];

        [self.phoneLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        [self.phoneLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:7.f];
        
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14.f];
        [self.addressLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.addressContainer withOffset:-2.0];
        
        [self.arrowImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [self.arrowImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.f];

        
        self.didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

@end
