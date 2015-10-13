//
//  CSDishOrderDishesView.m
//  CloudSong
//
//  Created by sen on 15/7/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSDishOrderDishesView.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSDishModel.h"
@interface CSDishOrderDishesView ()
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UIView *titleView;
@property(nonatomic, weak) UILabel *productTitleLabel;
@property(nonatomic, weak) UILabel *countAndUnitTitleLabel;
@property(nonatomic, weak) UILabel *priceTitleLabel;
@end

@implementation CSDishOrderDishesView



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
#pragma mark - Setup
- (void)setupSubviews
{
    UIView *titleView = [[UIView alloc] init];
    [self addSubview:titleView];
    _titleView = titleView;
    
    UILabel *productTitleLabel = [[UILabel alloc] init];
    productTitleLabel.text = @"物品";
    productTitleLabel.font = [UIFont systemFontOfSize:10.0];
    productTitleLabel.textColor = HEX_COLOR(0xb4a34e);
    [titleView addSubview:productTitleLabel];
    _productTitleLabel = productTitleLabel;
    
    UILabel *countAndUnitTitleLabel = [[UILabel alloc] init];
    countAndUnitTitleLabel.text = @"数量/单价";
    countAndUnitTitleLabel.font = [UIFont systemFontOfSize:10.0];
    countAndUnitTitleLabel.textColor = HEX_COLOR(0xb4a34e);
    [titleView addSubview:countAndUnitTitleLabel];
    _countAndUnitTitleLabel = countAndUnitTitleLabel;
    
    UILabel *priceTitleLabel = [[UILabel alloc] init];
    priceTitleLabel.text = @"金额";
    priceTitleLabel.font = [UIFont systemFontOfSize:10.0];
    priceTitleLabel.textColor = HEX_COLOR(0xb4a34e);
    [titleView addSubview:priceTitleLabel];
    _priceTitleLabel = priceTitleLabel;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_titleView.superview);
//            make.bottom.equalTo(_titleView.superview);
        }];
        
        [_productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_productTitleLabel.superview).offset(TRANSFER_SIZE(35.0));
            make.top.bottom.equalTo(_priceTitleLabel.superview);
        }];
        
        [_countAndUnitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_priceTitleLabel.mas_left).offset(-TRANSFER_SIZE(40.0));
            make.top.bottom.equalTo(_countAndUnitTitleLabel.superview);
        }];
        
        [_priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_priceTitleLabel.superview).offset(-TRANSFER_SIZE(15.0));
            make.top.bottom.equalTo(_priceTitleLabel.superview);
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setDishes:(NSArray *)dishes
{
    _dishes = dishes;

    
    NSMutableArray *dishCells = [NSMutableArray arrayWithCapacity:dishes.count];
    for (int i = 0; i < dishes.count; i++) {
        CSDishModel *dish = dishes[i];
        UIView *dishCell = [[UIView alloc] init];
        
        [self addSubview:dishCell];
        [dishCells addObject:dishCell];
        
        [dishCell mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(_titleView.mas_bottom).offset(TRANSFER_SIZE(16.0));
            }else
            {
                make.top.equalTo([dishCells[i-1] mas_bottom]).offset(TRANSFER_SIZE(16.0));
            }
            
            if (i == dishes.count - 1) {
                make.bottom.equalTo(dishCell.superview);
            }
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12.0];
        nameLabel.textColor = HEX_COLOR(0xe5dade);
        nameLabel.text = dish.name;
        nameLabel.numberOfLines = 0;
        
        [dishCell addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_productTitleLabel);
            make.left.top.bottom.equalTo(nameLabel.superview);
            make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(85.0));
        }];
        
        UILabel *amountAndUnitLabel = [[UILabel alloc] init];
        amountAndUnitLabel.font = [UIFont systemFontOfSize:12.0];
        amountAndUnitLabel.textColor = HEX_COLOR(0xe5dade);
        amountAndUnitLabel.text = [NSString stringWithFormat:@"%ld/%.2f",dish.amount,dish.price];
        amountAndUnitLabel.numberOfLines = 1;
        
        [dishCell addSubview:amountAndUnitLabel];
        [amountAndUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_countAndUnitTitleLabel);
            make.top.equalTo(amountAndUnitLabel.superview);
        }];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = [UIFont systemFontOfSize:12.0];
        priceLabel.textColor = HEX_COLOR(0xeeff62);
        priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:dish.amount * dish.price]];
        priceLabel.numberOfLines = 1;
        
        [dishCell addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_countAndUnitTitleLabel);
            make.top.right.equalTo(priceLabel.superview);
            make.centerX.equalTo(_priceTitleLabel);
        }];
        
   
        
        
        

        
    }
}

@end
