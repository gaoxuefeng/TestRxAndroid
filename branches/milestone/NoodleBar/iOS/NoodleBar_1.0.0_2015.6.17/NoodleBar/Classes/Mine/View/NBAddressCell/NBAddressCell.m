//
//  NBAddressCell.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAddressCell.h"
#import "NBCommon.h"
@interface NBAddressCell()
/**
 *  姓名
 */
@property(nonatomic, weak) UILabel *nameLabel;
/**
 *  电话
 */
@property(nonatomic, weak) UILabel *phoneLabel;
/**
 *  地址
 */
@property(nonatomic, weak) UILabel *addressLabel;

@property(nonatomic, weak) UIView *addressView;
/**
 *  选中图标
 */
@property(nonatomic, weak) UIImageView *selectedIcon;

@property(nonatomic, assign) BOOL didSetupConstraint;

@property(nonatomic, weak) UIView *divider;

@property(nonatomic, weak) UILabel *genderLabel;

@end

@implementation NBAddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"addressCell";
    NBAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBAddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 姓名
    
    UILabel *nameLabel = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    nameLabel.numberOfLines = 1;
    _nameLabel = nameLabel;
    
    // 性别
    UILabel *genderLabel = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:genderLabel];
    genderLabel.font = [UIFont systemFontOfSize:14.f];
    genderLabel.numberOfLines = 1;
    _genderLabel = genderLabel;
    
    // 电话
    UILabel *phoneLabel = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:phoneLabel];
    phoneLabel.font = [UIFont systemFontOfSize:14.f];
    _phoneLabel = phoneLabel;
    
    UIView *addressView = [[UIView alloc] init];
    _addressView = addressView;
    [self.contentView addSubview:addressView];
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc] initForAutoLayout];
    addressLabel.font = [UIFont systemFontOfSize:11.f];
    addressLabel.numberOfLines = 2;
    [addressView addSubview:addressLabel];
    _addressLabel = addressLabel;
    
    // 选中钩
    UIImageView *selectedIcon = [[UIImageView alloc] initForAutoLayout];
    [self.contentView addSubview:selectedIcon];
    selectedIcon.image = [UIImage imageNamed:@"mine_address_selected_icon"];
    selectedIcon.hidden = YES;
    _selectedIcon = selectedIcon;
    
    // 分割线
    UIView *divider = [[UIView alloc] initForAutoLayout];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self.contentView addSubview:divider];
    _divider = divider;
}


- (void)setItem:(NBAddressModel *)item
{
    _item = item;
    if (item.selected) { // 被选中
        _selectedIcon.hidden = NO;
        _nameLabel.textColor = HEX_COLOR(0x848484);
        _phoneLabel.textColor = HEX_COLOR(0x848484);
        _addressLabel.textColor = HEX_COLOR(0xb1b1b1);
        _genderLabel.textColor = HEX_COLOR(0x848484);
        
    }else
    {
        _selectedIcon.hidden = YES;
        _nameLabel.textColor = HEX_COLOR(0x464646);
        _phoneLabel.textColor = HEX_COLOR(0x464646);
        _addressLabel.textColor = HEX_COLOR(0x8a8a8a);
        _genderLabel.textColor = HEX_COLOR(0x464646);
    }
    // 姓名
    _nameLabel.text = [NSString stringWithFormat:@"%@",item.name];
    _genderLabel.text = [NSString stringWithFormat:@"%@",item.gender?@"女士":@"先生"];
    
    // 电话
    _phoneLabel.text = item.phone;
    
    // 地址
    _addressLabel.text = item.address;
    
    [self updateConstraintsIfNeeded];
    
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        CGFloat margin = 14.f;
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.5f];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
        [self.nameLabel autoSetDimension:ALDimensionWidth toSize:AUTOLENGTH(145.0) relation:NSLayoutRelationLessThanOrEqual];

        
        [self.genderLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        [self.genderLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel];
        
        [self.phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:42.f];
        [self.phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.5f];
        
        [self.addressView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.addressView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.phoneLabel];
        
        [self.addressLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.phoneLabel];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
        [self.addressLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.addressView withOffset:-2.0];
        
        [self.selectedIcon autoSetDimensionsToSize:self.selectedIcon.image.size];
        [self.selectedIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.selectedIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:11.f];
        
        [self.divider autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 0.5f)];
        [self.divider autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.divider autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.nameLabel setPreferredMaxLayoutWidth:150];
}
@end
