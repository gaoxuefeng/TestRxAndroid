//
//  NBOrderViewController.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBOrderViewController.h"
#import "NBOrderCell.h"
#import "NBOrderDetailViewController.h"
#import "NBOrderHttpTool.h"
#import "NBOrderList.h"
#import "NBAccountTool.h"
#import <MJRefresh.h>
@interface NBOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, weak) NBOrderList *orderList;
/**
 *  订单数组
 */
@property(nonatomic, strong) NSMutableArray *orderArray;

@property(nonatomic, assign) int currentPage;
@property(nonatomic, weak) UIView *noOrderWarning;
@end

@implementation NBOrderViewController
#pragma mark - Lazy Load
- (NSMutableArray *)orderArray
{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

- (NBOrderList *)orderList
{
    if (!_orderList) {
        NBOrderList *orderList = [[NBOrderList alloc] init];
        orderList.backgroundColor = [UIColor clearColor];
        _orderList = orderList;
        orderList.dataSource = self;
        orderList.delegate = self;
        [self.view addSubview:orderList];
        [orderList autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [orderList addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewOrderesData)];
    }
    return _orderList;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加无订单提示
    [self addNoOrderWarning];
    _currentPage = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChanged:) name:ORDER_STATUS_CHANGED object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 如果未登录 则不加载列表 直接return
    if ([NBAccountTool userToken] == nil || [NBAccountTool userToken].length == 0) {
        return;
    }
    // 如果无订单 则隐藏无订单
    if (self.orderArray == nil || self.orderArray.count == 0) {
        [SVProgressHUD show];
//        _noOrderWarning.hidden = NO;
    }
    _noOrderWarning.hidden = YES;
    [self getNewOrderesData];
    if (![NBAccountTool userToken]) {
        _orderList.backgroundView.hidden = NO;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Private Methods
- (void)addNoOrderWarning
{
    // 无订单提示
    UIView *bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    
    CGFloat bgViewW = SCREEN_WIDTH;
    CGFloat bgViewH = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT;
    CGFloat bgViewX = 0;
    CGFloat bgViewY = STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT;
    bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    
    UIImageView *noOrderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_empty"]];
    [bgView addSubview:noOrderImageView];
    [noOrderImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [noOrderImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:AUTOLENGTH(90.f)];
    UILabel *noOrderWarning = [[UILabel alloc] init];
    [bgView addSubview:noOrderWarning];
    noOrderWarning.textAlignment = NSTextAlignmentCenter;
    noOrderWarning.text = @"现在还没有订单,赶紧点一份!";
    noOrderWarning.font = [UIFont systemFontOfSize:15.f];
    noOrderWarning.textColor = HEX_COLOR(0xc0c0c0);
    [noOrderWarning autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [noOrderWarning autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:noOrderImageView withOffset:AUTOLENGTH(60.f)];
    _noOrderWarning = bgView;
//    bgView.hidden = YES;
}

#pragma mark - Load data
/**
 *  获取最新的20条订单数据
 */

- (void)loadData
{
    [super loadData];
    [self getNewOrderesData];
}

- (void)getNewOrderesData
{
    [super loadData];
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.page = @1;
    [NBOrderHttpTool getAllOrderesWithParam:param success:^(NBOrderResponseModel *result) {
        [SVProgressHUD dismiss];
        [self.orderList.header endRefreshing];
        if (result.code == 0) {
            NSMutableArray *newDatas = result.data;
            NSMutableArray *tempDatas = [newDatas mutableCopy];
            
            if (self.orderArray.count > 0) { // 如果已经有值 则判断是否有重复数据
                for (NBOrderModel *tempData in tempDatas) {
                    for (NBOrderModel *data in self.orderArray) {
                        if ([data.orderID isEqualToString:tempData.orderID]) {
                            [newDatas removeObject:tempData];
                        }
                    }
                }
                
            }else // 返回0个
            {
                if (result.data.count == 0) {
                    _noOrderWarning.hidden = NO;
                }else
                {
                    _noOrderWarning.hidden = YES;
                }
                
            }
            NSRange range = NSMakeRange(0, newDatas.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.orderArray insertObjects:newDatas atIndexes:indexSet];
            [self.orderList reloadData];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if (_orderArray.count > 10) {
                    // 添加上拉加载更多
                    [_orderList addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreOrdersData)];
                }
            });
        }
    } failure:^(NSError *error) {
        [self showNetInstabilityView];
        [SVProgressHUD dismiss];
        [_orderList.header endRefreshing];
        NBLog(@"%@",error);
    }];
}

/**
 *  获取更多的20条订单数据
 */
- (void)getMoreOrdersData
{
    [super loadData];
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.page = [NSNumber numberWithInteger:_currentPage + 1];
    [NBOrderHttpTool getAllOrderesWithParam:param success:^(NBOrderResponseModel *result) {
        [_orderList.legendFooter endRefreshing];
        if (result.code == 0) {
            if (result.data.count == 0) { // 返回的数组长度为0,说明服务器已无数据
                [_orderList.legendFooter noticeNoMoreData];
                
                [_orderList reloadData];
            }else
            {
                _currentPage ++;
                [self.orderArray addObjectsFromArray:result.data];
                [_orderList reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self showNetInstabilityView];
        [_orderList.legendFooter endRefreshing];
        NBLog(@"%@",error);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_orderArray == nil) return 0;
    _orderList.backgroundView.hidden = _orderArray.count;
    
    return _orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBOrderCell *cell = [NBOrderCell cellWithTableView:tableView];
    NBOrderModel *item = _orderArray[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBOrderModel *order = _orderArray[indexPath.row];
    NBOrderDetailViewController *orderDetailVc = [[NBOrderDetailViewController alloc] initWithOrderID:order.orderID];
    orderDetailVc.statusChangeBlock = ^(NBOrderStatusType status){
        order.status = status;
    };
    
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}


#pragma mark - Action
- (void)orderStatusChanged:(NSNotification *)notification
{
    NBOrderModel *order = (NBOrderModel *)notification.userInfo[@"order"];
    for (NBOrderModel *orderModel in self.orderArray) {
        if ([orderModel.orderID isEqualToString:order.orderID]) {
            orderModel.status = order.status;
        }
        if (self.isViewLoaded) {
            [self.orderList reloadData];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ORDER_STATUS_CHANGED object:nil];
}

@end
