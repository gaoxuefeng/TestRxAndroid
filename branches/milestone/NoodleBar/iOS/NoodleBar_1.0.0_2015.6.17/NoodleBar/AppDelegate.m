//
//  AppDelegate.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "AppDelegate.h"
#import <BMapKit.h>
#import "APService.h"
#import "NBCommon.h"
#import "NBAccountTool.h"
#import "NBLoginHttpTool.h"
#import "NBOrderModel.h"
#import <MobClick.h>
#import "WXApi.h"
#import <SDWebImageManager.h>
#import <AlipaySDK/AlipaySDK.h>
//#import "NBOrderDetailViewController.h"
@interface AppDelegate ()<WXApiDelegate>
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册百度地图
    [self setupBaiduMap];
    // 集成极光推送
    [self setupAPNs:launchOptions];
    // 加载用户数据
    [self loadUserData];
    // 注册微信支付
    [WXApi registerApp:WECHAT_KEY withDescription:@"NoodleBar"];
    // 集成友盟统计
    [self setupAnalytics];
    
    [self setupSVProgressHUDType];

    NBLog(@"%@",[APService registrationID]);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService resetBadge];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService resetBadge];
    // IOS 7 Support Required
    UIApplicationState appStatus = application.applicationState;
    NBLog(@"%@",userInfo);
    
    if (!userInfo[@"orderid"]) return;
    NBOrderModel *orderModel = [[NBOrderModel alloc] init];
    orderModel.orderID = userInfo[@"orderid"];
    orderModel.status = [userInfo[@"orderstatus"] intValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_STATUS_CHANGED object:nil userInfo:@{@"order":orderModel}];
    

    switch (appStatus) {
        case UIApplicationStateActive:
            //            NBLog(@"UIApplicationStateActive"); // 前台收到消息
            if (orderModel.status == NBOrderStatusTypeInMaking) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单状态" message:[NSString stringWithFormat:@"单号%@的菜品已在制作中",orderModel.orderID] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
            }else if (orderModel.status == NBOrderStatusTypeWaitingForTaking){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单状态" message:[NSString stringWithFormat:@"单号%@的菜品已制作完毕",orderModel.orderID] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        case UIApplicationStateInactive: // 点击通知进入应用
            //            [self showOrder:userInfo[@"orderid"]];
            //            [SVProgressHUD showInfoWithStatus:@"点击通知进入应用"];
            //            NBLog(@"UIApplicationStateInactive");
            break;
        case UIApplicationStateBackground:
            
            //            NBLog(@"UIApplicationStateBackground");
            break;
            
        default:
            break;
    }
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService resetBadge];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清除所有图片内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 停止长在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {// 从支付宝跳转回来
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NBLog(@"result = %@",resultDic);
        }];
    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) { // 从微信跳转回来
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (void)onResp:(BaseResp *)resp
{
//    NBLog(@"%@",resp);
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_BE_PAY object:nil];
                break;
            default:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:BACK_FROM_WECHAT_WITH_NO_PAY object:nil];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                break;
            }
        }
    }
}


#pragma mark - Private Methods
- (void)setupBaiduMap
{
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY generalDelegate:nil];
    if (!ret) {
        NBLog(@"manager start failed!");
    }
}

/** 加载用户数据 */
- (void)loadUserData
{
    if ([NBAccountTool userToken] && ![NBAccountTool account]) { // 有缓存的token但无账号实体,则请求实体
        NBRequestModel *param = [[NBRequestModel alloc] init];
        [NBLoginHttpTool getUserInfoWithParam:param success:^(NBAccountResponseModel *result) {
            if (result.code == 0) {
                [NBAccountTool setAccount:result.data.account];
                [NBAccountTool setAddresses:result.data.addresses];
                [NBAccountTool setUserId:result.data.account.userid];
            }
        } failure:^(NSError *error) {
            NBLog(@"%@",error);
        }];
    }
}

/**
 *  设置极光推送
 *
 *  @param launchOptions
 */
- (void)setupAPNs:(NSDictionary *)launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    //    [APService setLogOFF];
    //    [APService setDebugMode];
    
    [APService setupWithOption:launchOptions];
}

/**
 *  设置友盟统计
 */
- (void)setupAnalytics
{
    [MobClick startWithAppkey:UM_KEY reportPolicy:BATCH channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

/**
 *  设置遮罩样式
 */
- (void)setupSVProgressHUDType
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}



@end
