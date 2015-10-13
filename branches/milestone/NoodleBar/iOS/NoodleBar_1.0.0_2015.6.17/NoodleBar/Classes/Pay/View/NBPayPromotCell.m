//
//  NBPayPromotCell.m
//  NoodleBar
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBPayPromotCell.h"
#import "NBCommon.h"
@interface NBPayPromotCell ()
{
    UIImageView *_picView;              // 优惠图标
    UILabel *_promotLabel;              // 优惠类型
    UILabel *_discountPriceLabel;       // 优惠价格
    BOOL _didSetupConstraint;
}

@end

@implementation NBPayPromotCell
#pragma mark - Public Methods
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"promotCell";
    NBPayPromotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBPayPromotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setItem:(NBMerchantPromotModel *)item
{
    _item = item;
    switch (_item.promottype) {
        case NBPromotTypeReduce:
            _promotLabel.text = [NSString stringWithFormat:@"满%@减%@",_item.enoughmoney,_item.discountmoney];
            break;
        default:
            break;
    }
    _discountPriceLabel.text = [NSString stringWithFormat:@"-￥%@",_item.discountmoney];
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.opaque = YES;
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews
{
    _picView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"merchant_list_reduce"]];
    [self.contentView addSubview:_picView];
    
    _promotLabel = [[UILabel alloc] initForAutoLayout];
    _promotLabel.font = [UIFont systemFontOfSize:15.0];
    
    _promotLabel.textColor = HEX_COLOR(0x565656);
    [self.contentView addSubview:_promotLabel];
    
    
    _discountPriceLabel = [[UILabel alloc] initForAutoLayout];
    _discountPriceLabel.font = [UIFont systemFontOfSize:12.0];
    _discountPriceLabel.textColor = HEX_COLOR(0x565656);
    [self.contentView addSubview:_discountPriceLabel];

    [self updateConstraints];
                
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_picView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_picView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
        
        [_promotLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_promotLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_picView withOffset:10.0];
        
        
        [_discountPriceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_discountPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16.0];
        
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}
@end
