//
//  NBMerchantViewController.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//  商户信息列表

#import "NBMerchantViewController.h"
#import "NBLocation.h"
#import "NBGuidePageView.h"
#import "NBMerchantHttpTool.h"
#import "NBAdView.h"
#import <MJRefresh.h>
#import "NBMerchantTableViewCell.h"
#import "NBMerchantTool.h"
#import "NBReadCodeController.h"
#import "NBMenuViewController.h"
#import "NBCitySelectorViewController.h"
@interface NBMerchantViewController ()<NBLocationDelegate,NBGuidePageViewDelegate,NBReadCodeControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NBCitySelectorViewControllerDelegate>
{
    NBLocation *_location;
    UIButton *_locationButton;
    NBAdView *_adView;
    UITableView *_merchantTableView;
    NSMutableArray *_merchantArray;
    NSString *_currentCity;
    BOOL _chooseCity;
    BOOL _showGuide;
    NSTimer *_timer;
}
/** 展示无加盟餐厅网页 */
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, weak) UIButton *codeScanButton;
@end

@implementation NBMerchantViewController
#pragma mark - Lazy Load
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.bounces = NO;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self.view);
            make.top.equalTo(_adView.mas_bottom);
        }];
    }
    return _webView;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self setupGuideView];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_location) {
        _location = [[NBLocation alloc] init];
        _location.delegate = self;
    }
    _chooseCity = YES;
    [self addTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _chooseCity = NO;
    [self removeTimer];
    [super viewDidDisappear:animated];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupAdView];
    [self setupMerchantTableView];
}

/** 加载引导页 */
- (void)setupGuideView
{
    // 如果需要展示引导页
    if ([self needShowGuidePages]) {
        _showGuide = YES;
        NBGuidePageView *guidePageView = [[NBGuidePageView alloc] initWithFrame:SCREEN_BOUNDS];
        [[UIApplication sharedApplication].windows.lastObject addSubview:guidePageView];
        guidePageView.delegate = self;
    }else
    {
        _showGuide = NO;
    }
}

/** 设置广告栏 */
- (void)setupAdView
{
    _adView = [[NBAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 110.0)];
//    _adView.backgroundColor = [UIColor yellowColor];

    UIView *adViewUpDivider = [[UIView alloc] init];
    adViewUpDivider.backgroundColor = HEX_COLOR(0xe0e0e0);
    [_adView addSubview:adViewUpDivider];
    adViewUpDivider.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
//    [adViewUpDivider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(_adView);
//        make.height.mas_equalTo(0.5);
//    }];
    // 上分割线
    UIView *adViewBottomDivider = [[UIView alloc] init];
    adViewBottomDivider.backgroundColor = HEX_COLOR(0xe0e0e0);
    [_adView addSubview:adViewBottomDivider];
    // 下分割线
    adViewUpDivider.frame = CGRectMake(0, _adView.height - 0.5, SCREEN_WIDTH, 0.5);
//    [adViewUpDivider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(_adView);
//        make.height.mas_equalTo(0.5);
//    }];
    [self.view addSubview:_adView];
}

/** 设置商户列表 */
- (void)setupMerchantTableView
{
    _merchantTableView = [[UITableView alloc] init];
    _merchantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _merchantTableView.delegate = self;
    _merchantTableView.dataSource = self;
    _merchantTableView.estimatedRowHeight = 50;
    [self.view addSubview:_merchantTableView];
    [_merchantTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(_adView.mas_bottom);
    }];    
    [_merchantTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadMerchantsData)];
}

#pragma mark - Config
/** 配置导航栏 */
- (void)configNavBar
{
    // 位置按钮
    _locationButton = [[UIButton alloc] init];
    [_locationButton addTarget:self action:@selector(locationBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setTitle:@"定位中..." forState:UIControlStateNormal];
    [_locationButton setImage:[[UIImage imageNamed:@"merchant_place_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    _locationButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    _locationButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [_locationButton setTitleColor:HEX_COLOR(0xeea300) forState:UIControlStateNormal];
    [_locationButton sizeToFit];
    self.navigationItem.titleView = _locationButton;
    // 二维码入口
    UIButton *codeScanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _codeScanButton = codeScanButton;
    [codeScanButton addTarget:self action:@selector(codeScanBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [codeScanButton setImage:[[UIImage imageNamed:@"order_nav_scanning_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateNormal];
    codeScanButton.size = codeScanButton.currentImage.size;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:codeScanButton];
}




#pragma mark - NBGuidePageViewDelegate
- (void)guidePageView:(NBGuidePageView *)guidePageView exitBtnDidClick:(UIButton *)button
{
    // 设置广告View
//    [self setupAdView];
    //    [self loadData];
    _showGuide = NO;
    [self removeTimer];
    [self addTimer];
}

#pragma mark - Inherit
- (void)loadData
{
    [super loadData];
    if (!_showGuide) {
        [SVProgressHUD show];
    }
    
    [self loadMerchantsData];
    [self loadAdData];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Private Methods
/**
 *  是否需要展示引导页
 *
 *  @return YES/NO
 */
- (BOOL)needShowGuidePages
{
    // 取出当前app版本号
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    // 从沙盒中取出上次存储的软件版本号
    NSString *lastVersion = [USER_DEFAULT objectForKey:VERSION_KEY];
    
    return ![currentVersion isEqualToString:lastVersion];
}

/** 加载菜单列表 */
- (void)loadMerchantsData
{
    [_merchantTableView.header endRefreshing];
    if (_currentCity == nil || _currentCity.length == 0) return;
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.cityName = _currentCity;
    __weak typeof(self) weakSelf = self;
    [NBMerchantHttpTool merchantsByCityWithParam:param success:^(NBMerchantsResponseModel *result) {
        [SVProgressHUD dismiss];
        if (result.data == nil) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:NO_MERCHANT_URL]];
            [weakSelf.webView loadRequest:request];
            weakSelf.webView.hidden = NO;
            return;
        }
        _webView.hidden = YES;
        _merchantArray = result.data;
        [_merchantTableView reloadData];
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
        [SVProgressHUD dismiss];
        [weakSelf showNetInstabilityView];
    }];

}

/** 加载广告列表 */
- (void)loadAdData
{
    NBRequestModel *param = [[NBRequestModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [NBMerchantHttpTool getAppAdWithParam:param success:^(NBGetAppAdResponseModel *result) {
        [SVProgressHUD dismiss];
        _adView.items = [result.data valueForKeyPath:@"pictureurl"];
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
        [SVProgressHUD dismiss];
        [weakSelf showNetInstabilityView];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _merchantArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBMerchantTableViewCell *cell = [NBMerchantTableViewCell cellWithTableView:tableView];
    
    cell.item = _merchantArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBMerchantModel *merchantModel = _merchantArray[indexPath.row];
    [NBMerchantTool setCurrentMerchantID:merchantModel.businessid];
    [NBMerchantTool setCurrentMerchant:merchantModel];
    NBMenuViewController *menuVc = [[NBMenuViewController alloc] init];
    menuVc.title = merchantModel.name;
    [self.navigationController pushViewController:menuVc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBMerchantModel *item = _merchantArray[indexPath.row];
    if (item.promots.count > 0) {
        return LISTCELL_DEFAULT_HEIGHT + PROMOTVIEW_HEIGHT * (item.promots.count / 2 + item.promots.count % 2);
    }
    return LISTCELL_DEFAULT_HEIGHT + 12;
}
#pragma mark - NBReadCodeControllerDelegate
- (void)readCodeControllerDidFinishReadWithMerchentID:(NSString *)merchantID tableCode:(NSString *)tableCode
{
    [SVProgressHUD show];
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.businessid = merchantID;
    [NBMerchantHttpTool merchantWithParam:param success:^(NBMerchantResponseModel *result) {
        [SVProgressHUD dismiss];
        if (result.code == 0) {
            [NBMerchantTool setCurrentMerchantID:merchantID];
            [NBMerchantTool setCurrentTableCode:tableCode];
            NBMenuViewController *menuVc = [[NBMenuViewController alloc] init];
            menuVc.merchantName = result.data.name;
            [NBMerchantTool setCurrentMerchant:result.data];
            [self.navigationController pushViewController:menuVc animated:YES];
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"二维码错误" message:result.message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        if (error.code == FAIL_CONNECT) {
            [SVProgressHUD showErrorWithStatus:@"网络错误,请稍后再试"];
            return;
        }
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"二维码错误" message:@"二维码不是你想扫,想扫就能扫!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    
        NBLog(@"%@",error);
        
    }];
    
}



#pragma mark - NBLocationDelegate
- (void)didGetCurrentCity:(NSString *)city
{
    // 去除最后的"市"字
    if (city.length == 0) return;
    if ([[city substringFromIndex:city.length - 1] isEqualToString:@"市"]) {
        city = [city substringToIndex:city.length - 1];
    };
    _currentCity = city;
    [_locationButton setTitle:city forState:UIControlStateNormal];
    [self loadData];
    
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) return;
    NBCitySelectorViewController *citySelectorVc = [[NBCitySelectorViewController alloc] init];
    citySelectorVc.delegate = self;
    [self.navigationController pushViewController:citySelectorVc animated:YES];
}


- (void)citySelectorViewControllerDidSelectCity:(NSString *)city
{
    _currentCity = city;
    [_locationButton setTitle:city forState:UIControlStateNormal];
    [self loadData];
}

#pragma mark - Action
- (void)locationBtnOnClick:(UIButton *)button
{
    NBCitySelectorViewController *citySelectorVc = [[NBCitySelectorViewController alloc] init];
    citySelectorVc.delegate = self;
    [self.navigationController pushViewController:citySelectorVc animated:YES];
}

- (void)codeScanBtnOnClick:(UIButton *)button
{
    button.enabled = NO;
    NBReadCodeController *readCodeVc = [[NBReadCodeController alloc] init];
    readCodeVc.delegate = self;
    [self presentViewController:readCodeVc animated:YES completion:^{
        button.enabled = YES;
    }];
}

#pragma mark - Timer
- (void)addTimer
{
    if (!_timer) {
        CGFloat duration = 5.0;
        _timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)showAlert
{
    if (_currentCity) return;
    if (!_chooseCity) return;
    if (_showGuide) return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"城市选择" message:@"无法定位当前城市,请手动选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
    [alertView show];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}
@end
