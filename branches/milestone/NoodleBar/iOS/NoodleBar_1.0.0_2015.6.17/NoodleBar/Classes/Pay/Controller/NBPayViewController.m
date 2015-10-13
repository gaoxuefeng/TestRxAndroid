//
//  NBPayViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBPayViewController.h"
#import "NBPayAddressView.h"
#import "NBAccountTool.h"
#import "NBPayMerchantCell.h"
#import "NBPayDishCell.h"
#import "NBCartTool.h"
#import "NBPayTotalPriceCell.h"
#import "NBPayMethodView.h"
#import "NBAddressViewController.h"
#import "NBMerchantDetailViewController.h"
#import "NBOrderDetailViewController.h"
#import "NBDishesList.h"
#import "NBDateTool.h"
#import "NBAddressEditViewController.h"
#import "NBLoginViewController.h"
#import "NBMerchantTool.h"
#import "NBPayHttpTool.h"
#import "NSDictionary+JSONCategories.h"
#import "NSArray+JSONCategories.h"
#import <MJExtension.h>
#import <AlipaySDK/AlipaySDK.h>
#import "NBNavigationController.h"
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "AlipayConfig.h"
#import "WXApi.h"
#import "WXUtil.h"
#import "NBPayPromotCell.h"

@interface NBPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_orderID;
}
@property(nonatomic, weak) UIButton *confirmButton;
@property(nonatomic, weak) NBPayAddressView *addressView;
/**
 *  商户Cell
 */
@property(nonatomic, strong) NBPayMerchantCell *merchantCell;
/**
 *  总价Cell
 */
@property(nonatomic, strong) NBPayTotalPriceCell *totalPriceCell;
/**
 *  支付View
 */
@property(nonatomic, weak) NBPayMethodView *payMethodView;
/** 时间戳 */
@property(nonatomic, copy) NSString *timeStamp;
@end

@implementation NBPayViewController

#pragma mark - Lazy Load
/** 商户Cell */
- (NBPayMerchantCell *)merchantCell
{
    if (!_merchantCell) {
        _merchantCell = [[NBPayMerchantCell alloc] init];
        [_merchantCell addTarget:self action:@selector(merchantCellOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _merchantCell.textLabel.text = [NBMerchantTool currentMerchant].name;
        _merchantCell.width = 39.5f;
    }
    return _merchantCell;
}

/** 总价Cell */
- (NBPayTotalPriceCell *)totalPriceCell
{
    if (!_totalPriceCell) {
        _totalPriceCell = [[NBPayTotalPriceCell alloc] init];
        _totalPriceCell.price = [NBCartTool originalPrice];
        _totalPriceCell.discountPrice = [NBCartTool dishesPrice];
        _totalPriceCell.width = SCREEN_WIDTH;
    }
    return _totalPriceCell;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 如果有当前桌号,说明扫码登录
    if ([NBMerchantTool currentTableCode]) {
        _addressView.tableCode = [NBMerchantTool currentTableCode];
    }else
    {
        _addressView.item = [NBAccountTool account].addresses.firstObject;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToOrderDetail) name:ORDER_BE_PAY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToOrderDetail) name:BACK_FROM_WECHAT_WITH_NO_PAY object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ORDER_BE_PAY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_FROM_WECHAT_WITH_NO_PAY object:nil];
}

#pragma mark - Init
- (void)setupSubViews
{
    [self setupPayButton];
    [self setupPlayList];
}

- (void)setupPlayList
{
    // 支付列表
    NBDishesList *payList = [[NBDishesList alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    payList.dataSource = self;
    payList.delegate = self;
    [self.view addSubview:payList];
    
    
    NBPayAddressView *addressView = [[NBPayAddressView alloc] init];
    _addressView = addressView;
    addressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 72.f);
    [addressView addTarget:self action:@selector(addressViewOnClick:)];
    
    payList.tableHeaderView = addressView;
    
    NBPayMethodView *payMethodView = [[NBPayMethodView alloc] init];
    payMethodView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 174.5f);
    payList.tableFooterView = payMethodView;
    _payMethodView = payMethodView;
    [payList autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [payList autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [payList autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [payList autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [payList autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_confirmButton];
}

/** 创建支付按钮 */
- (void)setupPayButton
{
    UIButton *confirmButton = [[UIButton alloc] initForAutoLayout];
    [confirmButton addTarget:self action:@selector(confirmPayBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton = confirmButton;
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pay_confirm_pay_btn_bg"] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    [confirmButton autoSetDimension:ALDimensionHeight toSize:confirmButton.currentBackgroundImage.size.height];
    [confirmButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [NBCartTool promot]?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [NBCartTool dishes].count;
    }else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NBPayDishCell *cell = [NBPayDishCell cellWithTableView:tableView];
        cell.item = [NBCartTool dishes][indexPath.row];
        return cell;
    }else
    {
        NBPayPromotCell *cell = [NBPayPromotCell cellWithTableView:tableView];
        cell.item = [NBCartTool promot];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.merchantCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 39.5f;
    }
    return 5.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return self.totalPriceCell;
    }
    if (![NBCartTool promot]) {
        return self.totalPriceCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 44.5f;
    }
    if (![NBCartTool promot]) {
        return 44.5f;
    }
    return 0.1;
}

#pragma mark - UITableViewDelegate


#pragma mark - Touch Events
/**
 *  地址按钮点击事件处理
 */
- (void)addressViewOnClick:(NBPayAddressView *)addressView
{
    //如果账号地址条数为0则跳转到创建
    if ([NBAccountTool account] && [NBAccountTool account].addresses.count == 0) {
        [self.navigationController pushViewController:[[NBAddressEditViewController alloc] initWithType:NBAddressEditViewControllerTypeAdd] animated:YES];
    }else
    {
        [self.navigationController pushViewController:[[NBAddressViewController alloc] initWithType:NBAddressViewControllerTypePay] animated:YES];
    }
}
/**
 *  商家按钮点击事件处理
 */
- (void)merchantCellOnClick:(NBPayMerchantCell *)merchantCell
{
    NBMerchantDetailViewController *merchantVc = [[NBMerchantDetailViewController alloc] initWithMerchantID:[NBMerchantTool currentMerchantID]];
    [self.navigationController pushViewController:merchantVc animated:YES];
}
/**
 *  确认支付按钮事件处理
 */
- (void)confirmPayBtnOnClick:(UIButton *)button
{
    
    [SVProgressHUD show];
    if (_addressView.item == nil && [NBMerchantTool currentTableCode] == nil) { // 如果地址为空
        [SVProgressHUD showErrorWithStatus:@"请选择配送地址"];
        return;
    }
    
    
    NBOrderJsonString *orderJsonString = [[NBOrderJsonString alloc] init];
    orderJsonString.money = [NSString stringWithFormat:@"%.2f",[NBCartTool originalPrice]];
    orderJsonString.orderstatus = NBOrderStatusTypeNotPay;
    orderJsonString.paytype = _payMethodView.payMethodType;
    orderJsonString.businessid = [NBMerchantTool currentMerchant].businessid;
    orderJsonString.businessname = [NBMerchantTool currentMerchant].name;
    orderJsonString.userid = [NBAccountTool userId];
    orderJsonString.addressid = _addressView.item.addressID;
    orderJsonString.picurl = [NBMerchantTool currentMerchant].pictureuri;
    orderJsonString.addresstype = [NBMerchantTool currentTableCode]?NBAddressTypeInShop:NBAddressTypeTakeOut;
    
    NSDictionary *dict = [orderJsonString keyValues];
    NSString *orderJsonStr = [dict JSONString];
    
    NSMutableArray *orderDetailArrayM = [[NSMutableArray alloc] init];
    for (NBDishModel *dish in [NBCartTool dishes]) {
        NBOrderDetailJsonString *orderDetailDish = [[NBOrderDetailJsonString alloc] init];
        orderDetailDish.dishid = dish.dishID;
        orderDetailDish.unitprice = [NSString stringWithFormat:@"%.2f",dish.price];
        orderDetailDish.dishtype = dish.type;
        orderDetailDish.dishnum = dish.amount;
        orderDetailDish.dishname = dish.name;
        
        [orderDetailArrayM addObject:orderDetailDish];
    }
    
    // 模型数组转字典数组
    NSArray *orderArray = [NSMutableArray keyValuesArrayWithObjectArray:orderDetailArrayM];
    NSString *orderDetailListJsonStr = [orderArray JSONString];
    
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.orderJsonString = orderJsonStr;
    param.orderDetailListJsonString = orderDetailListJsonStr;
    param.addressdetail = [NBMerchantTool currentTableCode];
    
    // 提交订单
    [NBPayHttpTool submitOrderWithParam:param success:^(NBPayResponseModel *result) {
        if (result.code == 0) {
            _orderID = result.order.orderID;
            if (_payMethodView.payMethodType == NBPayMethodTypeAlipay) {
                [SVProgressHUD dismiss];
                [self payByAlipay];
            }
            else if (_payMethodView.payMethodType == NBPayMethodTypeWechat)
            {
                [SVProgressHUD dismiss];
                [self payByWechatWithPrepayOrderID:result.order.prepayid];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络异常,请检查网络"];
    }];
}

- (void)payByAlipay
{
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_PARTNER;
    order.seller = ALIPAY_SELLER;
    order.tradeNO = _orderID; //订单ID（由商家自行制定）
    order.productName = [NBMerchantTool currentMerchant].name; //商品标题
    order.productDescription = [NBMerchantTool currentMerchant].name; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",_totalPriceCell.discountPrice != 0.0?_totalPriceCell.discountPrice:_totalPriceCell.price]; //商品价格
//    order.amount = @"0.01"; //商品价格
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
        [NBCartTool emptyShoppingCart];
        [self pushToOrderDetail];

    }];
}

- (void)payByWechatWithPrepayOrderID:(NSString *)prepayOrderID
{
    // 时间戳
    self.timeStamp = [self getCurrentTimeStamp];
    PayReq *request = [[PayReq alloc] init];
    
    request.openID = WECHAT_KEY;
    request.partnerId = PARTNER_ID;
    request.prepayId = prepayOrderID;
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

- (void)pushToOrderDetail
{
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
        NBOrderDetailViewController *orderDetailVc = [[NBOrderDetailViewController alloc] initWithOrderID:_orderID];
        orderDetailVc.hidesBottomBarWhenPushed = YES;
        NBNavigationController *currentNavigationVc = (NBNavigationController *)self.navigationController;
        [currentNavigationVc popToRootViewControllerAnimated:NO];
        // 前往
        [currentNavigationVc pushViewController:orderDetailVc animated:YES];
    });
    
}

- (void)popToOrderList
{
    [self.navigationController popViewControllerAnimated:NO];
    //    NBMainViewController *mainVc = (NBMainViewController *)[NBCommon rootNavigationController].topViewController;
    //    mainVc.selectedIndex = 1;
}

#pragma mark - Tool
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
@end
