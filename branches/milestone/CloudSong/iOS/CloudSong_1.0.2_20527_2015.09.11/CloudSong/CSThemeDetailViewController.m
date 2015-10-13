//
//  CSThemeDetailViewController.m
//  CloudSong
//
//  Created by Ethank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSThemeDetailViewController.h"
#import "CSDiscoveryCollectionCell.h"
#import "CSMusicPlayerViewController.h"
#import <MJRefresh.h>
#import "CSRecordsModel.h"
#import "GlobalVar.h"
#import "CSDataService.h"
#import <Masonry.h>
#import "CSLoginViewController.h"

#import "CSHeaderView.h"
#import "CoverView.h"
#import "CSDefine.h"
#import "CSFindThemeResponseModel.h"
#import <MJExtension.h>
#import "CSThemeDetailViewController.h"
#import "SVProgressHUD.h"

#define RATIO_WIDTH_HEIGHT  TRANSFER_SIZE(0.75) // 定义collectionViewCell的宽高比
#define TITLE_FONT   [UIFont systemFontOfSize:TRANSFER_SIZE(18)]   // navigationBar 标题字体
#define Background_Color [UIColor colorWithRed:42/255.0 green:24/255.0 blue:68/255.0 alpha:1]
#define Title_Color [UIColor colorWithRed:168/255.0 green:168/255.0 blue:165/255.0 alpha:1.0]
@interface CSThemeDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL isPushDownRefresh;
    BOOL isStartRefresh;//判断当前是否可以刷新  yes 可以   no不可以
}
@property (nonatomic, strong) NSMutableArray *recordsArray ;
@property (nonatomic, weak) UICollectionView *collectionView ;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *navBackView ;
/** 记录collectionView上次滚动位置 */
@property (nonatomic, assign) int lastPostion_Y ;
@property (nonatomic, assign) int startIndex ;
@property (nonatomic, assign) int responseDataCount ;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, strong)NSMutableArray * bannerArray;
@end

@implementation CSThemeDetailViewController

static NSString *const cellID = @"DiscoveryCollectionCell";

#pragma mark - 懒加载
- (NSMutableArray *)recordsArray
{
    if (_recordsArray == nil) {
        _recordsArray = [NSMutableArray array] ;
    }
    return _recordsArray ;
}


#pragma mark - Life Cylce
- (void)viewDidLoad
{
    [super viewDidLoad] ;
    self.navigationController.navigationBar.translucent = YES ;    
    self.startIndex = 0 ;
    isStartRefresh = YES;
    // 打印token
    CSLog(@"token ========= %@",[GlobalVar sharedSingleton].token) ;
    
    // 自定义界面应该放到数据请求里面
    // 1. 自定义界面
    [self customUI] ;
#warning 刷新需要
    // 2. 集成刷新控件
    [self setupRefreshView] ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO ;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
#warning 网络请求修改
    if (self.recordsArray.count == 0) {
        // 0. 数据请求
        [self asyncGetBannerDetailDataBySpecialId:self.specialId startIndex:_startIndex];
    }
        /*if (self.navigationController.navigationBar.alpha == 0.0 || self.titleLabel.alpha == 0.0 ) {
            [UIView animateWithDuration:0.5 animations:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBar.alpha = 0.0;
                });
                self.titleLabel.alpha = 0 ;
            }] ;
        }
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLastPage) name:DISCOVER_NET_BAD object:nil];*/
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

#pragma mark - 自定义界面
- (void)customUI
{
    // 1. 创建布局
    // 左右间距
    CGFloat leftRightMargin = TRANSFER_SIZE(8) ;
    // 上间距
    CGFloat topMargin = TRANSFER_SIZE(6) ;
    CGFloat cellW = (SCREENWIDTH - 2 * leftRightMargin - 5) / 2 ;
    //    CGFloat cellH = cellW / RATIO_WIDTH_HEIGHT ;
    CGFloat cellH =TRANSFER_SIZE(160) ;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init] ;
    layout.itemSize = CGSizeMake(cellW, cellH) ;
    layout.sectionInset = UIEdgeInsetsMake(topMargin, leftRightMargin, topMargin, leftRightMargin) ;
    layout.minimumInteritemSpacing = 0 ;
    layout.minimumLineSpacing = TRANSFER_SIZE(6) ;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical ;
    
    // 2. 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] ;
    
    // 设置起始偏移量
    collectionView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(64), 0, 6, 0) ;
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"CSDiscoveryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DiscoveryCollectionCell"] ;
    [self.view addSubview:collectionView] ;
    self.collectionView = collectionView ;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(collectionView.superview) ;
        make.top.equalTo(collectionView.superview).offset(-TRANSFER_SIZE(64)) ;
    }] ;
    // 开始进入立刻刷新
    //    [self.collectionView.header beginRefreshing] ;
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text =self.titleStr;
    titleLabel.font = TITLE_FONT;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    _titleLabel = titleLabel;
}

#pragma mark - 请求数据
- (void)asyncGetBannerDetailDataBySpecialId:(NSString *)specialId startIndex:(NSInteger)startIndex
{
    [[CSDataService sharedInstance] asyncGetDiscoveryThemeDetailWithSpecialId:specialId startIndex:(NSInteger)startIndex handle:^(NSArray *themeDetailArray) {
        isStartRefresh = YES;
        self.requestCount = themeDetailArray.count;
        if (themeDetailArray.count) {
//            self.collectionView.footer.hidden = NO;
            _startIndex += themeDetailArray.count ;
            [self.recordsArray addObjectsFromArray:themeDetailArray] ;
            if (isPushDownRefresh) {
                isPushDownRefresh = NO;
                [self.recordsArray removeAllObjects];
                [self.recordsArray addObjectsFromArray:themeDetailArray];
            }
            [self.collectionView reloadData] ;
            [self.collectionView.footer resetNoMoreData] ;
        }else{
            [self.collectionView.footer noticeNoMoreData] ;//resetNoMoreData
//            self.collectionView.footer.hidden = YES;
        }
    }];
}
/*******/
- (void)asyncGetRecordsDataByStartIndex:(NSInteger )startIndex
{
    [[CSDataService sharedInstance] asyncGetDiscoveryRecordsWithStartIndex:startIndex handler:^(NSArray *records) {
        self.requestCount = records.count;
        if (records.count) {
            _startIndex += records.count ;
            [self.recordsArray addObjectsFromArray:records] ;
            if (isPushDownRefresh) {
                isPushDownRefresh = NO;
                [self.recordsArray removeAllObjects];
                [self.recordsArray addObjectsFromArray:records];
            }
            [self.collectionView reloadData] ;
        }else{
            [self.collectionView.footer noticeNoMoreData] ;
            
        }
    }] ;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    // 添加头部刷新header
    //    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //            CSLog(@"headerWithBlock.....") ;
    //            [self.collectionView.header endRefreshing] ;
    //
    //        });
    //    }] ;
    if (isStartRefresh) {
        WS(ws) ;
        self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [ws asyncGetBannerDetailDataBySpecialId:self.specialId startIndex:_startIndex] ;
            [ws.collectionView.footer endRefreshing] ;
        }] ;
        self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _startIndex=0;
            isPushDownRefresh = YES;
            [_collectionView.footer noticeNoMoreData] ;//noticeNoMoreData
            [ws asyncGetBannerDetailDataBySpecialId:self.specialId startIndex:_startIndex] ;
            [_collectionView.header endRefreshing] ;
        }];
        isStartRefresh = NO;
    }
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recordsArray.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CSDiscoveryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath] ;
    // 取出模型
    CSRecordsModel *recordsModel = self.recordsArray[indexPath.row] ;
    cell.recordsData = recordsModel ;
    
    return cell ;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if ([[GlobalVar sharedSingleton] isLogin]) {
    CSRecordsModel *recordsModel = self.recordsArray[indexPath.row] ;
    
    CSMusicPlayerViewController *musicPlayerVC = [[CSMusicPlayerViewController alloc] initWithShareUrl:recordsModel.shareUrl] ;
    musicPlayerVC.hidesBottomBarWhenPushed = YES ;
    CSDiscoveryCollectionCell *cell= (CSDiscoveryCollectionCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    //点赞回调
    musicPlayerVC.praiseBlock = ^(NSNumber * count){
        cell.favoriteCount.text = [NSString stringWithFormat:@"%@",count];
        if (self.pressIntoBannerBlock) {
            self.pressIntoBannerBlock(YES);
        }
    };
    //播放次数回调
    musicPlayerVC.playCountBlock = ^(){
        cell.listenedCount.text = [NSString stringWithFormat:@"%d", [cell.listenedCount.text intValue]+1];
        if (self.pressIntoBannerBlock) {
            self.pressIntoBannerBlock(YES);
        }
    };
    // 取出模型设置数据
    musicPlayerVC.discoveryId = recordsModel.discoverId ;
    musicPlayerVC.musicUrl = recordsModel.musicUrl ;
    musicPlayerVC.musicName = recordsModel.musicName ;
    
    [self.navigationController pushViewController:musicPlayerVC animated:YES] ;
    
    //    }else{
    //        CSLoginViewController *loginVC = [[CSLoginViewController alloc] init] ;
    //        loginVC.loginBlock = ^(BOOL success)
    //        {
    //            [self.navigationController popViewControllerAnimated:YES] ;
    //        } ;
    //        [self.navigationController pushViewController:loginVC animated:YES] ;
    //
    //    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    int currentPostion_Y = scrollView.contentOffset.y ;
    //
    //    if (self.requestCount > 0) {
    //        if(currentPostion_Y > self.lastPostion_Y + TRANSFER_SIZE(15) ){
    //            // 上滑
    //            [UIView animateWithDuration:0.8 animations:^{
    //                self.navigationController.navigationBar.alpha = 0 ;
    //                self.titleLabel.alpha = 0 ;
    //            }] ;
    //            CSLog(@"scrollUp.....") ;
    //
    //        }else if(self.lastPostion_Y - currentPostion_Y > TRANSFER_SIZE(15)){
    //            // 下滑
    //            [UIView animateWithDuration:0.8 animations:^{
    //                self.navigationController.navigationBar.alpha = 1 ;
    //                self.titleLabel.alpha = 1 ;
    //            }] ;
    //            CSLog(@"scrollDown") ;
    //        }
    //    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastPostion_Y = scrollView.contentOffset.y ;
}


#pragma mark - 监听
- (void)networkReachability{
    [super networkReachability] ;
#warning 监听接口需要修改
    [self asyncGetBannerDetailDataBySpecialId:self.specialId startIndex:_startIndex];
}

@end
