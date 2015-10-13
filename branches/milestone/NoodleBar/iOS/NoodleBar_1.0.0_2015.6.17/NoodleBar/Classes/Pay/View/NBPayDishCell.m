//
//  NBPayDishCell.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayDishCell.h"
#import "NBCommon.h"

#define H_MARGIN 15.f

@interface NBPayDishCell()
/**
 *  数量Label
 */
@property(nonatomic, weak) UILabel *amountLabel;
/**
 *  价格Label
 */
@property(nonatomic, weak) UILabel *priceLabel;

@end

@implementation NBPayDishCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"payDishCell";
    NBPayDishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBPayDishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
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
    // 菜名
    self.textLabel.font = [UIFont systemFontOfSize:13.f];
    self.textLabel.textColor = HEX_COLOR(0x969696);
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    [self.textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.textLabel autoSetDimension:ALDimensionWidth toSize:AUTOLENGTH(180)];
    
    
    // 数量
    UILabel *amountLabel = [[UILabel alloc] initForAutoLayout];
    amountLabel.font = [UIFont systemFontOfSize:13.f];
    amountLabel.textColor = HEX_COLOR(0x969696);
    [self.contentView addSubview:amountLabel];
    _amountLabel = amountLabel;
    [amountLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [amountLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:AUTOLENGTH(100.f)];
    // 总价
    UILabel *priceLabel = [[UILabel alloc] initForAutoLayout];
    priceLabel.font = [UIFont systemFontOfSize:13.f];
    priceLabel.textColor = HEX_COLOR(0x969696);
    [self.contentView addSubview:priceLabel];
    _priceLabel = priceLabel;
    [priceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [priceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:H_MARGIN];
    
    UIView *divider = [[UIView alloc] initForAutoLayout];
    [self.contentView addSubview:divider];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
}

- (void)setItem:(NBDishModel *)item
{
    _item = item;
    self.textLabel.text = item.name;
    _amountLabel.text = [NSString stringWithFormat:@"%d",item.amount];
    
    if (item.unitprice > 0) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:item.amount * item.unitprice]];
    }else
    {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:item.amount * item.price]];
    }
    
}


@end
