//
//  CSDiscoveryViewController.m
//  CloudSong
//
//  Created by EThank on 15/6/11.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSDiscoveryViewController.h"
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
#import "AFHTTPRequestOperationManager.h"


#define RATIO_WIDTH_HEIGHT  TRANSFER_SIZE(0.75) // 定义collectionViewCell的宽高比
#define TITLE_FONT   [UIFont systemFontOfSize:18.]   // navigationBar 标题字体
#define Background_Color [UIColor colorWithRed:42/255.0 green:24/255.0 blue:68/255.0 alpha:1]
#define Title_Color [UIColor colorWithRed:168/255.0 green:168/255.0 blue:165/255.0 alpha:1.0]
@interface CSDiscoveryViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL isPushDownRefresh;
    CoverView * _coverView;
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

@implementation CSDiscoveryViewController

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
//    self.navigationController.navigationBar.translucent = YES ;
    self.startIndex = 0 ;
    isStartRefresh = YES;//默认支持刷新
    // 打印token
    CSLog(@"token ========= %@",[GlobalVar sharedSingleton].token) ;
    // 自定义界面应该放到数据请求里面
    // 1. 自定义界面
    [self customUI] ;
    // 2. 集成刷新控件
    [self setupRefreshView] ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO ;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    if (self.recordsArray.count == 0) {
        // 页面进行数据请求
//        [self asyncGetbanner];
//        [self asyncGetRecordsDataByStartIndex:_startIndex] ;

        [self getAllData];
    }
    if (_coverView) {
        [_coverView scrollViewDidEndDecelerating:_coverView.scrollView];
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

/*- (void)goToLastPage
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
    });
}*/
- (void)viewDidAppear:(BOOL)animated{
    
    if (self.navigationController.navigationBar.alpha == 0.0 || self.titleLabel.alpha == 0.0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
            self.titleLabel.alpha = 0 ;
        }] ;
    }
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
    layout.sectionInset = UIEdgeInsetsMake(topMargin, leftRightMargin, 0, leftRightMargin) ;
    layout.minimumInteritemSpacing = 0 ;
    layout.minimumLineSpacing = TRANSFER_SIZE(6) ;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical ;
    /////////////////////
//    layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, TRANSFER_SIZE(149));
    
    // 2. 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] ;
    
    // 设置起始偏移量
    collectionView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(64), 0, 6, 0) ;
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"CSDiscoveryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DiscoveryCollectionCell"] ;
    ///////////////////////
    [collectionView registerClass:[CSHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    
    [self.view addSubview:collectionView] ;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(collectionView.superview) ;
        make.bottom.equalTo(collectionView.superview).offset(-TRANSFER_SIZE(49)) ;
        make.top.equalTo(collectionView.superview).offset(-TRANSFER_SIZE(64)) ;
    }] ;
    self.collectionView = collectionView ;
    // 开始进入立刻刷新
//    [self.collectionView.header beginRefreshing] ;
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发现";
    titleLabel.font = TITLE_FONT ;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    _titleLabel = titleLabel;
}

- (CoverView* )makeAdsView
{
    CoverView *coverView = [CoverView coverViewWithModels:_bannerArray andFrame:CGRectMake(0, 0, SCREENWIDTH-16, TRANSFER_SIZE(149)) andPlaceholderImageNamed:CoverViewDefaultImage andClickdCallBlock:^(NSInteger index) {
        CSLog(@"你点击了第%ld个图片", (long)index);
        //点击banner图跳转
        CSThemeDetailViewController * themeDetailVC = [[CSThemeDetailViewController alloc] init];
        themeDetailVC.titleStr = [NSString stringWithFormat:@"%@-%@",[self.bannerArray[index] specialName],[self.bannerArray[index] period]];
        themeDetailVC.specialId = [self.bannerArray[index] specialId];
        [self.navigationController pushViewController:themeDetailVC animated:YES];
        themeDetailVC.pressIntoBannerBlock = ^(BOOL flag){
            [self asyncGetbanner];
        };
        
    }];
    [coverView setScrollViewCallBlock:^(NSInteger index) {
//        CSLog(@"当前滚动到第%ld个页面", (long)index);
    }];
    
    // 请打开下面的东西逐个调试
    [coverView setAutoPlayWithDelay:3.0]; // 设置自动播放
    coverView.imageViewsContentMode = UIViewContentModeScaleAspectFit; // 图片显示内容模式模式
    [coverView updateView]; //修改属性后必须调用updateView方法，更新视图
    return coverView;
}
#pragma mark - 请求数据
- (void)getAllData{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self asyncGetbanner];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        [self asyncGetRecordsDataByStartIndex:_startIndex] ;
//        if (self.bannerArray.count) {
//            
//        }else{
//            [_collectionView.footer resetNoMoreData];
//        }
    });
}
- (void)asyncGetbanner
{
   /* NSDictionary * dataDic = @{
                               @"code":@"100",
                               @"data":@[
                                       @{
                                           @"specialName":@"蒙面歌王",
                                           @"listenCount":@"1346",
                                           @"specialId":@"1",
                                           @"praiseCount":@"24",
                                           @"period":@"第一期",
                                           @"specialImgPath":@"http://image.ethank.com.cn/5e/ec/02e5e7aaa336d5b824a41f5a60c7.png"
                                           },
                                       @{
                                           @"specialName":@"蒙面歌王",
                                           @"listenCount":@"46",
                                           @"specialId":@"1",
                                           @"praiseCount":@"24",
                                           @"period":@"第二期",
                                           @"specialImgPath":@"http://image.ethank.com.cn/59/2e/ff6e03b03749da20d4473d3a5233.png"
                                           },
                                       @{
                                           @"specialName":@"蒙面歌王",
                                           @"listenCount":@"136",
                                           @"specialId":@"1",
                                           @"praiseCount":@"24",
                                           @"period":@"第三期",
                                           @"specialImgPath":@"http://image.ethank.com.cn/68/f8/519320dde4152e6b1b9b25b0a2dd.png"
                                           }
                                       ]
                               };
    CSFindThemeResponseModel* arr = [CSFindThemeResponseModel objectWithKeyValues:dataDic];
    self.bannerArray = [NSMutableArray arrayWithArray:arr.data];
    [self.collectionView reloadData];*/
    [[CSDataService sharedInstance] asyncGetDiscoveryThemehandler:^(NSArray *themeArray) {
        isStartRefresh = YES;
        if (themeArray.count>0) {
            self.bannerArray = [NSMutableArray arrayWithArray:themeArray];
//            _coverView = [self makeAdsView];
            [self.collectionView reloadData];
        }else{
            _collectionView.hidden = YES;
        }
    }];
}
- (void)asyncGetRecordsDataByStartIndex:(NSInteger )startIndex
{
    [[CSDataService sharedInstance] asyncGetDiscoveryRecordsWithStartIndex:startIndex handler:^(NSArray *records) {
        isStartRefresh = YES;
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
            [self.collectionView.footer resetNoMoreData] ;
        }else{
            [self.collectionView.footer noticeNoMoreData] ;//resetNoMoreData
//            self.collectionView.footer.hidden = YES;
        }
    }] ;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
//    if ([[AFHTTPRequestOperationManager manager] operationQueue]) {
//        [[[AFHTTPRequestOperationManager manager] operationQueue] cancelAllOperations];
//    }
    // 添加头部刷新header
    if (isStartRefresh) {
        WS(ws) ;
        self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.bannerArray.count>0) {//焦点图已经加载出
                [ws asyncGetRecordsDataByStartIndex:_startIndex] ;
                
            }else{//焦点图尚未加载出
                [self getAllData];
            }
            [ws.collectionView.footer endRefreshing] ;
        }] ;
        self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _startIndex=0;
            isPushDownRefresh = YES;
            //        [self.recordsArray removeAllObjects];
            //        [_collectionView.footer noticeNoMoreData] ;
            [self getAllData];
            [_collectionView.header endRefreshing] ;
        }];
        isStartRefresh = NO;//关闭刷新功能
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
        };
    //播放次数回调
        musicPlayerVC.playCountBlock = ^(){
            cell.listenedCount.text = [NSString stringWithFormat:@"%d", [cell.listenedCount.text intValue]+1];
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

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CSHeaderView * view = [_collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
//    _coverView ? _coverView : ( _coverView = [self makeAdsView]);
//    _coverView ? _collectionView.hidden =YES:NO;
    [_coverView removeFromSuperview];
    _coverView = [self makeAdsView];
    [view addSubview:_coverView];
    return view;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.bannerArray.count>0) {
        return CGSizeMake(SCREENWIDTH, TRANSFER_SIZE(149));
    }else{
        return CGSizeMake(SCREENWIDTH, TRANSFER_SIZE(0.1));
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
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
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastPostion_Y = scrollView.contentOffset.y ;
}


#pragma mark - 监听
- (void)networkReachability{
    [super networkReachability];
//    [self asyncGetbanner];
//    [self asyncGetRecordsDataByStartIndex:_startIndex] ;
    [self getAllData];
}

@end
