//
//  CSCartDishTableViewCell.m
//  CloudSong
//
//  Created by sen on 5/26/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCartDishTableViewCell.h"
#import "CSDefine.h"
#import "CSAmountSelector.h"
#import <Masonry.h>
#import "CSDishCartTool.h"
@interface CSCartDishTableViewCell ()<CSAmountSelectorDelegate>
/** 菜品 */
@property(nonatomic, weak) UILabel *titleLabel;
/** 价格 */
@property(nonatomic, weak) UILabel *priceLabel;
/** 数量选择器 */
@property(nonatomic, weak) CSAmountSelector *amountSelector;
/** 下分割线 */
@property(nonatomic, weak) UIView *bottomDivider;

@property(nonatomic, assign) BOOL didUpdateConstraint;

@end


@implementation CSCartDishTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier =  @"cartDish";
    CSCartDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSCartDishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEX_COLOR(0x1d1c21);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    titleLabel.textColor = HEX_COLOR(0xb5b7bf);
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    priceLabel.textColor = HEX_COLOR(0x993587);
    _priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    // 数量
    CSAmountSelector *amountSelector = [[CSAmountSelector alloc] init];
    amountSelector.delegate = self;
    _amountSelector = amountSelector;
    [self.contentView addSubview:amountSelector];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] init];
    bottomDivider.backgroundColor = HEX_COLOR(0x19181c);
    _bottomDivider = bottomDivider;
    [self.contentView addSubview:bottomDivider];
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(TRANSFER_SIZE(14.0));
            make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(150.0));
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.amountSelector.mas_left).offset(-TRANSFER_SIZE(16.0));
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.amountSelector mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-TRANSFER_SIZE(15.0));
        }];
        
        [self.bottomDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo( 2 / [UIScreen mainScreen].scale);
        }];
        
        self.didUpdateConstraint = YES;
    }
    
    [super updateConstraints];

}


#pragma mark - CSAmountSelectorDelegate
- (void)amountSelector:(CSAmountSelector *)amountSelector amountDidChange:(NSInteger)amount
{
    _item.amount = amount;
    [CSDishCartTool alterDish:_item];
}

#pragma mark - Public Methods
- (void)setItem:(CSDishModel *)item
{
    _item = item;
    self.titleLabel.text =_item.name;
    self.priceLabel.text = [NSString stringWithFloat:_item.price];
    self.amountSelector.amount = _item.amount;
    [self updateConstraintsIfNeeded];
}
@end
