//
//  NBOrderInfomationView.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderInfomationView.h"
#import "NBCommon.h"
#import "NBOrderInfomationLabel.h"
#define H_MARGIN 15.f
@interface NBOrderInfomationView ()
/**
 *  标题
 */
@property(nonatomic, weak) UILabel *titleLabel;
/**
 *  顶分割线
 */
@property(nonatomic, weak) UIView *topDivider;
/**
 *  中分割线
 */
@property(nonatomic, weak) UIView *middleDivider;
/**
 *  订单号码
 */
@property(nonatomic, weak) NBOrderInfomationLabel *numberLabel;
/**
 *  订单时间
 */
@property(nonatomic, weak) NBOrderInfomationLabel *orderTimeLabel;
/**
 *  支付方式
 */
@property(nonatomic, weak) NBOrderInfomationLabel *payMethodLabel;
/**
 *  手机号码
 */
@property(nonatomic, weak) NBOrderInfomationLabel *phoneLabel;
/**
 *  收餐地址
 */
@property(nonatomic, weak) NBOrderInfomationLabel *addressLabel;

/**
 *  订单号码
 */
@property(nonatomic, weak) NBOrderInfomationLabel *numberTitleLabel;
/**
 *  订单时间
 */
@property(nonatomic, weak) NBOrderInfomationLabel *orderTimeTitleLabel;
/**
 *  支付方式
 */
@property(nonatomic, weak) NBOrderInfomationLabel *payMethodTitleLabel;
/**
 *  手机号码
 */
@property(nonatomic, weak) NBOrderInfomationLabel *phoneTitleLabel;
/**
 *  收餐地址
 */
@property(nonatomic, weak) NBOrderInfomationLabel *addressTitleLabel;

@end

@implementation NBOrderInfomationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{

    // 定分割线
    UIView *topDivider = [[UIView alloc] init];
    topDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self addSubview:topDivider];
    _topDivider = topDivider;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"订单详情";
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.textColor = HEX_COLOR(0x464646);
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    // 中分割线
    UIView *middleDivider = [[UIView alloc] init];
    middleDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [self addSubview:middleDivider];
    _middleDivider = middleDivider;
    
    //订单号码标题
    NBOrderInfomationLabel *numberTitleLabel = [[NBOrderInfomationLabel alloc] init];
    numberTitleLabel.text = @"订单号码 : ";
    [self addSubview:numberTitleLabel];
    _numberTitleLabel = numberTitleLabel;
    // 订单号码
    NBOrderInfomationLabel *numberLabel = [[NBOrderInfomationLabel alloc] init];
    [self addSubview:numberLabel];
    _numberLabel = numberLabel;
    
    // 订单时间标题
    NBOrderInfomationLabel *orderTimeTitleLabel = [[NBOrderInfomationLabel alloc] init];
    orderTimeTitleLabel.text = @"订单时间 : ";
    [self addSubview:orderTimeTitleLabel];
    _orderTimeTitleLabel = orderTimeTitleLabel;
    // 订单时间
    NBOrderInfomationLabel *orderTimeLabel = [[NBOrderInfomationLabel alloc] init];
    [self addSubview:orderTimeLabel];
    _orderTimeLabel = orderTimeLabel;
    // 支付方式标题
    NBOrderInfomationLabel *payMethodTitleLabel = [[NBOrderInfomationLabel alloc] init];
    payMethodTitleLabel.text = @"支付方式 : ";
    [self addSubview:payMethodTitleLabel];
    _payMethodTitleLabel = payMethodTitleLabel;
    // 支付方式
    NBOrderInfomationLabel *payMethodLabel = [[NBOrderInfomationLabel alloc] init];
    [self addSubview:payMethodLabel];
    _payMethodLabel = payMethodLabel;
    // 手机号码标题
    NBOrderInfomationLabel *phoneTitleLabel = [[NBOrderInfomationLabel alloc] init];
    phoneTitleLabel.text = @"手机号码 : ";
    [self addSubview:phoneTitleLabel];
    _phoneTitleLabel = phoneTitleLabel;
    // 手机号码
    NBOrderInfomationLabel *phoneLabel = [[NBOrderInfomationLabel alloc] init];
    [self addSubview:phoneLabel];
    _phoneLabel = phoneLabel;
    // 收餐地址标题
    NBOrderInfomationLabel *addressTitleLabel = [[NBOrderInfomationLabel alloc] init];
    addressTitleLabel.text = @"收餐地址 : ";
    [self addSubview:addressTitleLabel];
    _addressTitleLabel = addressTitleLabel;
    // 收餐地址
    NBOrderInfomationLabel *addressLabel = [[NBOrderInfomationLabel alloc] init];
    addressLabel.numberOfLines = 0;
    [self addSubview:addressLabel];
    _addressLabel = addressLabel;
}



- (void)setupSubViewFrames
{
    // 顶分割线
    CGFloat topDividerW = SCREEN_WIDTH;
    CGFloat topDividerH = .5f;
    CGFloat topDividerX = 0;
    CGFloat topDividerY = 0;
    _topDivider.frame = CGRectMake(topDividerX, topDividerY, topDividerW, topDividerH);
    
    // 标题
    CGSize titleSize = [NSString sizeWithString:_titleLabel.text font:_titleLabel.font maxSize:MAXSIZE];
    CGFloat titleLabelW = titleSize.width;
    CGFloat titleLabelH = titleSize.height;
    CGFloat titleLabelX = H_MARGIN;
    CGFloat titleLabelY = CGRectGetMaxY(_topDivider.frame) + 13.f;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    
    // 中分割线
    CGFloat middleDividerW = SCREEN_WIDTH - 2 * H_MARGIN;
    CGFloat middleDividerH = .5f;
    CGFloat middleDividerX = H_MARGIN;
    CGFloat middleDividerY = CGRectGetMaxY(_titleLabel.frame) + 13.f;
    _middleDivider.frame = CGRectMake(middleDividerX, middleDividerY, middleDividerW, middleDividerH);
    
    // 订单号码标题
    CGSize numberTitleSize = [NSString sizeWithString:_numberTitleLabel.text font:_numberTitleLabel.font maxSize:MAXSIZE];
    CGFloat numberTitleLabelW = numberTitleSize.width;
    CGFloat numberTitleLabelH = numberTitleSize.height;
    CGFloat numberTitleLabelX = H_MARGIN;
    CGFloat numberTitleLabelY = CGRectGetMaxY(_middleDivider.frame) + 13.f;
    _numberTitleLabel.frame = CGRectMake(numberTitleLabelX, numberTitleLabelY, numberTitleLabelW, numberTitleLabelH);
    // 订单号码
    CGSize numberSize = [NSString sizeWithString:_numberLabel.text font:_numberTitleLabel.font maxSize:MAXSIZE];
    CGFloat numberLabelW = numberSize.width;
    CGFloat numberLabelH = numberSize.height;
    CGFloat numberLabelX = CGRectGetMaxX(_numberTitleLabel.frame);
    CGFloat numberLabelY = CGRectGetMinY(_numberTitleLabel.frame);
    _numberLabel.frame = CGRectMake(numberLabelX, numberLabelY, numberLabelW, numberLabelH);
    // 订单时间标题
    CGFloat orderTimeTitleLabelW = numberTitleSize.width;
    CGFloat orderTimeTitleLabelH = numberTitleSize.height;
    CGFloat orderTimeTitleLabelX = H_MARGIN;
    CGFloat orderTimeTitleLabelY = CGRectGetMaxY(_numberTitleLabel.frame) + 13.f;
    _orderTimeTitleLabel.frame = CGRectMake(orderTimeTitleLabelX, orderTimeTitleLabelY, orderTimeTitleLabelW, orderTimeTitleLabelH);
    // 订单时间
    CGSize orderTimeSize = [NSString sizeWithString:_orderTimeLabel.text font:_orderTimeLabel.font maxSize:MAXSIZE];
    CGFloat orderTimeLabelW = orderTimeSize.width;
    CGFloat orderTimeLabelH = orderTimeSize.height;
    CGFloat orderTimeLabelX = CGRectGetMaxX(_orderTimeTitleLabel.frame);
    CGFloat orderTimeLabelY = CGRectGetMinY(_orderTimeTitleLabel.frame);
    _orderTimeLabel.frame = CGRectMake(orderTimeLabelX, orderTimeLabelY, orderTimeLabelW, orderTimeLabelH);
    if (_item.status != NBOrderStatusTypeNotPay) { // 如果处于未付款状态,不显示支付方式,否则显示
        // 支付方式标题
        CGFloat payMethodTitleLabelW = numberTitleSize.width;
        CGFloat payMethodTitleLabelH = numberTitleSize.height;
        CGFloat payMethodTitleLabelX = H_MARGIN;
        CGFloat payMethodTitleLabelY = CGRectGetMaxY(_orderTimeTitleLabel.frame) + 13.f;
        _payMethodTitleLabel.frame = CGRectMake(payMethodTitleLabelX, payMethodTitleLabelY, payMethodTitleLabelW, payMethodTitleLabelH);
        
        // 支付方式
        CGSize payMethodSize = [NSString sizeWithString:_payMethodLabel.text font:_payMethodLabel.font maxSize:MAXSIZE];
        CGFloat payMethodLabelW = payMethodSize.width;
        CGFloat payMethodLabelH = payMethodSize.height;
        CGFloat payMethodLabelX = CGRectGetMaxX(_payMethodTitleLabel.frame);
        CGFloat payMethodLabelY = CGRectGetMinY(_payMethodTitleLabel.frame);
        _payMethodLabel.frame = CGRectMake(payMethodLabelX, payMethodLabelY, payMethodLabelW, payMethodLabelH);
    }else
    {
        [_payMethodTitleLabel removeFromSuperview];
        [_payMethodLabel removeFromSuperview];
    }
    if (_item.phone || _item.phone.length >0) {
        // 手机号码标题
        CGFloat phoneTitleLabelW = numberTitleSize.width;
        CGFloat phoneTitleLabelH = numberTitleSize.height;
        CGFloat phoneTitleLabelX = H_MARGIN;
        CGFloat phoneTitleLabelY = CGRectGetMaxY(_payMethodTitleLabel?_payMethodTitleLabel.frame:_orderTimeLabel.frame) + 13.f;
        _phoneTitleLabel.frame = CGRectMake(phoneTitleLabelX, phoneTitleLabelY, phoneTitleLabelW, phoneTitleLabelH);
        // 手机号码
        CGSize phoneSize = [NSString sizeWithString:_phoneLabel.text font:_phoneLabel.font maxSize:MAXSIZE];
        CGFloat phoneLabelW = phoneSize.width;
        CGFloat phoneLabelH = phoneSize.height;
        CGFloat phoneLabelX = CGRectGetMaxX(_phoneTitleLabel.frame);
        CGFloat phoneLabelY = CGRectGetMinY(_phoneTitleLabel.frame);
        _phoneLabel.frame = CGRectMake(phoneLabelX, phoneLabelY, phoneLabelW, phoneLabelH);
    }else
    {
        [_phoneTitleLabel removeFromSuperview];
        [_phoneLabel removeFromSuperview];
    }
    
    // 收餐地址标题
    CGFloat addressTitileLabelW = numberTitleSize.width;
    CGFloat addressTitileLabelH = numberTitleSize.height;
    CGFloat addressTitileLabelX = H_MARGIN;
    CGFloat addressTitileLabelY = CGRectGetMaxY(_phoneTitleLabel?_phoneTitleLabel.frame:(_payMethodTitleLabel?_payMethodTitleLabel.frame:_orderTimeTitleLabel.frame)) + 13.f;
    _addressTitleLabel.frame = CGRectMake(addressTitileLabelX, addressTitileLabelY, addressTitileLabelW, addressTitileLabelH);
    // 收餐地址
    CGSize addressSize = [NSString sizeWithString:_addressLabel.text font:_addressLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - CGRectGetMaxX(_addressTitleLabel.frame) - H_MARGIN, MAXFLOAT)];
    CGFloat addressLabelW = addressSize.width;
    CGFloat addressLabelH = addressSize.height;
    CGFloat addressLabelX = CGRectGetMaxX(_addressTitleLabel.frame);
    CGFloat addressLabelY = CGRectGetMinY(_addressTitleLabel.frame);
    _addressLabel.frame = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
    
    _selfHeight = CGRectGetMaxY(_addressLabel.frame) + 13.f;
}


- (void)setItem:(NBOrderModel *)item
{
    _item = item;
    _numberLabel.text = item.orderID;
    _orderTimeLabel.text = item.orderTime;
    NSString *payMethodStr = nil;
    switch (item.payMethod) {
        case NBPayMethodTypeWechat:
            payMethodStr = @"微信支付";
            break;
        case NBPayMethodTypeAlipay:
            payMethodStr = @"支付宝支付";
            break;
        default:
            break;
    }
    _payMethodLabel.text = payMethodStr;
    _phoneLabel.text = item.phone;
    _addressLabel.text = item.address;
    
    [self setupSubViewFrames];
}
@end
