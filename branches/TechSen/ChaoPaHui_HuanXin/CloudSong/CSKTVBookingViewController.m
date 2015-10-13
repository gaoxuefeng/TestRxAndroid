//
//  CSKTVBookingViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVBookingViewController.h"
#import "CSTwoColumnsView.h"
#import "CSSmartSortView.h"
#import "CSKTVBookingCell.h"
#import "CSDataService.h"
#import "CSDianPingViewController.h"
#import "CSCityChoosingController.h"
#import "CSDefine.h"
#import "CSKTVModel.h"
#import "CSUtil.h"
#import "CSLocationService.h"
#import "Header.h"
#import "CSShopDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CSArrowButton.h"

#import <MJRefresh.h>
// TODO just for test
#import "CSSocialTableViewController.h"
#import "CSKTVPayViewController.h"
//#import "CSCitySelectView.h"
#import <MobClick.h>

@interface CSKTVBookingViewController ()<CSCityChoosingControllerDelegate, CSTwoColumnsViewDelegate, CSSmartSortViewDelegate, CSLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate> {
    // 城市选择相关
    UIView*                _buttonsContainer;
    CSCityChoosingController*   _cityChoosingController;
    
    CSArrowButton*         _cityChooseButton; // 城市选择
    CSArrowButton*         _nearButton;       // 附近按钮
    CSArrowButton*         _smartSortButton;  // 智能排序
    
    MASConstraint*         _cityChooseViewOffsetY;
    
    // 背景
    UIView*                 _bgView;
    
    // 附近相关
    CSTwoColumnsView*      _nearView;
    MASConstraint*         _nearViewOffsetY;

    // 智能排序相关
    CSSmartSortView*       _sortView;
    MASConstraint*         _sortViewOffsetY;

    UITableView*           _tableView;
    
    NSMutableArray* _bldKTVData;
    NSMutableArray* _dianpingKTVData;
    
    BOOL            _citySelectViewIsShowing;
    BOOL            _nearViewIsShowing;
    BOOL            _sortViewIsShowing;
    NSInteger       _selectedIndex;
    
    // 定位订到的城市或者用户手动选择的城市
    BOOL            _needLocateCity;
    CLLocationCoordinate2D  _coordinate;
    NSString*       _selectedCity;
    
    // 标记请求页数
    NSInteger       _startIndex ;
    NSInteger       _responseDataCount ;
    NSString *      _firstCity;
    
}
@end

@implementation CSKTVBookingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _startIndex = 0 ;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO ;
    self.navigationItem.title = @"预订";
    _bldKTVData = [NSMutableArray array];
    _dianpingKTVData = [NSMutableArray array];
    _needLocateCity = YES;
    [[CSLocationService sharedInstance] addDelegate:self];
    [[CSLocationService sharedInstance] startGetLocation];
    [CSUtil hideEmptySeparatorForTableView:_tableView];
    
    _cityChoosingController = [[CSCityChoosingController alloc] init];
    _cityChoosingController.delegate = self;
    [self setupSubviews];
    // 集成刷新控件
    [self setupRefreshView] ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_bldKTVData.count + _dianpingKTVData.count == 0) {
        _coordinate = CLLocationCoordinate2DMake(GlobalObj.latitude, GlobalObj.longitude);
        _startIndex = 0;
        _selectedCity = GlobalObj.currentCity;
        [_cityChooseButton setTitle:_selectedCity forState:UIControlStateNormal];
        [self refreshKTVData];
    }
}
-(void)becomeActive{
    if (_citySelectViewIsShowing) {
        self.view.height=self.view.frame.size.height;
        self.view.height+=49;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeActive) name:@"becomeActive" object:nil];
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated];
}
#pragma mark - Inheritated Methods

- (void)configUI {
    [super configUI];
    _buttonsContainer.backgroundColor = WhiteColor_Alpha_4;
    [_cityChooseButton setBackgroundColor:WhiteColor_Alpha_4];
    [_nearButton setBackgroundColor:WhiteColor_Alpha_4];
    [_smartSortButton setBackgroundColor:WhiteColor_Alpha_4];
    _tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Actions

- (void)cityChooseBtnPressed:(id)sender {
    if (_nearViewIsShowing)
        [self nearButtonPressed:nil];
    else if (_sortViewIsShowing)
        [self smartSortBtnPressed:nil];

    _citySelectViewIsShowing = !_citySelectViewIsShowing;
    [self showCityChoosingView:_citySelectViewIsShowing animated:YES];
    if (_citySelectViewIsShowing)
        [_cityChoosingController reloadData];
    else
        [_cityChoosingController hideKeyboard];
    
    // 更新button的箭头方向
    [_cityChooseButton selectedStateChanged];
    
}

- (void)nearButtonPressed:(id)sender {
    // 如果城市选择view处于打开状态，则应收起他
    if (_citySelectViewIsShowing)
        [self cityChooseBtnPressed:nil];
    // 如果智能排序view处于打开状态，则应收起他
    else if (_sortViewIsShowing)
        [self smartSortBtnPressed:nil];
    
    // 根据条件展现或者隐藏附近view
    _nearViewIsShowing = !_nearViewIsShowing;
    [self showNearView:_nearViewIsShowing animated:YES];
//    [self getDistrictData];
    // 更新button的箭头方向
    [_nearButton selectedStateChanged];

}

- (void)smartSortBtnPressed:(id)sender {
    // 如果城市选择view处于打开状态，则应收起他
    if (_citySelectViewIsShowing)
        [self cityChooseBtnPressed:nil];
    // 如果附近view处于打开状态，则应收起他
    else if (_nearViewIsShowing)
        [self nearButtonPressed:nil];

    // 根据条件展现或者隐藏智能排序view
    _sortViewIsShowing = !_sortViewIsShowing;
    [self showSortView:_sortViewIsShowing animated:YES];
    
    // 更新button的箭头方向
    [_smartSortButton selectedStateChanged];
}

#pragma mark - Private Methods

- (void)showCityChoosingView:(BOOL)show animated:(BOOL)animated {
    self.tabBarController.tabBar.hidden= _citySelectViewIsShowing;
    self.view.height += _citySelectViewIsShowing?49.0:-49.0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animated ? .5 : 0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _cityChooseViewOffsetY.offset = show ? TRANSFER_SIZE(25) + ([_cityChoosingController citySelectView].height) : TRANSFER_SIZE(0);
                            [self.view layoutIfNeeded];
                        } completion:nil];
}

- (void)showNearView:(BOOL)show animated:(BOOL)animated {
    _bgView.hidden = !show;
    if (show)
        [_nearView resetPosition];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animated ? .1 : 0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _nearViewOffsetY.offset = show ? TRANSFER_SIZE(25) + _nearView.height : TRANSFER_SIZE(25);
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (show) {
                             [_nearView reloadData];
                         }
                     }];
}

- (void)showSortView:(BOOL)show animated:(BOOL)animated {
    _bgView.hidden = !show;
    if (show)
        [_sortView resetPosition];

    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animated ? .5 : 0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _sortViewOffsetY.offset = show ? TRANSFER_SIZE(25) + _sortView.height : TRANSFER_SIZE(25);
                         [self.view layoutIfNeeded ];
                     } completion:^(BOOL finished) {
                         [_sortView reloadData];
                     }];
}

- (void)setupSubviews {
    CGFloat buttonContainerHeight = TRANSFER_SIZE(25);
    
    // 添加主页面tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:.04];
    [CSUtil hideEmptySeparatorForTableView:_tableView];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.top.mas_equalTo(buttonContainerHeight);
        make.top.equalTo(_tableView.superview).offset(buttonContainerHeight);
        make.bottom.equalTo(self.view).offset(-49.0);
    }];
    
    // 背景
    _bgView = [[UIView alloc] init];
    [self.view addSubview:_bgView];
    _bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.04];
    _bgView.hidden = YES;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 城市选择View
    UIView *cityChoosingView = [_cityChoosingController citySelectView];
    [self.view addSubview:cityChoosingView];
    [cityChoosingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).offset(buttonContainerHeight);
        _cityChooseViewOffsetY = make.bottom.equalTo(self.view.mas_top).offset(0);
    }];
    // 附近View
    _nearView = [[CSTwoColumnsView alloc] init];
    [self.view addSubview:_nearView];
    _nearView.delegate = self;
    [_nearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nearView.superview);
        make.height.equalTo(_nearView.superview.mas_height).offset(buttonContainerHeight);
        _nearViewOffsetY = make.bottom.equalTo(_nearView.superview.mas_top).offset(buttonContainerHeight);
    }];
    
    // 智能排序 view
    _sortView = [[CSSmartSortView alloc] init];
    [self.view addSubview:_sortView];
    _sortView.delegate = self;
    _sortView.data = [[CSDataService sharedInstance] smartSortData];
    [_sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_sortView.superview);
        make.height.equalTo(_sortView.superview.mas_height).offset(buttonContainerHeight);
        _sortViewOffsetY = make.bottom.equalTo(_sortView.superview.mas_top).offset(buttonContainerHeight);
    }];

    // 上面三个buttons的容器
    _buttonsContainer = [[UIView alloc] init];
    _buttonsContainer.backgroundColor = HEX_COLOR(0x2e2145);
    [self.view addSubview:_buttonsContainer];
    [_buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(buttonContainerHeight);
    }];
    
    _cityChooseButton = [CSArrowButton buttonWithType:UIButtonTypeCustom];
    [_cityChooseButton addTarget:self action:@selector(cityChooseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_cityChooseButton setTitle:@"北京" forState:UIControlStateNormal]; // TODO
    _cityChooseButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    [_cityChooseButton setTitleColor:HEX_COLOR(0x9799a2) forState:UIControlStateNormal];
    [_buttonsContainer addSubview:_cityChooseButton];
    [_cityChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonsContainer);
        make.top.equalTo(_buttonsContainer);
        make.bottom.equalTo(_buttonsContainer);
        make.width.equalTo(_buttonsContainer).multipliedBy(1.0/3);
    }];
    
    _nearButton = [CSArrowButton buttonWithType:UIButtonTypeCustom];
    [_nearButton addTarget:self action:@selector(nearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    [_nearButton setTitleColor:HEX_COLOR(0x9799a2) forState:UIControlStateNormal];
    [_buttonsContainer addSubview:_nearButton];
    [_nearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityChooseButton.mas_right);
        make.top.equalTo(_buttonsContainer);
        make.bottom.equalTo(_buttonsContainer);
        make.width.equalTo(_buttonsContainer).multipliedBy(1.0/3);
    }];
    //为区街道赋初始值
    _selectedCity = GlobalObj.currentCity;
    if ([_selectedCity isEqualToString:@"北京"]) {
        [_nearButton setTitle:@"全城" forState:UIControlStateNormal];
        _startIndex = 0;
        _selectedCity = @"北京";
//        [self refreshKTVData];
        [self getDistrictData];
    }
    
    _smartSortButton = [CSArrowButton buttonWithType:UIButtonTypeCustom];
    [_smartSortButton addTarget:self action:@selector(smartSortBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_smartSortButton setTitle:@"智能排序" forState:UIControlStateNormal]; // TODO
    _smartSortButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    [_smartSortButton setTitleColor:HEX_COLOR(0x9799a2) forState:UIControlStateNormal];
    [_buttonsContainer addSubview:_smartSortButton];
    [_smartSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nearButton.mas_right);
        make.top.equalTo(_buttonsContainer);
        make.bottom.equalTo(_buttonsContainer);
        make.width.equalTo(_buttonsContainer).multipliedBy(1.0/3);
    }];
    
    // 上方横线
    UIImageView *topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
    topLine.alpha = .55;
    [_buttonsContainer addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonsContainer);
        make.top.equalTo(_buttonsContainer);
        make.right.equalTo(_buttonsContainer);
        make.height.mas_equalTo(TRANSFER_SIZE(1));
    }];
    
    // 下方横线
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_durn"]];
    bottomLine.alpha = .3;
    [_buttonsContainer addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonsContainer);
        make.bottom.equalTo(_buttonsContainer);
        make.right.equalTo(_buttonsContainer);
        make.height.mas_equalTo(TRANSFER_SIZE(1));
    }];
    
    // 竖向分割线
    UIImageView *verticalLine0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_line"]];
    [_buttonsContainer addSubview:verticalLine0];
    [verticalLine0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityChooseButton.mas_right);
        make.centerY.equalTo(_buttonsContainer);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(1), TRANSFER_SIZE(13)));
    }];
    
    // 竖向分割线
    UIImageView *verticalLine1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_line"]];
    [_buttonsContainer addSubview:verticalLine1];
    [verticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nearButton.mas_right);
        make.centerY.equalTo(_buttonsContainer);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(1), TRANSFER_SIZE(13)));
    }];

}

#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    __weak UITableView *tableView = _tableView ;
//    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        // 从0开始
//        _startIndex = 0 ;
//        [self refreshKTVData] ;
//        [tableView.header endRefreshing] ;
//    }] ;
    
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _startIndex += _responseDataCount;
        [self refreshKTVData] ;
        
        [_tableView.footer endRefreshing] ;
    }] ;
}

#pragma mark - 请求预定界面大众点评KTV数据
- (void)refreshKTVData {
    
    __weak UITableView *tableView = _tableView ;
    NSString * nearText = nil;
    if ([_nearButton.titleLabel.text isEqualToString:@"全城"]) {
        nearText = @"";
    }else{
        nearText = _nearButton.titleLabel.text;
    }
    [[CSDataService sharedInstance] asyncGetKTVDataWithCoordinate:_coordinate
                                                       startIndex:_startIndex
                                                         cityName:_selectedCity
                                                            range:0
                                                     businessName: nearText
                                                         sortType:_sortView.type + 1
                                                          handler:^(NSArray *bldKTVData, NSArray *dianpingKTVData) {
                                                              
                                                              [_bldKTVData removeAllObjects];
                                                              [_bldKTVData addObjectsFromArray:bldKTVData];
                                                              
                                                              
                                                              if (_startIndex <= 0) {
                                                                  [_dianpingKTVData removeAllObjects];
                                                              }

                                                              _responseDataCount = dianpingKTVData.count ;
                                                              
                                                              if (_responseDataCount != 0) {
                                                                  [_dianpingKTVData addObjectsFromArray:dianpingKTVData] ;
                                                                  
                                                                  [tableView reloadData];

                                                              }else
                                                              {
                                                                  [tableView.footer noticeNoMoreData] ;
                                                              }
                                                        }];
}

- (void)getDistrictData {
    [[CSDataService sharedInstance] asyncGetBusinessDistrictsWithCity:_selectedCity handler:^(NSArray *districts) {
        if (districts.count) {
            [_nearView setData:districts];
            [_nearButton setTitle:[_nearView defaultDistrictInCity:_selectedCity] forState:UIControlStateNormal];
            [self refreshKTVData];//获取到附近才去请求ktv数据
        }
    }];
}

#pragma mark - CSCityChoosingControllerDelegate

- (void)cityChoosingController:(CSCityChoosingController *)vc didSelectCity:(NSString *)city {
    // 关闭城市选择界面
    [self cityChooseBtnPressed:nil];
    // app自动查找到城市时，刷新数据
    if (![_selectedCity isEqualToString:city]) {
        _coordinate = CLLocationCoordinate2DMake(GlobalObj.latitude, GlobalObj.longitude);
        _startIndex = 0;
        _selectedCity = city;
        [_cityChooseButton setTitle:city forState:UIControlStateNormal];
        [self getDistrictData];

    }
}

#pragma mark - CSTwoColumnsViewDelegate

- (void)twoColumnsView:(CSTwoColumnsView *)view businessDistrict:(NSString *)businessDistrict {
    [_nearButton setTitle:businessDistrict forState:UIControlStateNormal];
    [self refreshKTVData];
    [self nearButtonPressed:nil];
}

- (void)twoColumnsViewDidHide:(CSTwoColumnsView *)view {

    [self nearButtonPressed:nil];
}

- (void)twoColumnsViewDidClose:(CSTwoColumnsView *)view {
    [self nearButtonPressed:nil];
}

#pragma mark - CSSmartSortViewDelegate

- (void)smartSortView:(CSSmartSortView *)view didSelectType:(CSSmartSortViewType)type {
    switch (type) {
        case CSSmartSortViewTypeSmartSort:
            [_smartSortButton setTitle:@"智能排序" forState:UIControlStateNormal];
            [self refreshKTVData];
            break;
        case CSSmartSortViewTypeNearest:
            [_smartSortButton setTitle:@"离我最近" forState:UIControlStateNormal];
            _needLocateCity = NO;
//            [[CSLocationService sharedInstance] startGetLocation];
            [self refreshKTVData];
            break;
        case CSSmartSortViewTypeHottest:
            [_smartSortButton setTitle:@"人气最高" forState:UIControlStateNormal];
            [self refreshKTVData];
            break;
        case CSSmartSortViewTypeCheapest:
            [_smartSortButton setTitle:@"全网最低" forState:UIControlStateNormal];
            [self refreshKTVData];
            break;
        default:
            break;
    }
    [self smartSortBtnPressed:nil];
}

- (void)smartSortViewDidHide:(CSSmartSortView *)view {
    [self smartSortBtnPressed:nil];
}

#pragma mark - CSLocationServiceDelegate

- (void)locationService:(CSLocationService *)svc didGetCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
    if (_needLocateCity) {
        [[CSLocationService sharedInstance] getCityWithCoordinate:coordinate];
        _needLocateCity = NO;
    }
}

- (void)locationService:(CSLocationService *)svc didLocationInCity:(NSString *)city {
    // app自动查找到城市时，刷新数据
    _coordinate = CLLocationCoordinate2DMake(GlobalObj.latitude, GlobalObj.longitude);
    _startIndex = 0;
    _selectedCity = city;
    [_cityChooseButton setTitle:city forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger result = 0;
    if (_bldKTVData.count > 0)
        ++ result;
    if (_dianpingKTVData.count > 0)
        ++ result;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 0;
    if (section == 0)
        result = _bldKTVData.count > 0 ? _bldKTVData.count : _dianpingKTVData.count;
    else if (section == 1)
        result = _dianpingKTVData.count;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSKTVBookingCell *cell = [CSKTVBookingCell cellWithTableView:tableView];
    if ([CSUtil isLaterThanIOSVersion:8 include:YES]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    CSKTVModel *ktv;
    if (_bldKTVData.count) {
        if (indexPath.section == 0){
            ktv = _bldKTVData[indexPath.row];
        }
        else
            ktv = _dianpingKTVData[indexPath.row];
    }else{
    
        ktv = _dianpingKTVData[indexPath.row];
    }
    [cell setDataithKTVModel:ktv];
    cell.hiddenDistance = ![GlobalObj.locationCity isEqualToString:GlobalObj.currentCity];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(78);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"ReserveListItem"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    
    if (_bldKTVData.count) {

        // 宝乐迪的数据
        if (indexPath.section == 0) {
            CSShopDetailViewController *vc = [[CSShopDetailViewController alloc] init];
            vc.ktvItem = _bldKTVData[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
        // 大众点评的数据
        else {
            CSDianPingViewController *vc = [[CSDianPingViewController alloc] init];
            CSKTVModel* ktvModel = _dianpingKTVData[_selectedIndex];
            vc.ktvURL = ktvModel.shopUrl;
            vc.title = ktvModel.KTVName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        CSDianPingViewController *vc = [[CSDianPingViewController alloc] init];
        CSKTVModel* ktvModel = _dianpingKTVData[_selectedIndex];
        vc.ktvURL = ktvModel.shopUrl;
        vc.title = ktvModel.KTVName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 设置sectionHeader行高，宝乐迪KTV、大众点评KTV
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return TRANSFER_SIZE(20);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
        label.textColor = HEX_COLOR(0x9799a2);
        label.text = @"大众点评KTV";
        // 自定义header View
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = WhiteColor_Alpha_4;
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(TRANSFER_SIZE(10));
            make.top.equalTo(header);
            make.bottom.equalTo(header);
            make.right.equalTo(header);
        }];
        return header;
    }
    return nil;
}

- (void)networkReachability{
    [super networkReachability] ;
    [self refreshKTVData] ;
    [self getDistrictData] ;
}

@end
