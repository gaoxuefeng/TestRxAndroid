//
//  CSOrderDishPayDishCell.m
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderDishPayDishCell.h"
#import <UIImageView+WebCache.h>
#import "CSDefine.h"
#import <Masonry.h>
@interface CSOrderDishPayDishCell ()
@property(nonatomic, strong) CSDishModel *item;
@property(nonatomic, weak) UIView *topDivider;
@property(nonatomic, weak) UIImageView *picView;
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UILabel *amountLabel;
@property(nonatomic, weak) UILabel *priceLabel;
@property(nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation CSOrderDishPayDishCell

- (instancetype)initWithItem:(CSDishModel *)item
{
    _item = item;
    self = [super init];
    if (self) {
        [self setupSubView];
        self.backgroundColor = WhiteColor_Alpha_4;
    }
    return self;
}

- (void)setupSubView
{
    // 分割线
    UIView *topDivider = [[UIView alloc] init];
    _topDivider = topDivider;
    topDivider.backgroundColor = WhiteColor_Alpha_6;
    [self addSubview:topDivider];
    
    // 图片
    UIImageView *picView = [[UIImageView alloc] init];
    _picView = picView;
    [self addSubview:picView];
    [picView sd_setImageWithURL:[NSURL URLWithString:_item.imgUrl] placeholderImage:[UIImage imageNamed:@"wine_default_img"]];
    
    // 标题
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = HEX_COLOR(0xffffff);
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _nameLabel = nameLabel;
    nameLabel.text = _item.name;
    [self addSubview:nameLabel];
    // 数量
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    amountLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    _amountLabel = amountLabel;
    amountLabel.text = [NSString stringWithFormat:@"x%ld",_item.amount];
    [self addSubview:amountLabel];
    // 单价
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = HEX_COLOR(0xd23a90);
    priceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    _priceLabel = priceLabel;
    priceLabel.text = [NSString stringWithFormat:@"￥ %@",[NSString stringWithFloat:_item.price]];
    [self addSubview:priceLabel];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        CGFloat padding = TRANSFER_SIZE(16.0);
        
        
        [self.topDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(2 / [UIScreen mainScreen].scale);
        }];
        
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(1 / [UIScreen mainScreen].scale);
            make.left.equalTo(self).offset(padding);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(76.0), TRANSFER_SIZE(50.0)));
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(TRANSFER_SIZE(15.0));
            make.left.equalTo(self.picView.mas_right).offset(TRANSFER_SIZE(10.0));
        }];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(TRANSFER_SIZE(15.0));
            make.left.equalTo(self.picView.mas_right).offset(TRANSFER_SIZE(10.0));
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(1 / [UIScreen mainScreen].scale);
            make.right.equalTo(self).offset(-TRANSFER_SIZE(19.0));
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}



@end
