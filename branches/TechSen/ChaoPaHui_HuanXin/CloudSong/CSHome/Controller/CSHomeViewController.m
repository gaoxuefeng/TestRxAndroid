//
//  CSHomeViewController.m
//  CloudSong
//
//  Created by EThank on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSDefine.h"
#import "CSHomeActivityDetailController.h"
#import "CSLoginViewController.h"
#import "CSQRCodeReadViewController.h"
#import "SVProgressHUD.h"
#import <APService.h>
#import "CSDataService.h"
#import "CSHomeActivityListController.h"
#import "CSAlterTabBarTool.h"
#import <MJRefresh.h>
#import <MobClick.h>
#import "CSLoginHttpTool.h"
#import "CSUserDataWrapperModel.h"
#import "ActivityCell.h"
#import "CSDefine.h"
#import "CSHomeBannerView.h"
#import "CSHomeActivityView.h"
#import "CSLocationService.h"
#import "CSHomeBannerDetailController.h"
#import "CSHomeAdBannerModel.h"
#import <UIImageView+WebCache.h>

#define ITEM_SPACE          TRANSFER_SIZE(6)
#define LEFT_RIGHT_SPACE    TRANSFER_SIZE(5)


#define HEIGHT_WIDTH_RADIO (92.0/147.0) // 活动标签高宽比

#define CELL_ID         @"CSHomeCollectionCell"
#define HEADER_ID       @"Header"

#define Background_Color [UIColor colorWithRed:50/255.0 green:46/255.0 blue:82/255.0 alpha:1]
#define Banner_Pic_Height_Width_Radio  (321.0 / 930)  // 首页banner图高宽比

@interface CSHomeViewController () <CSQRCodeReadViewControllerDelegate,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    HomeActivityViewDelegate,
                                    CSLocationServiceDelegate,
                                    HomeBannerViewDelegate>

/** 记录collectionView上次滚动位置 */
@property (nonatomic, assign) int lastPostion_Y ;
@property (nonatomic, strong) NSMutableArray *homeActivities ;
@property (nonatomic, assign)NSInteger startIndex ;

@property (nonatomic, weak) UITableView      *tableView ;
@property (nonatomic, weak) CSHomeActivityView *activityView ;
@property (nonatomic, weak) CSHomeBannerView *bannerView ;
@property (nonatomic, strong) NSArray *adBanners ;
@property (nonatomic, strong) NSArray *activityTags ;

@property(assign, nonatomic) BOOL didSetupUI;

@end

@implementation CSHomeViewController

- (void)viewDidLoad{
    [super viewDidLoad] ;
    _startIndex = 0 ;
    _didSetupUI = NO;

}

#pragma mark - 懒加载
//- (NSMutableArray *)homeActivities{
//    if (_homeActivities == nil) {
//        _homeActivities = [NSMutableArray array] ;
//    }
//    return _homeActivities ;
//}
- (NSArray *)adBanners{
    if (_adBanners == nil) {
        _adBanners = [NSArray array] ;
    }
    return _adBanners ;
}
- (NSArray *)activityTags{
    if (_activityTags == nil) {
        _activityTags = [NSArray array] ;
    }
    return _activityTags ;
}
#pragma mark - 初始化页面
- (void)setupUI{
    
    if (_didSetupUI) return;
    _didSetupUI = YES;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49 - 64)] ;
//    tableView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(64), 0, 0, 0) ;
    
    tableView.backgroundColor = [UIColor clearColor ] ;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    tableView.delegate = self ;
    tableView.dataSource = self ;
    [self.view addSubview:tableView] ;
    self.tableView = tableView ;
    
    // 集成刷新控件
//    [self setupRefreshView] ;
    CGFloat padding = TRANSFER_SIZE(5) ;
    CGFloat tagCount = 4 ;
    CGFloat actTagViewW = (SCREENWIDTH - (padding * (tagCount + 1))) / tagCount ;
    CGFloat actTagViewH = actTagViewW * HEIGHT_WIDTH_RADIO ;
    
    CGFloat bannerViewH = (SCREENWIDTH * Banner_Pic_Height_Width_Radio) ;
    
    CGFloat headerContainerH = actTagViewH + bannerViewH + 3 * padding ;
    // 头部视图
    UIView *headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, headerContainerH)] ;
    // 滚动横幅
    CGFloat space = 5 ;
    CGFloat bannerViewW = SCREENWIDTH - 2 * space ;
    CSHomeBannerView *bannerView = [[CSHomeBannerView alloc] initWithFrame:CGRectMake(space, space, bannerViewW, bannerViewH)] ;
    bannerView.delegate = self ;
    [headerContainer addSubview:bannerView] ;
    self.bannerView = bannerView ;
    bannerView.imageURLs = self.adBanners ;
    // 添加头部视图
    self.tableView.tableHeaderView = headerContainer ;
    
    // 活动标签视图
    CSHomeActivityView *activityView = [[CSHomeActivityView alloc] initWithFrame:CGRectMake(0, bannerViewH + space, SCREENWIDTH, actTagViewH + 2*padding)] ;
    activityView.delegate = self ;
    [headerContainer addSubview:activityView] ;
    self.activityView = activityView ;
    
    // 顶部连接ktv按钮
    UIButton *linkKtvBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANSFER_SIZE(40), TRANSFER_SIZE(40))] ;
    [linkKtvBtn setImage:[UIImage imageNamed:@"home_link_ktv_icon"] forState:UIControlStateNormal] ;
    linkKtvBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30.0);
    [linkKtvBtn addTarget:self action:@selector(ktvBarItemClick) forControlEvents:UIControlEventTouchUpInside] ;
    UIBarButtonItem *ktvBarItem = [[UIBarButtonItem alloc] initWithCustomView:linkKtvBtn] ;
    self.navigationItem.rightBarButtonItem = ktvBarItem ;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView{
    WS(ws) ;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws GetHomeRecommendActivityData] ;
        [ws.tableView.footer endRefreshing] ;
       
    }] ;
}
#pragma mark - 活动列表请求
- (void)GetHomeRecommendActivityData{

    
    if (GlobalObj.latitude == 0.0 && GlobalObj.longitude == 0.0 && !GlobalObj.locationCity) {
        [[CSLocationService sharedInstance] addDelegate:self];
        [[CSLocationService sharedInstance]startGetLocation];
    }
    
    [[CSDataService sharedInstance] asyncGetHomeRecommendActivitiesWithStartIndex:[NSNumber numberWithInteger:_startIndex] handler:^(NSArray *activities) {
        if (activities.count) {
//            _startIndex += activities.count ;
            _homeActivities =[NSMutableArray array];
            [self.homeActivities addObjectsFromArray:activities] ;
            [self.tableView reloadData] ;
        }else{
            [self.tableView.footer noticeNoMoreData] ;
        }

    }] ;
}

#pragma mark - 广告横幅请求
- (void)asyncGetHomeAdBannersData{
    // 请求轮播数据
    if ((self.adBanners.count == 0)) {
        [[CSDataService sharedInstance] asyncGetHomeAdBannersDataByHandle:^(NSArray *banners) {
            CSLog(@"banner = %@", banners) ;
            self.adBanners = banners ;
            [self asyncGetHomeActivityTags] ;
//            [self GetHomeRecommendActivityData] ;

            [self setupUI] ;
            self.isNetWorking = YES;
            
        }] ;
    }
}

#pragma mark - 活动标签请求
- (void)asyncGetHomeActivityTags{
    if (self.activityTags.count == 0) {
        [[CSDataService sharedInstance] asyncGetHomeActivityTagsByHandle:^(NSArray *activityTags) {
            CSLog(@"activityTags = %@", activityTags) ;
            self.activityTags = activityTags ;
            self.activityView.activityTags = activityTags ;
        }] ;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeActivities.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ActivityCell";
    ActivityCell *activityCell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (activityCell == nil){
        activityCell= (ActivityCell *)[[[NSBundle  mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil] firstObject];
        activityCell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    CSActivityModel* activity =self.homeActivities[indexPath.row];
    activityCell.activity = activity ;
//    NSArray * activityId =[[NSUserDefaults standardUserDefaults]objectForKey:@"activityId"];
//    activityCell.praiseButton.selected = [activityId containsObject:activity.activityId] ? YES :NO;
//
    return activityCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (SCREENHEIGHT>=667) {
        return TRANSFER_SIZE(160);
    }else
        return TRANSFER_SIZE(130);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSActivityModel * activity = _homeActivities[indexPath.row];
    if ([activity.uidpass intValue]) {
        if (GlobalObj.isLogin) {
            [self pushActivityDetailWithIndexPath:indexPath];
        }else{
            CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
            loginVc.loginBlock = ^(BOOL loginSuccess){
                [self.navigationController popViewControllerAnimated:NO];
                [self pushActivityDetailWithIndexPath:indexPath];
            };
        }
    }else{
    
        [self pushActivityDetailWithIndexPath:indexPath];

    }
}

- (void)pushActivityDetailWithIndexPath:(NSIndexPath *)indexPath{
    CSHomeActivityDetailController *detailVC = [[CSHomeActivityDetailController alloc] init] ;
    CSActivityModel *actModel = self.homeActivities[indexPath.row] ;
    NSString * urlString =[NSString stringWithFormat:@"%@?uid=%@&userName=%@",actModel.htmlUrl,GlobalObj.token,GlobalObj.userInfo.nickName];
    NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    detailVC.htmlUrl= [actModel.uidpass intValue] ? encodedString : actModel.htmlUrl;
    detailVC.shareTitle = actModel.activityTheme;
    detailVC.shareContent= actModel.shareTitle;
    CSLog(@"htmlUrl = %@", detailVC.htmlUrl) ;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - CSLocationServiceDelegate
- (void)locationService:(CSLocationService *)svc didGetCoordinate:(CLLocationCoordinate2D)coordinate {
    GlobalObj.longitude = coordinate.longitude;
    GlobalObj.latitude = coordinate.latitude;
    // 定位完毕之后再请求一次
    
//    [[SDWebImageManager sharedManager] cancelAll];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSUInteger index = [GlobalVar sharedSingleton].tabBarController.selectedIndex  ;
//        
//        CSLog(@"isNetConnection = %d", GlobalObj.isNetConnection) ;
//        if (index == 0 && GlobalObj.isNetConnection) { // 在首页时才请求
//            [self GetHomeRecommendActivityData] ;
//        }
//    });
}

- (void)locationService:(CSLocationService *)svc didLocationInCity:(NSString *)city{
    GlobalObj.locationCity = city;
    GlobalObj.currentCity = city;
    NSUInteger index = [GlobalVar sharedSingleton].tabBarController.selectedIndex  ;
    
    CSLog(@"isNetConnection = %d", GlobalObj.isNetConnection) ;
    if (index == 0 && GlobalObj.isNetConnection) { // 在首页时才请求
        [self GetHomeRecommendActivityData] ;
    }

}

#pragma mark - 点击ktvBarItem
- (void)ktvBarItemClick{
    
    if (![[GlobalVar sharedSingleton] isLogin]) {
        CSLoginViewController *loginVC = [[CSLoginViewController alloc] init] ;
        loginVC.loginBlock = ^(BOOL success) {
            if (success) {
                [self.navigationController popViewControllerAnimated:YES] ;
            }
        } ;
        [self.navigationController pushViewController:loginVC animated:YES] ;
    }else if( GlobalObj.myRooms.count == 0 ){
        // 如果没绑定包厢，先绑定包厢
        CSQRCodeReadViewController *codeReadVc = [[CSQRCodeReadViewController alloc] init];
        codeReadVc.delegate = self;
        [self presentViewController:codeReadVc animated:YES completion:nil];
    }else if( GlobalObj.myRooms.count > 0 )
    { // 有房间跳至该房间
        UITabBarController *tabBarVc = GlobalObj.tabBarController;
        tabBarVc.selectedIndex = 1;
        CATransition *ca = [CATransition animation];
        ca.type = @"push";
        ca.subtype = kCATransitionFromRight;
        ca.duration = 0.3;
        [tabBarVc.view.layer addAnimation:ca forKey:nil];
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int currentPostion_Y = scrollView.contentOffset.y ;
////    CSLog(@"%d",self.lastPostion_Y);
//    if(currentPostion_Y > self.lastPostion_Y + TRANSFER_SIZE(15) ){
//        // 上滑
//        [UIView animateWithDuration:0.8 animations:^{
//            self.navigationController.navigationBar.alpha = 0.0 ;
//        }] ;
//        
//    }else if(self.lastPostion_Y - currentPostion_Y > TRANSFER_SIZE(15)){
//        // 下滑
//        [UIView animateWithDuration:0.8 animations:^{
//            self.navigationController.navigationBar.alpha = 1.0 ;
//        }] ;
//    }
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.lastPostion_Y = scrollView.contentOffset.y ;
//}

#pragma mark - CSQRCodeReadViewControllerDelegate
/**
 *  二维码中携带的数据信息
 *
 *  @param serverIP KTV 的 IP
 *  @param code     二维码中的随机编码
 *  @param roomNum  房间号
 */
- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum{
    GlobalObj.centerIp = serverIP;
    CSRequest *param = [[CSRequest alloc] init];
    param.registrationId = [APService registrationID];
    param.code = code;
    param.reserveBoxId = roomNum;
    [SVProgressHUD show];
    // 发送请求绑定包厢
    [CSQRCodeReadHttpTool bindingRoomWithParam:param success:^(CSBindingRoomResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            GlobalObj.roomNum = roomNum;
            GlobalObj.boxIp = result.data.boxIP;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 切换tabBar至房间
                CSRequest *param = [[CSRequest alloc] init];
                // 扫码成功后，后台服务器将该用户与该包厢绑定，重新请求该用户信息，获取包厢号
                [CSLoginHttpTool getUserInfoWithParam:param success:^(CSUserDataWrapperModel *result) {
                    if (result.code == ResponseStateSuccess) {
                        if (result.data.myrooms.count == 0) {
                            [SVProgressHUD showErrorWithStatus:@"拉取的房间列表为空"];
                            return;
                        }
                        [SVProgressHUD dismiss];
                        [GlobalVar sharedSingleton].myRooms = result.data.myrooms;
  
                        GlobalObj.selectedId = [result.data.myrooms.firstObject reserveBoxId];
    
    //                // 获取包厢号
    //                CSMyRoomInfoModel *roomInfoModel = GlobalObj.myRooms.firstObject ;
    //                self.headerView.roomBtnTitle = roomInfoModel.roomName ;
                        
                        CATransition *ca = [CATransition animation];
                        ca.type = @"push";
                        ca.subtype = kCATransitionFromRight;
                        ca.duration = 0.3;
                        UITabBarController *tabBarVc = GlobalObj.tabBarController;
                        // 切换至房间
                        [CSAlterTabBarTool alterTabBarToRoomController];
                        tabBarVc.selectedIndex = 1;
                        [tabBarVc.view.layer addAnimation:ca forKey:nil];
                    }
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:error.domain];
                    CSLog(@"%@",error);
                }];
            });
        }
        else
            [SVProgressHUD showErrorWithStatus:result.message];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请连接KTV无线网..."];
        CSLog(@"error = %@", error) ;
    }];
}

#pragma mark - 点击对应活动标签
- (void)homeActivityView:(CSHomeActivityView *)homeActivityView didTapViewWithIndex:(NSInteger)index{
    CSHomeActivityTagModel *activityTagModel = self.activityTags[index] ;
    if (activityTagModel.requestUrl) {
    CSHomeActivityListController *activityVC = [[CSHomeActivityListController alloc] init] ;
    activityVC.activityTagModel = activityTagModel ;
        [self.navigationController pushViewController:activityVC animated:YES] ;
    }else{
        [SVProgressHUD showInfoWithStatus:@"更多精彩，敬请期待..."] ;
    }
}

#pragma mark - 点击顶部广告横幅
- (void)homeBannerView:(CSHomeBannerView *)homeBannerView didSelectedAtIndex:(NSInteger)index{
    
    CSHomeAdBannerModel *bannerModel = self.adBanners[index] ;
    if ([bannerModel.uidpass intValue]) {
        if (GlobalObj.isLogin) {
            [self pushAdBannerDetailViewBannerModel:bannerModel] ;
        }else{
            CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
            loginVc.loginBlock = ^(BOOL loginSuccess){
                [self.navigationController popViewControllerAnimated:YES];
                [self pushAdBannerDetailViewBannerModel:bannerModel];
            };
        }
    }else{
        [self pushAdBannerDetailViewBannerModel:bannerModel];
    }
}

- (void)pushAdBannerDetailViewBannerModel:(CSHomeAdBannerModel *)bannerModel{
    
    CSHomeBannerDetailController *bannerDetailVC = [[CSHomeBannerDetailController alloc] init] ;
//    bannerDetailVC.adBannerUrl = bannerModel.htmlUrl ; // @"http:www.baidu.com" ;
    
    NSString * urlString =[NSString stringWithFormat:@"%@?uid=%@&userName=%@",bannerModel.htmlUrl,GlobalObj.token,GlobalObj.userInfo.nickName];
    NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    bannerDetailVC.htmlUrl= [bannerModel.uidpass intValue] ? encodedString : bannerModel.htmlUrl;
//    bannerDetailVC.shareTitle = bannerModel.activityTheme;
    CSLog(@"adBannerhtmlUrl = %@", bannerModel.htmlUrl) ;
    bannerDetailVC.shareContent= bannerModel.shareTitle;
    bannerDetailVC.shareTitle = @"潮趴汇";
    [self.navigationController pushViewController:bannerDetailVC animated:YES] ;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (self.homeActivities.count == 0 ){
        
        [self GetHomeRecommendActivityData] ;
    }
    if ((self.adBanners.count == 0)) {
        [self asyncGetHomeAdBannersData] ;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_INFO_UPDATED object:nil] ;
}


#pragma mark - 网络监听恢复
- (void)networkReachability{
    [super networkReachability];
    
    [self asyncGetHomeAdBannersData] ;
    if (self.homeActivities.count == 0) {
        [self GetHomeRecommendActivityData];
    }
//    [self GetHomeRecommendActivityData] ;
}

@end
