//
//  NBOrderDetailViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBOrderDetailViewController.h"
#import "NBOrderStatusCell.h"
#import "NBOrderTakeCodeView.h"
#import "NBPayMerchantCell.h"
#import "NBMerchantDetailViewController.h"
#import "NBDishesList.h"
#import "NBPayDishCell.h"
#import "NBPayPromotCell.h"
#import "NBPayTotalPriceCell.h"
#import "NBOrderInfomationView.h"
#import "NBDateTool.h"
#import "NBOrderHttpTool.h"
#import "NBPayHttpTool.h"
#import "Order.h"
#import "AlipayConfig.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NBPayMethodView.h"
#import "WXApi.h"
#import "WXUtil.h"
#import "AlipayConfig.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NBTabBarController.h"
#import "NBNavigationController.h"

@interface NBOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NBPayMethodView *_payMethodView;
}
@property(nonatomic, copy) NSString *orderID;


@property(nonatomic, strong) NBDishesList *dishesList;
/**
 *  商户Cell
 */
@property(nonatomic, strong) NBPayMerchantCell *merchantCell;
/**
 *  总价Cell
 */
@property(nonatomic, strong) NBPayTotalPriceCell *totalPriceCell;

//@property(nonatomic, weak) NBOrderTakeTimeView *takeTimeView;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, assign) float timeOffset;
/** 未支付状态下底部按钮 */
@property(nonatomic, weak) UIView *notPayBottomView;
/** 取消状态下底部按钮 */
@property(nonatomic, weak) UIView *cancelBottomView;

/** 时间戳 */
@property(nonatomic, copy) NSString *timeStamp;

@end

//NBDishesList *g_dishesList;

@implementation NBOrderDetailViewController

#pragma mark - lazyload

- (UIView *)cancelBottomView
{
    if (!_cancelBottomView) {
        UIView *cancelBottomView = [[UIView alloc] init];
        [self.view addSubview:cancelBottomView];
        cancelBottomView.backgroundColor = [UIColor whiteColor];
        [cancelBottomView autoSetDimension:ALDimensionHeight toSize:49.f];
        [cancelBottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        // 上分割线
        UIView *topDivider = [[UIView alloc] initForAutoLayout];
        topDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
        [cancelBottomView addSubview:topDivider];
        [topDivider autoSetDimension:ALDimensionHeight toSize:.5f];
        [topDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        UIButton *oneMoreOrderButton = [[UIButton alloc] init];
        [oneMoreOrderButton addTarget:self action:@selector(oneMoreOrderBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBottomView addSubview:oneMoreOrderButton];
        oneMoreOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
        oneMoreOrderButton.layer.cornerRadius = 3;
        oneMoreOrderButton.layer.masksToBounds = YES;
        [oneMoreOrderButton setTitle:@"再来一单" forState:UIControlStateNormal];
        [oneMoreOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *payBgImage = [UIImage imageNamed:@"order_one_more_order_btn_bg"];
        [oneMoreOrderButton setBackgroundImage:payBgImage.resizedImage forState:UIControlStateNormal];
        [oneMoreOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [oneMoreOrderButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [oneMoreOrderButton autoSetDimension:ALDimensionHeight toSize:33.0];
        CGFloat padding = 30.0;
        [oneMoreOrderButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding];
        [oneMoreOrderButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:padding];
        _cancelBottomView = cancelBottomView;
        cancelBottomView.hidden = YES;
    }
    return _cancelBottomView;
}

- (UIView *)notPayBottomView
{
    if (!_notPayBottomView) {
        UIView *notPayBottomView = [[UIView alloc] init];
        [self.view addSubview:notPayBottomView];
        notPayBottomView.backgroundColor = [UIColor whiteColor];
        [notPayBottomView autoSetDimension:ALDimensionHeight toSize:49.f];
        [notPayBottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        // 上分割线
        UIView *topDivider = [[UIView alloc] initForAutoLayout];
        topDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
        [notPayBottomView addSubview:topDivider];
        [topDivider autoSetDimension:ALDimensionHeight toSize:.5f];
        [topDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        
        
        UIButton *payButton = [[UIButton alloc] init];
        [payButton addTarget:self action:@selector(payBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        payButton.titleLabel.font = [UIFont systemFontOfSize:13];
        payButton.layer.cornerRadius = 3;
        payButton.layer.masksToBounds = YES;
        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        UIImage *payBgImage = [UIImage imageNamed:@"order_pay_btn_bg"];
        [payButton setBackgroundImage:payBgImage.resizedImage forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [notPayBottomView addSubview:payButton];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton addTarget:self action:@selector(cancelBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        cancelButton.layer.cornerRadius = 3;
        cancelButton.layer.masksToBounds = YES;
        [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        UIImage *cancelBgImage = [UIImage imageNamed:@"order_cancel_order_bg"];
        [cancelButton setBackgroundImage:cancelBgImage.resizedImage forState:UIControlStateNormal];
        [cancelButton setTitleColor:HEX_COLOR(0xffaf00) forState:UIControlStateNormal];
        [notPayBottomView addSubview:cancelButton];

        
        int padding = 10;
        int height = 33.0;
        [payButton autoSetDimension:ALDimensionHeight toSize:height];
        [payButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [payButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding];
        [payButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cancelButton withOffset:-padding];
        
        [cancelButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [cancelButton autoSetDimension:ALDimensionHeight toSize:height];
        [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:padding];
        [cancelButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:payButton];
        
        notPayBottomView.hidden = YES;
        _notPayBottomView = notPayBottomView;

    }
    return _notPayBottomView;
}

- (NBPayMerchantCell *)merchantCell
{
    if (!_merchantCell) {
        _merchantCell = [[NBPayMerchantCell alloc] init];
        _merchantCell.textLabel.text = _orderModel.merchant;
        [_merchantCell addTarget:self action:@selector(merchantCellOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _merchantCell;
}

- (NBPayTotalPriceCell *)totalPriceCell
{
    if (!_totalPriceCell) {
        _totalPriceCell = [[NBPayTotalPriceCell alloc] init];
        _totalPriceCell.price = _orderModel.price;
        _totalPriceCell.discountPrice = _orderModel.price - [_orderModel.promot.discountmoney floatValue];
    }
    return _totalPriceCell;
}

- (instancetype)initWithOrderID:(NSString *)orderID
{
    if (self = [self init]) {
        _orderID = orderID;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self loadOrderDetailData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChanged:) name:ORDER_STATUS_CHANGED object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderStatusWithJustPay) name:ORDER_BE_PAY object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ORDER_BE_PAY object:nil];
    [super viewDidDisappear:animated];
}



#pragma mark - Setup
- (void)setupSubViews
{
    [self setupDishList];
    
    
    // 如果订单处于未支付状态,展示支付按钮和取消按钮
    if (_orderModel.status == NBOrderStatusTypeNotPay) {
        self.notPayBottomView.hidden = NO;
    }else if(_orderModel.status == NBOrderStatusTypeCancel)// 如果订单处于取消状态,则展示再来一单按钮
    {
        self.cancelBottomView.hidden = NO;
    }
}

/** 创建菜品详情列表 */
- (void)setupDishList
{
    // 菜品详情列表
    _dishesList = [[NBDishesList alloc] init];
    [self.view addSubview:_dishesList];
    _dishesList.delegate = self;
    _dishesList.dataSource = self;
//    g_dishesList = dishesList;
    
    _dishesList.backgroundColor = HEX_COLOR(0xf3f3f3);
    [_dishesList autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_dishesList autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    _dishesList = dishesList;
    
    [self setupDishesHeaderView];
    [self setupDishesFooterView];
}

/**
 *  设置头部
 */
- (void)setupDishesHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    
    // 状态Cell
    NBOrderStatusCell *statusCell = [[NBOrderStatusCell alloc] init];
    statusCell.statusType = _orderModel.status;
    statusCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.5f);
    [headerView addSubview:statusCell];
    
    // 如果订单是制作中/已支付/等待取餐状态,则显示时间区和等号区域
    if (_orderModel.status == NBOrderStatusTypeInMaking || _orderModel.status == NBOrderStatusTypeJustPay||_orderModel.status == NBOrderStatusTypeWaitingForTaking) {
        //        // 时间Cell
        //        // 计算订单时间时间和现在的时差
        //        NSDate *nowTime = [NSDate date];
        //        NSDate *orderTime = [[NBDateTool dateFormatter] dateFromString:_orderModel.orderTime];
        //        _timeOffset = [nowTime timeIntervalSinceDate:orderTime];
        
        //        NBOrderTakeTimeView *takeTimeView = [[NBOrderTakeTimeView alloc] init];
        //        takeTimeView.statusType = _orderModel.status;
        //        _takeTimeView = takeTimeView;
        //        CGFloat takeTimeW = SCREEN_WIDTH;
        //        CGFloat takeTimeH = 63.5f;
        //        CGFloat takeTimeX = 0;
        //        CGFloat takeTimeY = CGRectGetMaxY(statusCell.frame);
        //        takeTimeView.frame = CGRectMake(takeTimeX, takeTimeY, takeTimeW, takeTimeH);
        //        [headerView addSubview:takeTimeView];
        
        // 等待号码
        NBOrderTakeCodeView *takeCodeView = [[NBOrderTakeCodeView alloc] init];
        takeCodeView.frame = CGRectMake(0, CGRectGetMaxY(statusCell.frame), SCREEN_WIDTH, 200.f);
        takeCodeView.statusType = _orderModel.status;
        takeCodeView.takeCode = _orderModel.takeCode;
        [headerView addSubview:takeCodeView];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(takeCodeView.frame));
    }else
    {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(statusCell.frame));
    }
    _dishesList.tableHeaderView = headerView;
}


/**
 *  设置尾部
 */
- (void)setupDishesFooterView
{
    // 订单信息
    NBOrderInfomationView *infomationView = [[NBOrderInfomationView alloc] init];
    infomationView.item = _orderModel;
    CGFloat infomationViewW = SCREEN_WIDTH;
    CGFloat infomationViewH = infomationView.selfHeight;
    CGFloat infomationViewX = 0;
    CGFloat infomationViewY = 4.5f;
    infomationView.frame = CGRectMake(infomationViewX, infomationViewY, infomationViewW, infomationViewH);
    
    // 如果订单状态是未支付
    if (_orderModel.status == NBOrderStatusTypeNotPay) {
        _payMethodView = [[NBPayMethodView alloc] init];
        _payMethodView.frame = CGRectMake(0, CGRectGetMaxY(infomationView.frame), SCREEN_WIDTH, 174.5f);
    }
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = HEX_COLOR(0xf3f3f3);
    CGFloat footerViewW = infomationViewW;
    CGFloat footerViewH = infomationViewH + infomationViewY +_payMethodView.height + 55.0;
    CGFloat footerViewX = 0;
    CGFloat footerViewY = 0;
    footerView.frame = CGRectMake(footerViewX, footerViewY, footerViewW, footerViewH);
    [footerView addSubview:infomationView];
    [footerView addSubview:_payMethodView];
    _dishesList.tableFooterView = footerView;
}

#pragma mark - Load data
- (void)loadOrderDetailData
{
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.orderid = _orderID;
    
    [SVProgressHUD show];
    [NBOrderHttpTool getOrderDetailWithParam:param success:^(NBOrderDetailResponseModel *result) {
        [SVProgressHUD dismiss];
        if (result.code == 0) {
            NBOrderModel *order = [[NBOrderModel alloc] init];
            order.status = result.data.order.status;
//            order.status = NBOrderStatusTypeCancel;
            order->_orderTime = result.data.order.orderTime;
            order.merchantID = result.data.order.merchantID;
            order.merchant = result.data.order.merchant;
            order.payMethod = result.data.order.payMethod;
            order.dishes = result.data.orderDetails;
            order.price = result.data.order.price;
            order.orderID = result.data.order.orderID;
            order.phone = result.data.address.phone;
            order.address = result.data.address.address;
            order.takeCode = result.data.order.takeCode;
            order.promotdetail = result.data.order.promotdetail;
            order.promottype = result.data.order.promottype;
            _orderModel = order;
            [self setupSubViews];
            // 如果订单是已支付状态 开始计时
//            if (_orderModel.status == NBOrderStatusTypeJustPay) {
//                _takeTimeView.time = [NSString stringWithFormat:@"%@",[NBDateTool timeStringFromTimeInterval:result.data.intervaltime]];
//                [self addTimer];
//            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NBLog(@"%@",error);
    }];
}






#pragma mark - Action
- (void)orderStatusChanged:(NSNotification *)notification
{
    NBOrderModel *order = notification.userInfo[@"order"];
    if (![order.orderID isEqualToString:_orderID]) return;
    _orderModel.status = order.status;
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setupSubViews];
}


- (void)oneMoreOrderBtnOnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:NO];
    NBTabBarController *tabBarVc = (NBTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabBarVc setSelectedIndex:0];
}

- (void)backBtnOnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payBtnOnClick:(UIButton *)button
{
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.orderid = _orderModel.orderID;
    param.paytype = [NSNumber numberWithInteger:_payMethodView.payMethodType];
    __weak typeof(self) weakSelf = self;
    [NBOrderHttpTool updateOrderPayMethodWithParam:param success:^(NBUpdateOrderPayMethodResponse *result) {
        if (result.code == 0) {
            _orderModel.prepayid = result.data.prepayid;
            switch (_payMethodView.payMethodType) {
                case NBPayMethodTypeAlipay:
                    [weakSelf payByAlipay];
                    break;
                case NBPayMethodTypeWechat:
                    [weakSelf payByWechat];
                    break;
                default:
                    break;
            }
        }
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
    }];
}

- (void)merchantCellOnClick
{
    NBMerchantDetailViewController *merchantVc = [[NBMerchantDetailViewController alloc] initWithMerchantID:_orderModel.merchantID];
    [self.navigationController pushViewController:merchantVc animated:YES];
}

- (void)payByAlipay
{
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_PARTNER;
    order.seller = ALIPAY_SELLER;
    order.tradeNO = _orderModel.orderID; //订单ID（由商家自行制定）
    order.productName = _orderModel.merchant; //商品标题
    order.productDescription = _orderModel.merchant; //商品描述

    order.amount = [NSString stringWithFormat:@"%.2f",_orderModel.price]; //商品价格
    order.notifyURL =  ALIPAY_NOTIFY_URL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = APP_SCHEME;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_PRIVATE_KEY);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    }
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSString *resultStatus = resultDic[@"resultStatus"];
        switch ([resultStatus intValue]) {
            case 9000:
                [self refreshOrderStatusWithJustPay];
                break;
            default:
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                break;
//            }
        }
    }];
}

- (void)payByWechat
{
    // 时间戳
    self.timeStamp = [self getCurrentTimeStamp];
    PayReq *request = [[PayReq alloc] init];
    
    request.openID = WECHAT_KEY;
    request.partnerId = PARTNER_ID;
    request.prepayId = _orderModel.prepayid;
    request.package = @"Sign=WXPay";
    request.nonceStr = [self getNonceStr];
    request.timeStamp = (UInt32)[self.timeStamp integerValue];//构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:WECHAT_KEY        forKey:@"appid"];
    [params setObject: request.nonceStr    forKey:@"noncestr"];
    [params setObject: request.package      forKey:@"package"];
    [params setObject: PARTNER_ID        forKey:@"partnerid"];
    [params setObject: self.timeStamp   forKey:@"timestamp"];
    [params setObject: request.prepayId     forKey:@"prepayid"];
    request.sign = [self createMd5Sign:params];
    
    [WXApi sendReq:request];
}

/** 更新订单状态为刚支付状态 */
- (void)refreshOrderStatusWithJustPay
{
    _orderModel.status = NBOrderStatusTypeJustPay;
    _orderModel.payMethod = _payMethodView.payMethodType;
    _payMethodView = nil;
    // 去服务器取取餐号
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.orderid = self.orderID;
    param.orderstatus = [NSNumber numberWithInteger:NBOrderStatusTypeJustPay];
    [NBPayHttpTool getTakeCodeWithParam:param success:^(NBGetTakeCodeResponseModel *result) {
        self.orderModel.status = NBOrderStatusTypeJustPay;
        self.orderModel.takeCode = result.data.order.takeCode;
        
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        [self setupSubViews];
        
        if (0 == result.code) {
            if (self.statusChangeBlock) {
                self.statusChangeBlock(NBOrderStatusTypeJustPay);
            }
        }
        //  [self addTimer];
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
    }];
}

- (void)cancelBtnOnClick:(UIButton *)button
{
    UIAlertView *warningView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"您确定取消订单吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [warningView show];
}

#pragma mark UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;

    [SVProgressHUD show];
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.orderid = _orderID;
    param.orderstatus = [NSNumber numberWithInteger:NBOrderStatusTypeCancel];
    [NBPayHttpTool getTakeCodeWithParam:param success:^(NBGetTakeCodeResponseModel *result) {
        //        [SVProgressHUD dismiss];
        if (result.code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功"];
            if (self.statusChangeBlock) {
                self.statusChangeBlock(NBOrderStatusTypeCancel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NBLog(@"%@",error);
    }];
}

///**
// *  添加定时器
// */
//- (void)addTimer
//{
//    if (!_timer) {
//        CGFloat duration = 1.f;
//        _timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//    }
//}
///**
// *  移除定时器
// */
//- (void)removeTimer
//{
//    [self.timer invalidate];
//    self.timer = nil;
//}

//- (void)changeTime
//{
//    _timeOffset++;
////    _takeTimeView.time = [NSString stringWithFormat:@"%@",[NBDateTool timeStringFromTimeInterval:_timeOffset]];
//}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderModel.promottype == NBPromotTypeNone?1:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _orderModel.dishes.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NBPayDishCell *cell = [NBPayDishCell cellWithTableView:tableView];
        NBDishModel *item = _orderModel.dishes[indexPath.row];
        cell.item = item;
        return cell;
    }else
    {
        NBPayPromotCell *cell = [NBPayPromotCell cellWithTableView:tableView];
        cell.item = _orderModel.promot;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 39.0f;
    }
    return 1 / MAXFLOAT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 45;
    }
    if (_orderModel.promottype == NBPromotTypeNone) {
        return 45;
    }
    return 5.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return self.merchantCell;
    }
    return nil;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return self.totalPriceCell;
    }
    if (_orderModel.promottype == NBPromotTypeNone) {
        return self.totalPriceCell;
    }
    return nil;
}







#pragma mark - Pay Tool
- (NSString *)getNonceStr
{
    return [WXUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)getCurrentTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"mov9ok0yHuKj4oGl1yEmtGk2uoo4TNKA"];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    //    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ORDER_STATUS_CHANGED object:nil];
//    NBLog(@"订单详情挂了");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@",_dishesList);
//    });
    _dishesList.delegate = nil;
    _dishesList.dataSource = nil;
}




@end
