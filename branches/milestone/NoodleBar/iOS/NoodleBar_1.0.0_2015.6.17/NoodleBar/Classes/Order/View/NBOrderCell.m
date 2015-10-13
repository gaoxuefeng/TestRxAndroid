//
//  NBOrderCell.m
//  NoodleBar
//
//  Created by sen on 15/4/23.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderCell.h"
#import <UIImageView+WebCache.h>
@interface NBOrderCell()
@property(nonatomic, weak) UILabel *timeLabel;
@property(nonatomic, weak) UILabel *statusLabel;
@property(nonatomic, weak) UIView *middleDivider;
@property(nonatomic, weak) UIView *bottomDivider;
@property(nonatomic, weak) UIImageView *arrowImageView;

@end

@implementation NBOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"orderCell";
    NBOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NBOrderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
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
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = HEX_COLOR(0x595757);
    timeLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = HEX_COLOR(0xe94619);
    statusLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:statusLabel];
    _statusLabel = statusLabel;
    UIView *middleDivider = [[UIView alloc] init];
    [self.contentView addSubview:middleDivider];
    middleDivider.backgroundColor = HEX_COLOR(0xc1c1c1);
    _middleDivider = middleDivider;
    self.textLabel.font = [UIFont systemFontOfSize:12.f];
    self.textLabel.textColor = HEX_COLOR(0x231815);
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:10.f];
    self.detailTextLabel.textColor = HEX_COLOR(0xe94818);
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"mine_cell_next"];
    [self.contentView addSubview:arrowImageView];
    _arrowImageView = arrowImageView;
    UIView *bottomDivider = [[UIView alloc] init];
    bottomDivider.backgroundColor = HEX_COLOR(0xc1c1c1);
    [self.contentView addSubview:bottomDivider];
    _bottomDivider = bottomDivider;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize timeSize = [NSString sizeWithString:_timeLabel.text font:_timeLabel.font maxSize:MAXSIZE];
    CGFloat timeLabelW = timeSize.width;
    CGFloat timeLabelH = timeSize.height;
    CGFloat timeLabelX = 13.f;
    CGFloat timeLabelY = 13.f;
    _timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGSize statusSize = [NSString sizeWithString:_statusLabel.text font:_statusLabel.font maxSize:MAXSIZE];
    CGFloat statusLabelW = statusSize.width;
    CGFloat statusLabelH = statusSize.height;
    CGFloat statusLabelX = self.width - 13.f - statusLabelW;
    CGFloat statusLabelY = 13.f;
    _statusLabel.frame = CGRectMake(statusLabelX, statusLabelY, statusLabelW, statusLabelH);
    
    CGFloat middleDividerW = SCREEN_WIDTH;
    CGFloat middleDividerH = .5f;
    CGFloat middleDividerX = 0;
    CGFloat middleDividerY = CGRectGetMaxY(_statusLabel.frame) + 13.f;
    _middleDivider.frame = CGRectMake(middleDividerX, middleDividerY, middleDividerW, middleDividerH);
    
    CGFloat bottomDividerW = SCREEN_WIDTH - 14.f;
    CGFloat bottomDividerH = .5f;
    CGFloat bottomDividerX = 7.f;
    CGFloat bottomDividerY = self.height - bottomDividerH;
    _bottomDivider.frame = CGRectMake(bottomDividerX, bottomDividerY, bottomDividerW, bottomDividerH);
    
    CGFloat imageViewW = 88.f;
    CGFloat imageViewH = 68.f;
    CGFloat imageViewX = 7.f;
    CGFloat imageViewY = (_middleDivider.y + _bottomDivider.y - imageViewH) * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    CGFloat arrowImageW = _arrowImageView.image.size.width;
    CGFloat arrowImageH = _arrowImageView.image.size.height;
    CGFloat arrowImageX = self.width - 13.f - arrowImageW;
    CGFloat arrowImageY = (_middleDivider.y + _bottomDivider.y - arrowImageH) * 0.5;
    _arrowImageView.frame = CGRectMake(arrowImageX, arrowImageY, arrowImageW, arrowImageH);
    
    
    CGSize titleSize = [NSString sizeWithString:self.textLabel.text font:self.textLabel.font maxSize:MAXSIZE];
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    CGFloat titleX = CGRectGetMaxX(self.imageView.frame) + 11.f;
    CGFloat titleY = CGRectGetMaxY(_middleDivider.frame) + 13.f;
    self.textLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGSize priceSize = [NSString sizeWithString:self.detailTextLabel.text font:self.detailTextLabel.font maxSize:MAXSIZE];
    CGFloat priceW = priceSize.width;
    CGFloat priceH = priceSize.height;
    CGFloat priceX = titleX;
    CGFloat priceY = CGRectGetMaxY(self.textLabel.frame) + 15.f;
    self.detailTextLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}

- (void)setItem:(NBOrderModel *)item
{
    _item = item;
    _timeLabel.text = item.autoOrderTime;
    NSString *status = nil;
    switch (item.status) {
        case NBOrderStatusTypeNotPay:
            status = @"未支付";
            break;
        case NBOrderStatusTypeJustPay:
            status = @"已支付";
            break;
        case NBOrderStatusTypeInMaking:
            status = @"制作中";
            break;
        case NBOrderStatusTypeWaitingForTaking:
            status = @"制作完成";
            break;
        case NBOrderStatusTypeDone:
            status = @"完成";
            break;
        case NBOrderStatusTypeCancel:
            status = @"已取消";
            break;
        default:
            break;
    }
    _statusLabel.text = status;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.merchantImage] placeholderImage:[UIImage imageNamed:@"order_placeholder"]];
    self.textLabel.text = item.merchant;
    self.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:item.price]];
}

@end
