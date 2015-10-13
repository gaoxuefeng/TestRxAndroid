//
//  NBMerchantTableViewCell.m
//  NoodleBar
//
//  Created by sen on 6/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBMerchantTableViewCell.h"
#import "CWStarRateView.h"
#import "NBMerchantPromotView.h"
#import "NBCommon.h"
#import <UIImageView+WebCache.h>
@interface NBMerchantTableViewCell ()
/** 图片 */
@property(nonatomic, weak) UIImageView *picView;
/** 标题 */
@property(nonatomic, weak) UILabel *titleLabel;
/** 价格 */
@property(nonatomic, weak) UILabel *priceLabel;
/** 月销量 */
@property(nonatomic, weak) UILabel *monthSoldLabel;
/** 下分割线 */
@property(nonatomic, weak) UIView *bottomDivider;
/** 起送价 */
@property(nonatomic, weak) UILabel *startPriceLabel;
/** 运费 */
@property(nonatomic, weak) UILabel *freightLabel;
/** 平均送达时间 */
@property(nonatomic, weak) UILabel *timeLabel;
/** 左竖线 */
@property(nonatomic, weak) UIView *leftVLine;
/** 右竖线 */
@property(nonatomic, weak) UIView *rightVLine;

@property(nonatomic, weak) CWStarRateView *rateView;

@property(nonatomic, weak) NBMerchantPromotView *promotView;

//@property(nonatomic, assign) BOOL didUpdateConstraint;

@end

@implementation NBMerchantTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"categoryDetailCell";
    NBMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBMerchantTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews
{
    // 图片
    UIImageView *picView = [[UIImageView alloc] init];
    _picView = picView;
    [self.contentView addSubview:picView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = HEX_COLOR(0x363636);
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    // 评星
    CWStarRateView *rateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 77.0, 13.0) numberOfStars:5];
    rateView.userInteractionEnabled = NO;
    rateView.hasAnimation = NO;
    rateView.allowIncompleteStar = YES;
    _rateView = rateView;
    [self.contentView addSubview:rateView];
    
    // 月销量
    UILabel *monthSoldLabel = [[UILabel alloc] init];
    monthSoldLabel.font = [UIFont systemFontOfSize:11.0];
    monthSoldLabel.textColor = HEX_COLOR(0x999999);
    _monthSoldLabel = monthSoldLabel;
    [self.contentView addSubview:monthSoldLabel];
    
    // 起送价
    UILabel *startPriceLabel = [[UILabel alloc] init];
    startPriceLabel.font = [UIFont systemFontOfSize:12.0];
    startPriceLabel.textColor = HEX_COLOR(0x999999);
    _startPriceLabel = startPriceLabel;
    [self.contentView addSubview:startPriceLabel];
    
    // 运费
    UILabel *freightLabel = [[UILabel alloc] init];
    freightLabel.font = [UIFont systemFontOfSize:12.0];
    freightLabel.textColor = HEX_COLOR(0x999999);
    _freightLabel = freightLabel;
    [self.contentView addSubview:freightLabel];
    
    // 耗时
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12.0];
    timeLabel.textColor = HEX_COLOR(0x999999);
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:14.0];
    priceLabel.textColor = HEX_COLOR(0x993587);
    _priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] init];
    bottomDivider.backgroundColor = HEX_COLOR(0xeaeaea);
    _bottomDivider = bottomDivider;
    [self.contentView addSubview:bottomDivider];
    
    UIView *leftVLine = [[UIView alloc] init];
    _leftVLine = leftVLine;
    leftVLine.backgroundColor = HEX_COLOR(0xd7d7d7);
    [self.contentView addSubview:leftVLine];
    
    UIView *rightVLine = [[UIView alloc] init];
    _rightVLine = rightVLine;
    rightVLine.backgroundColor = HEX_COLOR(0xd7d7d7);
    [self.contentView addSubview: rightVLine];
    
    // 优惠
    NBMerchantPromotView  *promotView = [[NBMerchantPromotView alloc] init];
    [self.contentView addSubview:promotView];
    _promotView = promotView;
}

- (void)setItem:(NBMerchantModel *)item
{
    _item = item;

    [self.picView sd_setImageWithURL:[NSURL URLWithString:_item.pictureuri] placeholderImage:[UIImage imageNamed:@"merchant_list_icon_placeholder"]];
    self.titleLabel.text = _item.name;
    self.monthSoldLabel.text = [NSString stringWithFormat:@"月售: %@单",_item.monthordernum];
    self.startPriceLabel.text = [NSString stringWithFormat:@"起送价￥%@",_item.startprice];
    self.freightLabel.text = [NSString stringWithFormat:@"配送费￥%@",_item.packingfee];
    self.timeLabel.text = [NSString stringWithFormat:@"%@分钟送达",_item.deliverytime];
    self.rateView.scorePercent = _item.level.floatValue / 5.0;
    self.promotView.items = _item.promots;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 10.0;
    // 图片
    CGFloat picViewW = 60.0;
    CGFloat picViewH = picViewW;
    CGFloat picViewX = padding;
    CGFloat picViewY = 16.0;
    self.picView.frame = CGRectMake(picViewX, picViewY, picViewW, picViewH);
    
    
    // 标题
    CGSize titleSize = [NSString sizeWithString:_titleLabel.text font:_titleLabel.font maxSize:MAXSIZE];
    CGFloat titleLabelW = titleSize.width;
    CGFloat titleLabelH = titleSize.height;
    CGFloat titleLabelX = CGRectGetMaxX(self.picView.frame) + 10.0;
    CGFloat titleLabelY = picViewY;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    // 评分
    self.rateView.x  = titleLabelX;
    self.rateView.y = CGRectGetMaxY(self.titleLabel.frame) + 10.0;
    
    // 月销量
    CGSize monthSoldSize = [NSString sizeWithString:_monthSoldLabel.text font:_monthSoldLabel.font maxSize:MAXSIZE];
    CGFloat monthSoldLabelW = monthSoldSize.width;
    CGFloat monthSoldLabelH = monthSoldSize.height;
    CGFloat monthSoldLabelX = CGRectGetMaxX(self.rateView.frame) + 10.0;
    CGFloat monthSoldLabelY = self.rateView.y;
    self.monthSoldLabel.frame = CGRectMake(monthSoldLabelX, monthSoldLabelY, monthSoldLabelW, monthSoldLabelH);
    
    // 起送价
    CGSize startPriceSize = [NSString sizeWithString:_startPriceLabel.text font:_startPriceLabel.font maxSize:MAXSIZE];
    CGFloat startPriceLabelW = startPriceSize.width;
    CGFloat startPriceLabelH = startPriceSize.height;
    CGFloat startPriceLabelX = titleLabelX;
    CGFloat startPriceLabelY = CGRectGetMaxY(self.rateView.frame) + 12.0;
    self.startPriceLabel.frame = CGRectMake(startPriceLabelX, startPriceLabelY, startPriceLabelW, startPriceLabelH);
    
    // 左竖线
    CGFloat leftVLineW = 0.5;
    CGFloat leftVLineH = 12.0;
    CGFloat leftVLineX = CGRectGetMaxX(self.startPriceLabel.frame) + 8.0;
    CGFloat leftVLineY = startPriceLabelY;
    self.leftVLine.frame = CGRectMake(leftVLineX, leftVLineY, leftVLineW, leftVLineH);
    self.leftVLine.centerY = self.startPriceLabel.centerY;
    
    // 配送费
    CGSize freightSize = [NSString sizeWithString:_freightLabel.text font:_freightLabel.font maxSize:MAXSIZE];
    CGFloat freightLabelW = freightSize.width;
    CGFloat freightLabelH = freightSize.height;
    CGFloat freightLabelX = CGRectGetMaxX(self.leftVLine.frame) + 8.0;
    CGFloat freightLabelY = startPriceLabelY;
    self.freightLabel.frame = CGRectMake(freightLabelX, freightLabelY, freightLabelW, freightLabelH);
    
    // 右竖线
    CGFloat rightVLineW = 0.5;
    CGFloat rightVLineH = 12.0;
    CGFloat rightVLineX = CGRectGetMaxX(self.freightLabel.frame) + 8.0;
    CGFloat rightVLineY = startPriceLabelY;
    self.rightVLine.frame = CGRectMake(rightVLineX, rightVLineY, rightVLineW, rightVLineH);
    self.rightVLine.centerY = self.startPriceLabel.centerY;
    
    // 耗时
    CGSize timeSize = [NSString sizeWithString:_timeLabel.text font:_timeLabel.font maxSize:MAXSIZE];
    CGFloat timeLabelW = timeSize.width;
    CGFloat timeLabelH = timeSize.height;
    CGFloat timeLabelX = CGRectGetMaxX(self.rightVLine.frame) + 8.0;
    CGFloat timeLabelY = startPriceLabelY;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    // 优惠
    CGFloat promotViewW = self.width - startPriceLabelX;
    CGFloat promotViewH = PROMOTVIEW_HEIGHT;
    CGFloat promotViewX = startPriceLabelX;
    CGFloat promotViewY = CGRectGetMaxY(self.startPriceLabel.frame);
    self.promotView.frame = CGRectMake(promotViewX, promotViewY, promotViewW, promotViewH);
    
    // 底部分割线
    CGFloat bottomDividerX = padding;
    CGFloat bottomDividerH = 0.5;
    CGFloat bottomDividerY = self.height - bottomDividerH;
    CGFloat bottomDividerW = self.width - padding;
    self.bottomDivider.frame = CGRectMake(bottomDividerX, bottomDividerY, bottomDividerW, bottomDividerH);
}


@end
