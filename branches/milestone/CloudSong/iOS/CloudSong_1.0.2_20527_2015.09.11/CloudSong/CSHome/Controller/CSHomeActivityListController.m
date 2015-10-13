//
//  CSHomeActivityListController.m
//  CloudSong
//
//  Created by EThank on 15/7/28.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeActivityListController.h"
#import "ActivityCell.h"
#import "CSHomeActivityListController.h"
#import "CSDataService.h"
#import <MJRefresh.h>
#import "CSHomeActivityDetailController.h"
#import "CSActivityModel.h"
#import "CSLoginViewController.h"

@interface CSHomeActivityListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *activitiesList ;
@property (nonatomic, assign) NSInteger startIndex ;

@property (nonatomic, weak) UITableView *tableView ;

@property (nonatomic, assign) NSInteger activityType ;
@end

@implementation CSHomeActivityListController

- (NSMutableArray *)activitiesList{
    if (_activitiesList == nil) {
        _activitiesList = [NSMutableArray array] ;
    }
    return _activitiesList ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView] ;
    
//    self.title = self.titleName ;
    
    // 集成刷新控件
    [self setupRefreshView] ;
}
- (void)setupSubView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49)] ;
    [self.view addSubview:tableView] ;
    self.tableView = tableView ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.backgroundColor = [UIColor clearColor] ;
}

- (void)setActivityTagModel:(CSHomeActivityTagModel *)activityTagModel{
    
    _activityTagModel = activityTagModel ;
    
    self.title = activityTagModel.name ;
    
//    NSString *requestUrl = activityTagModel.requestUrl ;
//    if (requestUrl != nil || requestUrl.length != 0) {
//        NSString *lastChar = [requestUrl substringFromIndex:requestUrl.length -1] ;
//        _activityType = [lastChar integerValue] ;
//    }
    
    // 请求数据
    [self asyncGetHomeActivityTagListDataByRequestUrl:activityTagModel.requestUrl Type:activityTagModel.activityType startIndex:[NSNumber numberWithInteger:_startIndex]] ;
//    
//    [self asyncGetHomeActivityTagListDataByType:[NSNumber numberWithInteger:_activityTagModel.activityType]  startIndex:[NSNumber numberWithInteger:_startIndex] ] ;

}


#pragma mark - 请求数据
- (void)asyncGetHomeActivityTagListDataByRequestUrl:(NSString *)requestUrl Type:(NSNumber *)activityType startIndex:(NSNumber *)startIndex{
    
    [[CSDataService sharedInstance] asyncGetHomeActivityTagListByRequestUrl:requestUrl Type:activityType startIndex:startIndex handler:^(NSArray *activities) {
        if (activities.count) {
            _startIndex += activities.count ;
            [self.activitiesList addObjectsFromArray:activities] ;
        }else{
            [self.tableView.footer noticeNoMoreData] ;
        }
        [self.tableView reloadData] ;
    }] ;
    
//    [[CSDataService sharedInstance] asyncGetHomeActivityTagListByactivityType:activityType startIndex:[NSNumber numberWithInteger:_startIndex] handler:^(NSArray *activities) {
//        if (activities.count) {
//            _startIndex += activities.count ;
//            [self.activitiesList addObjectsFromArray:activities] ;
//        }else{
//            [self.tableView.footer noticeNoMoreData] ;
//        }
//        [self.tableView reloadData] ;
//
//    }] ;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView{
    WS(ws) ;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self asyncGetHomeActivityTagListDataByRequestUrl:_activityTagModel.requestUrl Type:_activityTagModel.activityType startIndex:[NSNumber numberWithInteger:_startIndex]] ;
        [ws.tableView.footer endRefreshing] ;
    }] ;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activitiesList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ActivityCell";
    ActivityCell *activityCell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (activityCell == nil)
    {
        activityCell= (ActivityCell *)[[[NSBundle  mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil] firstObject];
        activityCell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    CSActivityModel* activity =self.activitiesList[indexPath.row];
    activityCell.activity = activity ;
//    NSArray * activityId =[[NSUserDefaults standardUserDefaults]objectForKey:@"activityId"];
//    activityCell.praiseButton.selected = [activityId containsObject:activity.activityId] ? YES :NO;
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
    CSActivityModel * activity = _activitiesList[indexPath.row];
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
    CSActivityModel *actModel = self.activitiesList[indexPath.row] ;
    NSString * urlString =[NSString stringWithFormat:@"%@?uid=%@&userName=%@",actModel.htmlUrl,GlobalObj.token,GlobalObj.userInfo.nickName];
    NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    detailVC.htmlUrl= [actModel.uidpass intValue] ? encodedString : actModel.htmlUrl;
    detailVC.shareTitle = actModel.activityTheme;
    detailVC.shareContent = actModel.shareTitle;
    detailVC.shareUrl = actModel.shareUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)networkReachability
{
    [super networkReachability];
    [self asyncGetHomeActivityTagListDataByRequestUrl:_activityTagModel.requestUrl Type:_activityTagModel.activityType startIndex:[NSNumber numberWithInteger:_startIndex]] ;
}

@end
