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
#import "ActivityCityView.h"
#import "CSLoginViewController.h"
#import "CSHttpTool.h"
#import "SVProgressHUD.h"
#import <Masonry.h>
#import "WMPageController.h"

static NSString *const WMControllerDidFullyDisplayedNotification = @"WMControllerDidFinishInitNotification";

@interface CSActivityStyleViewController ()
{
    NSString * _cityName;
    NSString * _tag;
    // 标记请求页数
    NSInteger       _startIndex ;
    BOOL _isInit;//判断是否加载
    ActivityCityView * _cityView;
}
@property (nonatomic,strong)NSMutableArray * activity;
@end

@implementation CSActivityStyleViewController

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData:) name:WMControllerDidFullyDisplayedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    self.view.backgroundColor =[UIColor clearColor];
    self.parentViewController.navigationItem.title=@"潮趴汇活动";
    if (!self.parentViewController.navigationItem.leftBarButtonItem) {
        UIBarButtonItem * leftCiytBar = [[UIBarButtonItem alloc]initWithTitle:@"全国 ▾" style:UIBarButtonItemStylePlain target:self action:@selector(clickCity)];
        [leftCiytBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"Helvetica-Bold" size:14.0], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"cityName"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"cityRow"];

        self.parentViewController.navigationItem.leftBarButtonItem = leftCiytBar;
    }
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
    if ([_cityName isEqualToString:@"全国"]) {
        _cityName=nil;
    }
    _startIndex= 0;
    _isInit=NO;
    [self setupRefreshView];
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refreshAcitityMoreData] ;
        [_tableView.footer endRefreshing];
    }] ;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshAcitityData];
        [_tableView.header endRefreshing];
    }] ;
}
#pragma mark 刷新走的走的网络请求
- (void)refreshAcitityData{

    [self refreshAcitivityDataWithCityName:_cityName Tag:_tag StartIndex:0];

}
#pragma mark 加载更多走的网络请求
- (void)refreshAcitityMoreData{
    
    [[CSDataService sharedInstance]asyncGetActivityWithCityName:_cityName Tag:_tag StartIndex:[NSNumber numberWithInteger:_startIndex] handler:^(NSArray *acitivity) {
        if (acitivity.count) {
            if (acitivity.count <10) {
                [self.tableView.footer noticeNoMoreData] ;
            }
            [self.activity addObjectsFromArray:acitivity];
            _startIndex = _activity.count ;
        }else{
            [self.tableView.footer noticeNoMoreData] ;
        }
        [self.tableView reloadData];
    }];
    
}
#pragma mark 刷新走的走的网络请求
- (void)refreshAcitivityDataWithCityName :(NSString *)cityName Tag :(NSString * )tag StartIndex:(NSNumber *)startIndex {
    if (GlobalObj.latitude==0&&GlobalObj.longitude==0&&!GlobalObj.locationCity) {
        [[CSLocationService sharedInstance]startGetLocation];
    }
    [[CSDataService sharedInstance]asyncGetActivityWithCityName:cityName Tag:tag StartIndex:startIndex handler:^(NSArray *acitivity) {
        self.activity = [NSMutableArray array];
        if (acitivity.count) {
            if (acitivity.count<10) {
                [self.tableView.footer noticeNoMoreData] ;
            }else{
                [self.tableView.footer resetNoMoreData];
            }
            _startIndex = 0;
            [self.activity addObjectsFromArray:acitivity];
            _startIndex += _activity.count ;
        }else{
            self.tableView.footer.hidden=YES;
        }
        [self.tableView reloadData];
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
    static NSString * cellIdentifier = @"ActivityCell";
    ActivityCell *activityCell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
    if (SCREENHEIGHT>=667) {
        return TRANSFER_SIZE(160);
    }else
        return TRANSFER_SIZE(130);

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSActivityModel * activity = _activity[indexPath.row];
    if ([activity.uidpass intValue]) {
        if (GlobalObj.isLogin) {
            [self pushActivityDetailWithIndexPath:indexPath];
        }else{
            CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
            loginVc.loginBlock = ^(BOOL loginSuccess){
                [self.navigationController popViewControllerAnimated:YES];
                [self pushActivityDetailWithIndexPath:indexPath];
            };
        }
    }else{
        [self pushActivityDetailWithIndexPath:indexPath];
    }
}
- (void)pushActivityDetailWithIndexPath:(NSIndexPath *)indexPath{
    CSHomeActivityDetailController *vc = [[CSHomeActivityDetailController alloc] init];
    CSActivityModel * activity = _activity[indexPath.row];
    vc.shareTitle = activity.activityTheme;
    vc.shareContent= activity.shareTitle;
    NSString * urlString =[NSString stringWithFormat:@"%@?uid=%@&userName=%@",activity.htmlUrl,GlobalObj.token,GlobalObj.userInfo.nickName];
    NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    vc.htmlUrl= [activity.uidpass intValue] ? encodedString : activity.htmlUrl;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCityName:) name:@"ChangeCityName" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAcitityData) name:NET_WORK_REACHABILITY object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated] ;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)refreshData:(NSNotification * )notification{
    if (!_isInit) {
        CSLog(@"+++++++++++++++++++%@",notification);
        _tag =[notification.object objectForKey:@"title"];
        if ([_tag isEqualToString:@"全部"]) {
            _tag=nil;
        }
        [self refreshAcitivityDataWithCityName:_cityName Tag:_tag StartIndex:nil];
        _isInit=YES;
    }
}
-(void)changeCityName:(NSNotification * )notification{
    
    CSLog(@"%@",notification);
    ;
    _cityName = [notification.object objectForKey:@"cityName"];
    self.parentViewController.navigationItem.leftBarButtonItem.title=[NSString stringWithFormat:@"%@ ▾",_cityName ];

    if ([_cityName isEqualToString:@"全国"]) {
        _cityName=nil;
    }
    [self refreshAcitivityDataWithCityName:_cityName Tag:_tag StartIndex:nil];
    
}

#pragma mark 跳转到城市选择页面
- (void)clickCity{
    
    if (GlobalObj.cityName==nil) {
        [self getActivityCity];
    }else{
;
        [_cityView bringSubviewToFront:self.parentViewController.view];
        [_cityView cityAnimate];
    }
}

-(void)getActivityCity{
    [CSHttpTool get:[NSString stringWithFormat:@"%@%@", ServiceCloudURL, ActivityCityProtocol] params:nil success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"]intValue]==ResponseStateSuccess) {
            GlobalObj.cityName = [NSMutableArray arrayWithArray:[[responseObj objectForKey:@"data"] objectForKey:@"cityNames"]];
            [GlobalObj.cityName insertObject:@"全国" atIndex:0];
            [self creatCityView];
            [_cityView bringSubviewToFront:self.parentViewController.view];
            [_cityView cityAnimate];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"当前网络出现异常，请检查你的网络设置"];
    }];
    
}
//
//-(void)changeCityName:(NSNotification * )notification{
//    
//    CSLog(@"%@",notification);
//    ;
//    [cityBut setTitle:[NSString stringWithFormat:@"%@ ▾",[notification.object objectForKey:@"cityName"] ] forState:UIControlStateNormal];
//
//}
- (void)creatCityView{
    
    _cityView =[[ActivityCityView alloc]initWithFrame:CGRectMake(0, -664, SCREENWIDTH, SCREENHEIGHT-113)];
    GlobalObj.cityView=_cityView;
    [ [UIApplication sharedApplication].windows[0] addSubview:_cityView];
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
