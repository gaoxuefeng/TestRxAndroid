//
//  CSActivityStyleViewController.m
//  CloudSong
//
//  Created by 汪辉 on 15/7/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSActivityStyleViewController.h"
#import "ActivityCell.h"
#import "CSDataService.h"
#import "CSActivityModel.h"
#import <MJRefresh.h>
#import "CSNavigationController.h"
#import "CSHomeActivityDetailController.h"

static NSString *const WMControllerDidFullyDisplayedNotification = @"WMControllerDidFinishInitNotification";

@interface CSActivityStyleViewController ()
{
    NSString * _cityName;
    NSString * _tag;
    // 标记请求页数
    NSInteger       _startIndex ;
    BOOL _isInit;//判断是否加载
}
@property (nonatomic,strong)NSMutableArray * activity;
@end

@implementation CSActivityStyleViewController

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData:) name:WMControllerDidFullyDisplayedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCityName:) name:@"ChangeCityName" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
    if ([_cityName isEqualToString:@"全国"]) {
        _cityName=nil;
    }
    _startIndex= 0;
    self.view.backgroundColor =HEX_COLOR(0x1b162f);
    _isInit=NO;
    [self setupRefreshView];
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refreshAcitityData] ;
        [_tableView.footer endRefreshing] ;
    }] ;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshAcitivityDataWithCityName:_cityName Tag:_tag StartIndex:0];
        [_tableView.header endRefreshing] ;
    }] ;
}
#pragma mark 加载更多走的网络请求
- (void)refreshAcitityData{
    
    [[CSDataService sharedInstance]asyncGetActivityWithCityName:_cityName Tag:_tag StartIndex:[NSNumber numberWithInteger:_startIndex] handler:^(NSArray *acitivity) {
        if (acitivity.count) {
            _startIndex += _activity.count ;
            [self.activity addObjectsFromArray:acitivity];
            [self.tableView reloadData];
        }else
            [self.tableView.footer noticeNoMoreData] ;

    }];
    
}
#pragma mark 刷新走的走的网络请求
- (void)refreshAcitivityDataWithCityName :(NSString *)cityName Tag :(NSString * )tag StartIndex:(NSNumber *)startIndex {
    
    [[CSDataService sharedInstance]asyncGetActivityWithCityName:cityName Tag:tag StartIndex:startIndex handler:^(NSArray *acitivity) {
        if (acitivity.count) {
            _startIndex = 0;
            [self.tableView.footer resetNoMoreData];
            self.activity = [NSMutableArray array];
            [self.activity addObjectsFromArray:acitivity];
            _startIndex += _activity.count ;
            [self.tableView reloadData];
        }else
            [self.tableView.footer noticeNoMoreData] ;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _activity.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"ActivityCell";
    ActivityCell *activityCell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (activityCell == nil)
    {
        activityCell= (ActivityCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ActivityCell" owner:self options:nil] firstObject];
    }
    activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CSActivityModel * activity =[_activity objectAtIndex:indexPath.row];
    activityCell.activity =activity;
    NSArray * activityId =[[NSUserDefaults standardUserDefaults]objectForKey:@"activityId"];
    activityCell.praiseButton.selected = [activityId containsObject:activity.activityId] ? YES :NO;
    return activityCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 187;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSHomeActivityDetailController *vc = [[CSHomeActivityDetailController alloc] init];
    CSActivityModel * activity = _activity[indexPath.row];
    vc.shareTitle = activity.activityTheme;
    vc.shareTitle = activity.activityTheme;
    vc.htmlUrl= activity.htmlUrl;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    CSNavigationController * navC = (CSNavigationController *) self.parentViewController.parentViewController;
    [navC.navigationBar setBarTintColor:HEX_COLOR(0x1b162f)];
    [super viewWillAppear:animated] ;
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated] ;
}

-(void)refreshData:(NSNotification * )notification{
    if (!_isInit) {
        NSLog(@"+++++++++++++++++++%@",notification);
        _tag =[notification.object objectForKey:@"title"];
        if ([_tag isEqualToString:@"全部"]) {
            _tag=nil;
        }
        [self refreshAcitivityDataWithCityName:_cityName Tag:_tag StartIndex:nil];
        _isInit=YES;
    }
}
-(void)changeCityName:(NSNotification * )notification{
    
    NSLog(@"%@",notification);
    ;
    _cityName = [notification.object objectForKey:@"cityName"];
    if ([_cityName isEqualToString:@"全国"]) {
        _cityName=nil;
    }
    [self refreshAcitivityDataWithCityName:_cityName Tag:_tag StartIndex:nil];
    
    
}
-(NSMutableArray *)activity{
    if (_activity ==nil) {
        _activity = [NSMutableArray array];
    }
    return _activity;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
