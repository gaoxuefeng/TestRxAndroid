//
//  CSKTVPayViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVPayViewController.h"
#import "CSToPayBar.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSOrderPayAddressCell.h"
#import "CSOrderInfoView.h"
#import "CSOrderPayMethodCell.h"
#import "CSInRoomViewController.h"
#import "CSKTVBookingOrder.h"
#import "CSPayTool.h"
#import "CSOrderDishHttpTool.h"
#import "CSMyCostViewController.h"
#import "SVProgressHUD.h"
#import "CSMyCostViewController.h"
#import "CSInRoomViewController.h"
#import "CSAlterTabBarTool.h"
#import "CSLoginHttpTool.h"
#import "CSRoomUpdateTool.h"



@interface CSKTVPayViewController ()<UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    CSToPayBar *_toPayBar;
}
@property(nonatomic, weak) CSOrderInfoView *orderInfoView;
@property(nonatomic, weak) CSOrderPayMethodCell *payMethodCell;
@property(nonatomic, weak) CSOrderPayAddressCell *addressCell;
@end

@implementation CSKTVPayViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单支付";
    [self setupSubView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromWechat:) name:BACK_FROM_WECHAT object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [super viewWillDisappear:animated] ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_FROM_WECHAT object:nil];
}

#pragma mark - Setup
- (void)setupSubView
{
    [self setupAddressView];
    [self setupToPayBar];
    [self setupPayMethodView];
    [self setupScrollView];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"song_playing" ofType:@"gif"];
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:path]];
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//    imageView.animatedImage = image;
//    imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
//    [self.view addSubview:imageView];
}

- (void)setupAddressView
{
    // 联系方式
    CSOrderPayAddressCell *addressCell = [[CSOrderPayAddressCell alloc] initWithType:CSOrderPayAddressCellTypeReserve];
    [self.view addSubview:addressCell];
    addressCell.backgroundColor =WhiteColor_Alpha_4;
    _addressCell = addressCell;
    [addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(addressCell.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(37.0));
    }];

}

- (void)setupPayMethodView
{
    // 支付方式
    CSOrderPayMethodCell *payMethodCell = [[CSOrderPayMethodCell alloc] init];
    [self.view addSubview:payMethodCell];
    payMethodCell.backgroundColor = [UIColor clearColor];
    _payMethodCell = payMethodCell;
    
    [payMethodCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(payMethodCell.superview);
        make.bottom.equalTo(_toPayBar.mas_top);
    }];
}

- (void)setupToPayBar
{
    _toPayBar = [[CSToPayBar alloc] init];
    [_toPayBar payButtonAddTarget:self action:@selector(payBtnOnClick)];
    [self.view addSubview:_toPayBar];
    [_toPayBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_toPayBar.superview);
        make.height.mas_equalTo(45.0);
    }];
    _toPayBar.payButtonTitle = @"立即支付";
    _toPayBar.cartShowing = YES;
    
    
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];

    CGFloat margin = TRANSFER_SIZE(11.0);
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView.superview);
        make.bottom.equalTo(_payMethodCell.mas_top).offset(-margin);
        make.top.equalTo(_addressCell.mas_bottom).offset(margin);
    }];
    
    UIView *container = [[UIView alloc] init];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView.mas_width);
    }];
    
    
    
    // 订单详情
    CSOrderInfoView *orderInfoView = [[CSOrderInfoView alloc] init];
    [container addSubview:orderInfoView];
    _orderInfoView = orderInfoView;
    
    
    [orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(addressCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
//        make.left.right.equalTo(orderInfoView.superview);
        make.edges.equalTo(orderInfoView.superview);
    }];
}

#pragma mark - Action
- (void)payBtnOnClick
{
//    [SVProgressHUD show];
    if (_payMethodCell.payType == CSPayMethodTypeAlipay) {
        [CSPayTool alipayWithOrderId:_order.reserveBoxId productName:_order.KTVName productDescription:_order.boxTypeName price:[_order.price stringValue] callBack:^(NSDictionary *resultDic) {
            int code = [resultDic[@"resultStatus"] intValue];
            switch (code) {
                case 9000:  {// 成功
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self pushToRoomVc];
                    });
                    break;
                }
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
        param.reserveBoxId = _order.reserveBoxId;
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

- (void)backBtnOnClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单还未支付,确定离开?" message:@"10分钟后未支付订单将自动取消" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

#pragma mark - Notification Events
- (void)backFromWechat:(NSNotification *)notification
{
    int code = [notification.userInfo[@"errCode"] intValue];
    switch (code) {
        case 0:
        {// 成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pushToRoomVc];
            });
            break;
        }
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (self.isRepay) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        // TODO
        // 将tabbar的index = 1设为房间
        // 切换到index = 1
        
        
//        BOOL animated = NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1?NO:YES;
//        UINavigationController *navVc = self.navigationController;
//        [self.navigationController popToRootViewControllerAnimated:animated];
        [self.navigationController popViewControllerAnimated:YES];
//        [navVc pushViewController:[[CSMyCostViewController alloc] init] animated:animated];
    }
}

#pragma mark - Load Data
- (void)loadData
{
    _orderInfoView.item = _order;
    [_toPayBar setPrice:[_order.price floatValue]];
}

#pragma mark - Private Methods
- (void)pushToViewController:(UIViewController *)viewController
{
    BOOL animated = NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1?NO:YES;
    UINavigationController *navVc = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:animated];
    [navVc pushViewController:viewController animated:animated];
}

// 支付成功跳到我的房间页
- (void)pushToRoomVc
{
    [SVProgressHUD show];
    CSRequest *param = [[CSRequest alloc] init];
    [CSLoginHttpTool getUserInfoWithParam:param success:^(CSUserDataWrapperModel *result) {
        if (result.code == ResponseStateSuccess) {
            
            if (result.data.myrooms.count == 0) {
                [self pushToRoomVc];
                return;
            }
            
            [SVProgressHUD dismiss];
            [GlobalVar sharedSingleton].myRooms = result.data.myrooms;
            
            // 增加定时器
            [[CSRoomUpdateTool sharedSingleton] resetTimers];
            for (CSMyRoomInfoModel *roomInfo in GlobalObj.myRooms) {
                if (roomInfo.starting) continue;
                if (roomInfo.starting) // 如果已经开始 则增加房间结束定时器
                {
                    if (roomInfo.rbEndTime.length > 0 && roomInfo.serverTimeStamp.length > 0) {
                        NSTimeInterval seconds = roomInfo.rbEndTime.doubleValue - roomInfo.serverTimeStamp.doubleValue;
                        [[CSRoomUpdateTool sharedSingleton] addTimerAfterTimeInterval:seconds];
                    }
                }else // 否则增加房间开始定时器
                {
                    if (roomInfo.rbStartTime.length > 0 && roomInfo.serverTimeStamp.length > 0) {
                        NSTimeInterval seconds = roomInfo.rbStartTime.doubleValue - roomInfo.serverTimeStamp.doubleValue;
                        [[CSRoomUpdateTool sharedSingleton] addTimerAfterTimeInterval:seconds];
                    }
                }

            }
            [self.navigationController popToRootViewControllerAnimated:NO];
            CATransition *ca = [CATransition animation];
            ca.type = @"push";
            ca.subtype = kCATransitionFromRight;
            ca.duration = 0.3;
            GlobalObj.selectedId = [result.data.myrooms.firstObject reserveBoxId];
            UITabBarController *tabBarVc = GlobalObj.tabBarController;
            [CSAlterTabBarTool alterTabBarToRoomController];
            tabBarVc.selectedIndex = 1;
            [tabBarVc.view.layer addAnimation:ca forKey:nil];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        //        CSLog(@"%@",error);
    }];
    
}


@end
