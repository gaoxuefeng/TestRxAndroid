//
//  CSHomeViewController.m
//  CloudSong
//
//  Created by EThank on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSHomeCollectionCell.h"
#import "CSRoomBtnView.h"
#import "CSDefine.h"
#import "CSCollectionHeaderView.h"
#import "CSHomeActivityDetailController.h"
#import "CSLoginViewController.h"
#import "CSQRCodeReadViewController.h"
#import "SVProgressHUD.h"
#import <APService.h>
#import "CSDataService.h"
#import "CSHomeActivityListController.h"
#import "CSHomeActivityModel.h"
#import "CSAlterTabBarTool.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import <MobClick.h>
#import "CSLoginHttpTool.h"
#import "CSUserDataWrapperModel.h"

#define ITEM_SPACE          TRANSFER_SIZE(6)
#define LEFT_RIGHT_SPACE    TRANSFER_SIZE(7)

#define CELL_ID         @"CSHomeCollectionCell"
#define HEADER_ID       @"Header"

#define TWO_COLUMN_INITIAL_NUMBER 3 // 两列item中起始item的编号
#define Background_Color [UIColor colorWithRed:50/255.0 green:46/255.0 blue:82/255.0 alpha:1]


static int twoColumnPre = TWO_COLUMN_INITIAL_NUMBER ; // 记录两列item的前一个标号
static int twoColumnLast = TWO_COLUMN_INITIAL_NUMBER + 1 ;

@interface CSHomeViewController () <UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout,
                                    CollectionHeaderViewDelegate,
                                    CSQRCodeReadViewControllerDelegate>

@property (weak , nonatomic) UICollectionView *collectionView ;
/** 记录collectionView上次滚动位置 */
@property (nonatomic, assign) int lastPostion_Y ;
@property (nonatomic, weak) CSCollectionHeaderView *headerView ;
@property (nonatomic, strong) NSMutableArray *homeActivities ;

@property (nonatomic, assign)NSInteger startIndex ;

@end

@implementation CSHomeViewController

- (void)viewDidLoad{
    [super viewDidLoad] ;
    _startIndex = 0 ;
    self.automaticallyAdjustsScrollViewInsets = NO ;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoomBtn:) name: USER_INFO_UPDATED object:nil] ;
    
    self.view.backgroundColor = [Background_Color colorWithAlphaComponent:0.8] ;
//    [self.navigationController.navigationBar setAlpha:0] ;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setupUI] ;
    
    // 集成刷新控件
//    [self setupRefreshView] ;
}

#pragma mark - 懒加载
- (NSMutableArray *)homeActivities{
    if (_homeActivities == nil) {
        _homeActivities = [NSMutableArray array] ;
    }
    return _homeActivities ;
}

#pragma mark - 初始化页面
- (void)setupUI{
    
    // 1. 创建一个CollectionView的布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init] ;
    
    // 设置间距 (上 左 下 右)
    layout.sectionInset = UIEdgeInsetsMake(TRANSFER_SIZE(20), LEFT_RIGHT_SPACE, 10, LEFT_RIGHT_SPACE) ;
    
    // 2. 创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:layout] ;
    collectionView.frame = CGRectMake(0, -64, SCREENWIDTH, SCREENHEIGHT-49) ;

    collectionView.backgroundColor = [Background_Color colorWithAlphaComponent:0.8];
    
    // 设置起始偏移量
    collectionView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(-130), 0, 10, 0) ;
    
    // 首页动画效果
    [self.view layoutIfNeeded] ;
    [UIView animateWithDuration:2.5 animations:^{
        collectionView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(64), 0, 10, 0) ;
        [self.view layoutIfNeeded] ;
    }] ;

    collectionView.dataSource = self ;
    collectionView.delegate = self ;
    [self.view addSubview:collectionView] ;
    self.collectionView = collectionView ;
    
    
    // 4. 注册cell （iOS 6 以后才有这个控件的 只支持注册方式来复用）
    [self.collectionView registerClass:[CSHomeCollectionCell class] forCellWithReuseIdentifier:CELL_ID] ;
    [self.collectionView registerClass:[CSCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_ID] ;
    
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView{
    WS(ws) ;
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 重置编号，重新计算
        twoColumnPre = TWO_COLUMN_INITIAL_NUMBER ;
        twoColumnLast = TWO_COLUMN_INITIAL_NUMBER + 1 ;
        
        [ws GetHomeRecommendActivityData] ;
        [ws.collectionView.footer endRefreshing] ;
       
    }] ;

}
#pragma mark - 数据请求
- (void)GetHomeRecommendActivityData{
    
    [[CSDataService sharedInstance] asyncGetHomeRecommendActivityDatahandler:^(NSArray *activities) {
        if (activities.count) {
            _startIndex += activities.count ;
            [self.homeActivities addObjectsFromArray:activities] ;
            [self.collectionView reloadData] ;
        }else{
            [self.collectionView.footer noticeNoMoreData] ;
        }
    }] ;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"homeActivitiesCount = %lu", (unsigned long)self.homeActivities.count) ;
    return self.homeActivities.count ;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // cell 都无需实例化，由系统在内部完成，也无需判断（cell == nil）一种新的复用方式，
    CSHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath] ;
    // 对应cel的模型
    CSHomeActivityModel *activityModel = self.homeActivities[indexPath.row] ;
    cell.activityModel = activityModel ;
    
    return cell ;
}

/**
 *  定制头部
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil ;
    if (kind == UICollectionElementKindSectionHeader) {
        CSCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_ID forIndexPath:indexPath];
        headerView.delegate = self ;
        reusableView = headerView;
        self.headerView = headerView ;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 保证headerView已初始化，nil 无法启动动画
            [self.headerView headerViewAnimateWithTimeInterval:3.5] ;
        });
    }
    
    return reusableView ;
}

#pragma mark - UICollectionViewDelegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CSHomeActivityDetailController *detailVC = [[CSHomeActivityDetailController alloc] init] ;
    CSHomeActivityModel *actModel = self.homeActivities[indexPath.row] ;
    detailVC.htmlUrl = actModel.htmlUrl ;
    detailVC.shareTitle = actModel.activityTheme;
    detailVC.htmlUrl= actModel.htmlUrl;
    [self.navigationController pushViewController:detailVC animated:YES] ;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat itemWidth = (SCREENWIDTH - 2 * ITEM_SPACE - 2 * LEFT_RIGHT_SPACE) / 3 ;
    CGGlyph itemHeight = TRANSFER_SIZE(110) ;
    
    if (indexPath.row == twoColumnPre || indexPath.row == twoColumnLast) {
        
        (indexPath.row == twoColumnPre) ? (twoColumnPre += 5) : (twoColumnLast += 5 ) ;
        itemWidth = (SCREENWIDTH - 2 * LEFT_RIGHT_SPACE - ITEM_SPACE) / 2 ;
        
        return CGSizeMake(itemWidth, itemHeight) ;
    }
    return CGSizeMake(itemWidth, itemHeight) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 6.0 ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}

/**
 *  设置collectionView 头部尺寸
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREENWIDTH, 250) ;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion_Y = scrollView.contentOffset.y ;
//    NSLog(@"%d",self.lastPostion_Y);
    if(currentPostion_Y > self.lastPostion_Y + TRANSFER_SIZE(15) ){
        // 上滑
        [UIView animateWithDuration:0.8 animations:^{
            self.navigationController.navigationBar.alpha = 0.0 ;
        }] ;
        
    }else if(self.lastPostion_Y - currentPostion_Y > TRANSFER_SIZE(15)){
        // 下滑
        [UIView animateWithDuration:0.8 animations:^{
            self.navigationController.navigationBar.alpha = 1.0 ;
        }] ;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastPostion_Y = scrollView.contentOffset.y ;
}

#pragma mark - CollectionHeaderViewDelegate 处理头部进入房间的点击事件
- (void)collectionHeaderView:(CSCollectionHeaderView *)headerView didClickRoomBtn:(UIButton *)roomButton{

    // 当点击了headerView上的进入房间按钮(roomBtn)提示先登录
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

#pragma mark - 点击全国、精品、热门按钮
- (void)collectionHeaderView:(CSCollectionHeaderView *)headerView didTapViewWithType:(CSHomeActivityType)viewType{
    
    CSHomeActivityListController *activityVC = [[CSHomeActivityListController alloc] init] ;
    
    switch (viewType) {
        case CSHomeActivityTypeNational:{
            [MobClick event:@"HomeNationwide"];
            activityVC.titleName = @"全国活动" ;
            activityVC.activityType = CSHomeActivityTypeNational ;
            [self.navigationController pushViewController:activityVC animated:YES] ;
        }break;
        case CSHomeActivityTypeBoutique:{
            [MobClick event:@"HomeBoutique"];
            activityVC.titleName = @"精品活动" ;
            activityVC.activityType = CSHomeActivityTypeBoutique ;
            [self.navigationController pushViewController:activityVC animated:YES] ;
        }break ;
        case CSHomeActivityTypeHot:{
            [MobClick event:@"HomeHot"];
            activityVC.titleName = @"热门活动" ;
            activityVC.activityType = CSHomeActivityTypeHot ;
            [self.navigationController pushViewController:activityVC animated:YES] ;
        }break ;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (self.homeActivities.count == 0) {
        // 请求数据
        [self GetHomeRecommendActivityData] ;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = NO ;
    
    if (GlobalObj.isLogin) {
        if (GlobalObj.myRooms.count) {
            CSMyRoomInfoModel *roomInfoModel = GlobalObj.myRooms.firstObject ;
            self.headerView.roomBtnTitle = roomInfoModel.roomName ;
//        CSLog(@"roomName = %@\n GlobalObj.myRooms.count = %ld", roomInfoModel.roomName,GlobalObj.myRooms.count) ;
        }
    }else{
        self.headerView.roomBtnTitle = @"加入房间";
        self.headerView.descInfo =@"预订房间或扫描歌屏上二维码,就能点歌啦";
    }

    [super viewWillAppear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_INFO_UPDATED object:nil] ;
}

/**
 *  响应通知更新进入房间按钮内容
 */
- (void)updateRoomBtn:(NSNotification *)notification{
    
    // 设置首页进入房间按钮文字
    if (GlobalObj.isLogin) {
        if (GlobalObj.myRooms.count) {
            CSMyRoomInfoModel *roomInfoModel = GlobalObj.myRooms.firstObject ;
            self.headerView.roomBtnTitle = roomInfoModel.roomName ;
            CSLog(@"roomName = %@\n GlobalObj.myRooms.count = %ld", roomInfoModel.roomName,GlobalObj.myRooms.count) ;
        }
    }else{
        self.headerView.roomBtnTitle = @"加入房间";
        self.headerView.descInfo =@"预订房间或扫描歌屏上二维码,就能点歌啦";
    }
}

#pragma mark - 网络监听恢复
- (void)networkReachability
{
    [self GetHomeRecommendActivityData] ;
}

@end
