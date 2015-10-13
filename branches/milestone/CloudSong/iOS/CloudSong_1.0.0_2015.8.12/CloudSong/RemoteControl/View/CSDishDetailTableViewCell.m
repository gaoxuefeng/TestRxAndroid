//
//  CSDishDetailTableViewCell.m
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDishDetailTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "CSDefine.h"
#import <Masonry.h>
#import "CSAmountSelector.h"
#import "CSDishCartTool.h"
@interface CSDishDetailTableViewCell ()<CSAmountSelectorDelegate>
/** 图片 */
@property(nonatomic, weak) UIImageView *picView;
/** 标题 */
@property(nonatomic, weak) UILabel *titleLabel;
/** 价格 */
@property(nonatomic, weak) UILabel *priceLabel;
/** 数量选择 */
@property(nonatomic, weak) CSAmountSelector *amountSelector;
/** 下分割线 */
@property(nonatomic, weak) UIView *bottomDivider;

@property(nonatomic, assign) BOOL didUpdateConstraint;

@end

@implementation CSDishDetailTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier =  @"DishDetail";
    CSDishDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CSDishDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 图片
    UIImageView *picView = [[UIImageView alloc] init];
    picView.layer.cornerRadius = 2.0;
    picView.layer.masksToBounds = YES;
    _picView = picView;
    [self.contentView addSubview:picView];
    
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
    bottomDivider.backgroundColor = [UIColor blackColor];
    bottomDivider.alpha = 0.3;
    _bottomDivider = bottomDivider;
    [self.contentView addSubview:bottomDivider];
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {

        
        
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(TRANSFER_SIZE(13.0));
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(91.0), TRANSFER_SIZE(60.0)));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(TRANSFER_SIZE(16.0));
            make.left.equalTo(self.picView.mas_right).offset(TRANSFER_SIZE(11.0));
            make.right.lessThanOrEqualTo(self.contentView.mas_right);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(TRANSFER_SIZE(12.0));
            make.left.equalTo(self.picView.mas_right).offset(TRANSFER_SIZE(11.0));
            make.right.lessThanOrEqualTo(self.amountSelector.mas_left);
        }];
        
        [self.amountSelector mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-TRANSFER_SIZE(15.0));
            make.bottom.equalTo(self.contentView).offset(-TRANSFER_SIZE(15.0));
        }];
        
        [self.bottomDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(2 / [UIScreen mainScreen].scale);
            make.left.mas_equalTo(TRANSFER_SIZE(13.0));
        }];
        
        self.didUpdateConstraint = YES;
    }
    [super updateConstraints];
}
#pragma mark - Public Methods
- (void)setItem:(CSDishModel *)item
{
    _item = item;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:_item.imgUrl] placeholderImage:[UIImage imageNamed:@"wine_default_img"]];
    self.titleLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:item.price]];
    self.amountSelector.amount = item.amount;
    [self updateConstraintsIfNeeded];
}





#pragma mark - CSAmountSelectorDelegate
- (void)amountSelector:(CSAmountSelector *)amountSelector amountDidChange:(NSInteger)amount
{
    _item.amount = amount;
    // 修改购物车
    [CSDishCartTool alterDish:_item]; 
    
}
@end
