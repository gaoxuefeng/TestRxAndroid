//
//  NBMenuCategoryDetailCell.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMenuCategoryDetailCell.h"
#import "NBCommon.h"
#import "NBCountSelector.h"
#import "NBCartTool.h"
#import <UIImageView+WebCache.h>
#define MARGIN_V 5.f
#define IMAGE_WIDTH 88.f
#define IMAGE_HEIGHT 67.f

@interface NBMenuCategoryDetailCell() <NBCountSelectorDelegate>
/**
* 已售图标
*/
@property(nonatomic, strong) UIImageView *soldImageView;
/**
 *  已售数量
 */
@property(nonatomic, strong) UILabel *soldAmount;
/**
 *  价格
 */
@property(nonatomic, strong) UILabel *priceLabel;
/**
 *  分割线
 */
@property(nonatomic, strong) UIView *divider;
/**
 *  数量选择器
 */
@property(nonatomic, strong) NBCountSelector *countSelector;
/**
 *  imageView的原始frame
 */
@property(nonatomic, assign) CGRect originRect;
/**
 *  imageView在windows上的Rect
 */
@property(nonatomic, assign) CGRect startRect;
/**
 *  遮板
 */
@property(nonatomic, strong) UIButton *cover;



@end

@implementation NBMenuCategoryDetailCell

#pragma mark - lazyLoad

- (UIButton *)cover
{
    if (!_cover) {
        UIButton *cover = [[UIButton alloc] initWithFrame:SCREEN_BOUNDS];
        cover.backgroundColor = [UIColor blackColor];
        [cover addTarget:self action:@selector(coverOnClick:) forControlEvents:UIControlEventTouchUpInside];
        cover.alpha = 0.f;
        _cover = cover;
    }
    return _cover;
}

- (UILabel *)soldAmount
{
    if (!_soldAmount) {
        _soldAmount = [[UILabel alloc] init];
        _soldAmount.font = [UIFont systemFontOfSize:10.f];
        _soldAmount.textColor = HEX_COLOR(0x9fa0a0);
        [self addSubview:_soldAmount];
    }
    return _soldAmount;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = HEX_COLOR(0xe94619);
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"categoryDetailCell";
    NBMenuCategoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBMenuCategoryDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.opaque = YES;
        self.autoresizesSubviews = NO;
        self.contentView.autoresizesSubviews = NO;
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews
{
    // 标题字体
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.numberOfLines = 1;
    
    // 图片
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewOnClick:)];
    [self.imageView addGestureRecognizer:tap];
    
    // 已售图片
    _soldImageView = [[UIImageView alloc] init];
    _soldImageView.image = [UIImage imageNamed:@"menu_sold_tag"];
    [self addSubview:_soldImageView];
    
    // 分割线
    _divider = [[UIView alloc] init];
    _divider.backgroundColor = HEX_COLOR(0xe7e7e8);
    [self addSubview:_divider];
    
    
    // 选择器
    _countSelector = [[NBCountSelector alloc] init];
    _countSelector.delegate = self;
    [self addSubview:_countSelector];
}

#pragma mark - NBCountSelectorDelegate
- (void)countSelector:(NBCountSelector *)countSelector DidClickBtnToChangeCount:(int)count
{
    _item.amount = count;
    [NBCartTool alterDish:_item];
}

- (void)setItem:(NBDishModel *)item
{
    _item = item;
    self.textLabel.text = item.name;
    self.soldAmount.text = [NSString stringWithFormat:@"%d份",item.soldAmount];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:item.price]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.urismall]
                      placeholderImage:[UIImage imageNamed:@"order_placeholder"]];
    _countSelector.amount = item.amount;

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 图片
    CGFloat imageViewW = IMAGE_WIDTH;
    CGFloat imageViewH = IMAGE_HEIGHT;
    CGFloat imageViewX = MARGIN_V;
    CGFloat imageViewY = (self.height - imageViewH) * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    // 标题
    CGSize textSize = [NSString sizeWithString:self.textLabel.text font:self.textLabel.font maxSize:CGSizeMake(self.width - MARGIN_V * 2 - imageViewW, 16.702)];

    CGFloat textLabelX = CGRectGetMaxX(self.imageView.frame) + 5;
    CGFloat textLabelY = imageViewY;
    CGFloat textLabelW = textSize.width;
    CGFloat textLabelH = textSize.height;
    self.textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    
    // 已售图
    CGFloat soldImageViewX = textLabelX;
    CGFloat soldImageViewY = CGRectGetMaxY(self.textLabel.frame) + 5;
    CGFloat soldImageViewW = _soldImageView.image.size.width;
    CGFloat soldImageViewH = _soldImageView.image.size.height;
    _soldImageView.frame = CGRectMake(soldImageViewX, soldImageViewY, soldImageViewW, soldImageViewH);
    
    // 已售数量
    CGSize soldAmountSize = [NSString sizeWithString:self.soldAmount.text font:self.soldAmount.font maxSize:MAXSIZE];
    CGFloat soldAmountW = soldAmountSize.width;
    CGFloat soldAmountH = soldAmountSize.height;
    CGFloat soldAmountX = CGRectGetMaxX(_soldImageView.frame) + 5;
    CGFloat soldAmountY = soldImageViewY + (soldImageViewH - soldAmountH) * 0.5;
    self.soldAmount.frame = CGRectMake(soldAmountX, soldAmountY, soldAmountW, soldAmountH);
    
    // 分割线
    CGFloat dividerW = self.width - 2 * MARGIN_V;
    CGFloat dividerH = 1;
    CGFloat dividerX = MARGIN_V;
    CGFloat dividerY = self.height - dividerH;
    _divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    // 价格
    CGSize priceLabelSize = [NSString sizeWithString:self.priceLabel.text font:self.priceLabel.font maxSize:MAXSIZE];
    CGFloat priceLabelW = priceLabelSize.width;
    CGFloat priceLabelH = priceLabelSize.height;
    CGFloat priceLabelX = soldImageViewX;
    CGFloat priceLabelY = CGRectGetMidY(self.imageView.frame) + priceLabelH;
    _priceLabel.frame = CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    
    // 选择器
    CGFloat countSelectW = 100.f;
    CGFloat countSelectH = 39.f;
    CGFloat countSelectX = self.width - countSelectW;
    CGFloat countSelectY = self.height - countSelectH;
    _countSelector.frame = CGRectMake(countSelectX, countSelectY, countSelectW, countSelectH);
}

#pragma mark - private
- (void)imageViewOnClick:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // 活动主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 增加遮板
    [window addSubview:self.cover];
    
    // 关闭图片的用户交互
    self.imageView.userInteractionEnabled = NO;
    // 记录图片在cell上的原始frame
    _originRect = self.imageView.frame;
    
    // 转换坐标系 图片在cell上的CGRect->图片在window上的CGRect
    _startRect = [window convertRect:self.imageView.frame fromView:self.imageView.superview];
    
    
    self.imageView.frame = _startRect;
    // 将图片添加到窗口上
    [window addSubview:self.imageView];

    
    CGSize tmpSize = CGSizeMake(SCREEN_WIDTH, _originRect.size.height * SCREEN_WIDTH / _originRect.size.width);
    
    
    [UIView animateWithDuration:.3f animations:^{
        // 图片尺寸到全局
        
        // 图片中心对称
//        self.imageView.center = CGPointMake(window.width * 0.5,window.height * 0.5);
        self.imageView.frame = CGRectMake(0, window.height * 0.5 - _originRect.size.height * SCREEN_WIDTH / _originRect.size.width * 0.5, tmpSize.width, tmpSize.height);
        self.cover.alpha = .5f;
    } completion:^(BOOL finished) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_item.uriraw] placeholderImage:self.imageView.image];
    }];
}

- (void)coverOnClick:(UIButton *)button
{
    
    [UIView animateWithDuration:.3f animations:^{
        self.imageView.frame = _startRect;
        button.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_item.urismall] placeholderImage:self.imageView.image];
        self.imageView.frame = _originRect;
        [self.contentView addSubview:self.imageView];
        [button removeFromSuperview];
        self.imageView.userInteractionEnabled = YES;
    }];

}
@end
