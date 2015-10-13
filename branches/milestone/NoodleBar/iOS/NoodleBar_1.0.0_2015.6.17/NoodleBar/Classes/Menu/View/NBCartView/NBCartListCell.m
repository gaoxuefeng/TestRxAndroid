//
//  NBCartListCell.m
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCartListCell.h"
#import "NBCommon.h"
#import "NBCountSelector.h"
#import "NBCartTool.h"
@interface NBCartListCell ()<NBCountSelectorDelegate>
/**
 *  分割线
 */
@property(nonatomic, weak) UIView *divider;

@property(nonatomic, strong) NBCountSelector *countSelector;

@property(nonatomic, weak) UILabel *priceLabel;

@property(nonatomic, weak) UILabel *titleLabel;


@end

@implementation NBCartListCell





+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cartListCell";
    NBCartListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBCartListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.autoresizesSubviews = NO;
//        self.contentView.autoresizesSubviews = NO;
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews
{
    CGFloat dividerMargin = 10.f;
    // 分割线
    UIView *divider = [UIView newAutoLayoutView];
    divider.backgroundColor = HEX_COLOR(0xd8d8d8);
    [self.contentView addSubview:divider];
    _divider = divider;
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, dividerMargin, 0, dividerMargin) excludingEdge:ALEdgeTop];
    
    

    // 标题
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor = HEX_COLOR(0x444444);

    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:dividerMargin];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.titleLabel autoSetDimension:ALDimensionWidth toSize:AUTOLENGTH(150)];
//    titleLabel.numberOfLines = 1;
//    [titleLabel setPreferredMaxLayoutWidth:AUTOLENGTH(150)];
    
    
    // 价格
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    priceLabel.font = [UIFont systemFontOfSize:13.f];
    priceLabel.textColor = HEX_COLOR(0xec681a);
    [priceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [priceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:120.f];
    
    // 选择器
    _countSelector = [NBCountSelector newAutoLayoutView];
    _countSelector.delegate = self;
    [self.contentView addSubview:_countSelector];
    [_countSelector autoSetDimensionsToSize:CGSizeMake(76.f, 25.f)];
    [_countSelector autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_countSelector autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:dividerMargin];
}

#pragma mark - public
- (void)hiddenBottomDivider:(BOOL)hidden
{
    _divider.hidden = hidden;
}
- (void)setItem:(NBDishModel *)item
{
    _item = item;
    // 菜名
    self.titleLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:item.price]];
    _countSelector.amount = item.amount;
}

#pragma mark - NBCountSelectorDelegate
- (void)countSelector:(NBCountSelector *)countSelector DidClickBtnToChangeCount:(int)count
{
    _item.amount = count;
    [NBCartTool alterDish:_item];
    
    // 发出通知  告知购物车操作,刷新列表
    [[NSNotificationCenter defaultCenter] postNotificationName:CART_VIEW_OPERATE object:nil];
    
}

@end
