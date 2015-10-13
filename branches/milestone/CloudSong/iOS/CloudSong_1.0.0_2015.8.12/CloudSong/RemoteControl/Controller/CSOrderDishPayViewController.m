//
//  CSOrderDishPayViewController.m
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderDishPayViewController.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSOrderPayAddressCell.h"
#import "CSOrderDishPayDishListCell.h"
#import "CSOrderPayMethodCell.h"
#import "CSDishCartTool.h"
#import "CSToPayBar.h"
#import "CSDishCartTool.h"
#import "CSPayTool.h"
#import "CSOrderDishHttpTool.h"
#import "SVProgressHUD.h"
#import "CSMyCostViewController.h"
#import <MobClick.h>
@interface CSOrderDishPayViewController ()<UIAlertViewDelegate>
/** 支付Bar */
@property(nonatomic, weak) CSToPayBar *toPayBar;
/** 菜品列表 */
@property(nonatomic, weak) CSOrderDishPayDishListCell *dishListCell;
/** 支付方式栏 */
@property(nonatomic, weak) CSOrderPayMethodCell *payMethodCell;

@property(nonatomic, weak) CSOrderPayAddressCell *addressCell;
@end

@implementation CSOrderDishPayViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单支付";
    [self setupSubViews];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromWechat:) name:BACK_FROM_WECHAT object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_FROM_WECHAT object:nil];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setuptoPayBar];
    
    [self setupPayMethodView];
    
    [self setupAddressCell];
    
    [self setupScrollView];
}

- (void)setuptoPayBar
{
    CSToPayBar *toPayBar = [[CSToPayBar alloc] init];
    [toPayBar payButtonAddTarget:self action:@selector(payBtnOnClick)];
    [self.view addSubview:toPayBar];
    [toPayBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TRANSFER_SIZE(44.0));
    }];
    _toPayBar = toPayBar;
    toPayBar.payButtonTitle = @"立即支付";
    toPayBar.cartShowing = YES;
}

- (void)setupPayMethodView
{
    // 支付方式
    CSOrderPayMethodCell *payMethodCell = [[CSOrderPayMethodCell alloc] init];
    [self.view addSubview:payMethodCell];
    _payMethodCell = payMethodCell;


    [payMethodCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(payMethodCell.superview);
        make.bottom.equalTo(_toPayBar.mas_top).offset(-TRANSFER_SIZE(10.0));
    }];
}

- (void)setupAddressCell
{
    // 地址
    CSOrderPayAddressCell *addressCell = [[CSOrderPayAddressCell alloc] init];
    [self.view addSubview:addressCell];
    _addressCell = addressCell;
    
    [addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(addressCell.superview);
    }];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView.superview);
        make.top.equalTo(_addressCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.bottom.equalTo(_payMethodCell.mas_top).offset(TRANSFER_SIZE(10.0));
    }];
    
    UIView *container = [[UIView alloc] init];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView.mas_width);
    }];
    
    // 菜品列表
    CSOrderDishPayDishListCell *dishListCell = [[CSOrderDishPayDishListCell alloc] init];
    [container addSubview:dishListCell];
    _dishListCell = dishListCell;
    
    [dishListCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(dishListCell.superview);
    }];
}



#pragma mark - Load Data
- (void)loadData
{
    [_toPayBar setPrice:[_data.sumPrice floatValue]];
    _dishListCell.items = _data.goodsList;
    _addressCell.address = _data.roomName;
}

#pragma mark - Touch Events


- (void)payBtnOnClick
{
//    [SVProgressHUD show];
    [MobClick event:@"RoomSuperMarketPay"];
    if (_payMethodCell.payType == CSPayMethodTypeAlipay) {
        [CSPayTool alipayWithOrderId:_data.reserveGoodsId productName:@"酒水订单" productDescription:@"酒水订单" price:[_data.sumPrice stringValue] callBack:^(NSDictionary *resultDic) {
            
            int code = [resultDic[@"resultStatus"] intValue];
            switch (code) {
                case 9000: // 支付成功
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    [self pushToRoomVc];
                    break;
                case 8000: // 正在处理中
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"正在处理中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    break;
                }
                case 4000: // 订单支付失败
                case 6001: // 用户中途取消
                case 6002: // 网络连接错误
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    break;
                }
                default:
                    break;
            }
        }];
    }else
    {
        // 微信支付  获取预备单号
        CSRequest *param = [[CSRequest alloc] init];
        param.reserveBoxId = _data.reserveGoodsId;
        [CSOrderDishHttpTool getWechatPrepayIDWithParam:param success:^(CSGetPrepayIdResponseModel *result) {
            if (result.code == ResponseStateSuccess) {
                [SVProgressHUD dismiss];
                [CSPayTool wechatPayWithPrepayOrderID:result.data.preOrderId];
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
        } failure:^(NSError *error) {
            CSLog(@"%@",error);
        }];
    }
}


#pragma mark - Notification Events
- (void)backFromWechat:(NSNotification *)notification
{
    int code = [notification.userInfo[@"errCode"] intValue];
    switch (code) {
        case 0: // 成功
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [self pushToRoomVc];
            break;
        case -1: // 错误
        case -2: // 用户取消
        default:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
    }
    
}


#pragma mark - Inherit
- (void)backBtnOnClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单还未支付,确定离开?" message:@"10分钟后未支付订单将自动取消" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private
- (void)pushToRoomVc
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
    
}

@end
