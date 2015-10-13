//
//  AppDelegate.m
//  CloudSong
//
//  Created by youmingtaizi on 15/4/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "CSDefine.h"
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialData.h>
#import <UMSocialSnsService.h>
#import <APService.h>
#import <BaiduMapAPI/BMapKit.h>
#import <SDWebImageManager.h>
#import "CSLoginHttpTool.h"
#import "SVProgressHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "CSNavigationController.h"
#import "CSAlterTabBarTool.h"
#import "CSActivityModel.h"
#import "CSLocationService.h"
#import <MobClick.h>
#import "CSBookingRoomViewController.h"
#import "CSInRoomViewController.h"
#import "CSRoomUpdateTool.h"
#import "CSLaunchWindow.h"

@interface AppDelegate () <BMKGeneralDelegate,WXApiDelegate,UITabBarControllerDelegate,CSLocationServiceDelegate> {
    BMKMapManager*  _mapManager;
}
@property(nonatomic, assign, getter=isReachable) BOOL reachable;
@property(strong, nonatomic) CSLaunchWindow *launchWindow;
@property(nonatomic, assign, getter=isGetUserInfo) BOOL getUserInfo;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@ %@", userAgent, @"ethank-browser-iOS"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
    _reachable = YES;
    // TODO iOS7设备上，在Storyboard里面设置tabbar image时，只显示灰色图片
//    NSArray *tabImages = @[@"ic_reserve", @"ic_sing", @"ic_remote-control", @"ic_find", @"ic_me"];
//    NSArray *tabSelectedImages = @[@"ic_reserve_h", @"ic_sing_h", @"ic_remote-control_h", @"ic_find_h", @"ic_me_h"];
    //活动页需要 ,勿删
    [self setBackGroundImage];
    _launchWindow = [[CSLaunchWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _launchWindow.finishBlock = ^(BOOL finished){
        _launchWindow = nil;
    };
 
    NSArray *tabImages = @[@"tabbar_home_normal",
                           @"tabbar_reserve_normal",
                           @"tabbar_activity_normal",
                           @"tabbar_find_normal",
                           @"tabbar_mine_normal",
                           @"tabbar_room_normal"] ;
    
    NSArray *tabSelectedImages = @[@"tabbar_home_press",
                                   @"tabbar_reserve_press",
                                   @"tabbar_activity_press",
                                   @"tabbar_find_press",
                                   @"tabbar_mine_press",
                                   @"tabbar_room_press"] ;
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    GlobalObj.tabBarController = tabBarController;
    tabBarController.delegate=self;
    UITabBar *tabBar = tabBarController.tabBar;
    tabBarController.tabBar.barTintColor = [HEX_COLOR(0x1b082e) colorWithAlphaComponent:0.95];
    int i = 0;
    for (UITabBarItem *firstTab in tabBar.items) {
        firstTab.image = [[UIImage imageNamed:tabImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        firstTab.selectedImage = [[UIImage imageNamed:tabSelectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ++ i;
    }
//    
//    CSLaunchWindow *launchWindow = [[CSLaunchWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [tabBarController.view addSubview:launchWindow];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    // 友盟统计
    [MobClick startWithAppkey:UmengAppkey reportPolicy:BATCH   channelId:@"App Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104800854" appKey:@"dGgt1i4iyuhPaHhi" url:@"http://ethank.com.cn/"];

    //打开新浪微博的SSO开关
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx0975dfb9e6a3d9f1" appSecret:@"19ea70ea651daa2a0c88a9180a119ef4" url:@"http://www.umeng.com/social"];//http://www.ethank.com.cn
    
    // 集成极光推送
    [self setupAPNs:launchOptions];
//    NSLog(@"%@",[APService registrationID]);
    
    //向微信注册
    [WXApi registerApp:@"wx0975dfb9e6a3d9f1" withDescription:@"潮趴汇 1.0"];
    //百度地图
    _mapManager = [[BMKMapManager alloc] init];
    if (![_mapManager start:@"jC4QboIgd1np0vmocUBlDYdq"  generalDelegate:self])
        CSLog(@"manager start failed!");
    
    // 网络监听
    [self listenReachability];
    
    // 设置SVProgressHUD
    [self setupSVProgressHUDType];

    [self updateUserInfo];
    
//    NSLog(@"%@",[APService registrationID]);
    
//    if ([launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"userInfo = %@",[launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]]];
//        });
//    }
    if (launchOptions) { //launchOptions is not nil
        NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if ([userInfo[@"yunge"] isEqualToString:@"clearRoom"])
        {
            [CSAlterTabBarTool alterTabBarToKtvBookingController];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService resetBadge];
    return YES;
}

#pragma mark   tabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case 0:
            [MobClick event:@"TabHome"];
            break;
        case 1:
        {
            CSNavigationController *navVc = (CSNavigationController *)viewController;
            if ([navVc.topViewController isKindOfClass:[CSBookingRoomViewController class]]) {
                [MobClick event:@"TabReserve"];
            }else if ([navVc.topViewController isKindOfClass:[CSInRoomViewController class]])
            {
                [MobClick event:@"Room"];
            }
                break;
        }
        case 2:
            [MobClick event:@"TabActivity"];
            break;
        case 3:
            [MobClick event:@"TabDiscovery"];
            break;
        case 4:
            [MobClick event:@"TabMine"];
            break;
        default:
            break;
    }
    if (tabBarController.selectedIndex!=2) {
        GlobalObj.cityView.hidden=YES;
    }else{
        GlobalObj.cityView.hidden=NO;
    }
}

- (void)setBackGroundImage{
    NSString *imageName = nil;
    if (iPhone4) {
        imageName = @"base_bg_4";
    }else if (iPhone5)
    {
        imageName = @"base_bg_5";
    }else if (iPhone6)
    {
        imageName = @"base_bg_6";
    }else if (iPhone6Plus)
    {
        imageName = @"base_bg_6p";
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.window addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgroundImageView.superview);
    }];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService resetBadge];
    if (application.applicationState == UIApplicationStateInactive) {
        [self getPushNotificationWithUserInfo:userInfo];
    }else
    {
        [self getPushNotificationWithUserInfo:userInfo];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    
//    [_launchWindow clearupAllAnimationLayer] ;
//    _launchWindow = nil ;

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCityName:) name:@"ChangeCityName" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"becomeActive" object:self];
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {// 从支付宝跳转回来
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            CSLog(@"result = %@",resultDic);
        }];
    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) { // 从微信跳转回来
        return [WXApi handleOpenURL:url delegate:self];
    }else
    {
        return [UMSocialSnsService handleOpenURL:url];
    }
    return YES;
}
/** 微信跳转回调 */
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        CSLog(@"errCode = %d",resp.errCode);
        [[NSNotificationCenter defaultCenter] postNotificationName:BACK_FROM_WECHAT object:nil userInfo:@{@"errCode":[NSNumber numberWithInt:resp.errCode]}];
      }
    if (resp.errCode == 0) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"分享失败"];
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

#pragma mark - BMKGeneralDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
//        NSLog(@"联网成功");
        [[CSLocationService sharedInstance] addDelegate:self];
        [[CSLocationService sharedInstance] startGetLocation];
    }
    else{
//        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
//        NSLog(@"授权成功");
    }
    else {
//        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)updateUserInfo
{
    if ([GlobalVar sharedSingleton].token.length > 0) {
        CSRequest *param = [[CSRequest alloc] init];
        [CSLoginHttpTool getUserInfoWithParam:param success:^(CSUserDataWrapperModel *result) {
            if (result.code == ResponseStateSuccess) {
                _getUserInfo = YES;
                GlobalObj.userInfo = result.data.userInfo;
                GlobalObj.myRooms = result.data.myrooms;
                GlobalObj.selectedId = GlobalObj.selectedId;
                if (GlobalObj.myRooms.count > 0) {
                    // 增加定时器
                    [[CSRoomUpdateTool sharedSingleton] resetTimers];
                    for (CSMyRoomInfoModel *roomInfo in GlobalObj.myRooms) {
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
                    [CSAlterTabBarTool alterTabBarToRoomController];
                }else
                {
                    [CSAlterTabBarTool alterTabBarToKtvBookingController];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATED object:nil];
            }
        } failure:^(NSError *error) {
        CSLog(@"%@",error);
        }];
    }
}

- (void)setupSVProgressHUDType
{
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
}

#pragma mark - 推送消息处理
- (void)getPushNotificationWithUserInfo:(NSDictionary *)userInfo
{
    CSLog(@"pushDic = %@",userInfo);
    if (userInfo[@"nextSong"]) {// 切歌
        [[NSNotificationCenter defaultCenter] postNotificationName:SONGS_STATUS_CHANGED object:userInfo];
    }else if(userInfo[@"singing"]) // 则该推送是用于更新谁在唱
    {
    }else if (userInfo[@"yunge"])
    {
        NSString *string = userInfo[@"yunge"];
        
        if ([string isEqualToString:@"roomJoin"]) // 更新房间打开
        {
            [self updateUserInfo];
        }else if ([string isEqualToString:@"clearRoom"])
        {
            [self updateUserInfo];
            
        }else if ([string isEqualToString:@"roomOpen"])
        {
            [self updateUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_ROOM_UPDATED object:nil];
        }
        else if ([string isEqualToString:@"changeSong"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:SONGS_STATUS_CHANGED object:nil];
        }else if ([string isEqualToString:@"roomDynamic"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ROOM_STATUS_CHANGED object:nil];
        }
    }
}

#pragma mark - CSLocationServiceDelegate
- (void)locationService:(CSLocationService *)svc didGetCoordinate:(CLLocationCoordinate2D)coordinate {
    GlobalObj.longitude = coordinate.longitude;
    GlobalObj.latitude = coordinate.latitude;
    [[CSLocationService sharedInstance] getCityWithCoordinate:coordinate];
}

- (void)locationService:(CSLocationService *)svc didLocationInCity:(NSString *)city {
    GlobalObj.locationCity = city;
    GlobalObj.currentCity = city;
}


#pragma mark - 网络监听
- (void)listenReachability
{
    // Allocate a reachability object
    _reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    // Set the blocks
    
    __weak typeof(self) weakSelf = self;
    
    weakSelf.reach.reachableBlock = ^(Reachability *reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_reachable) {
                _reachable = YES;
                if (_getUserInfo == NO) {
                    [self updateUserInfo];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NET_WORK_REACHABILITY object:nil];
            }

        });
    };
    weakSelf.reach.unreachableBlock = ^(Reachability *reach)
    {
        if (_reachable) {
            _reachable = NO;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
//            });
        }
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [_reach startNotifier];
}


@end
