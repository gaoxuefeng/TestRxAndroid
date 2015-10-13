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
#import "CSHomeActivityModel.h"

@interface CSHomeActivityListController ()
@property (nonatomic, strong) NSMutableArray *activitiesList ;
@property (nonatomic, assign) NSInteger startIndex ;

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.backgroundColor =HEX_COLOR(0x1b162f);

    self.title = self.titleName ;
    // 请求数据
    [self asyncGetHomeActivityDataByactivityType:[NSNumber numberWithInteger:_activityType] startIndex:0] ;
    
    // 集成刷新控件
    [self setupRefreshView] ;
}

#pragma mark - 请求数据
- (void)asyncGetHomeActivityDataByactivityType:(NSNumber *)activityType startIndex:(NSNumber *)startIndex{
    [[CSDataService sharedInstance] asyncGetHomeActivityDataByactivityType:activityType startIndex:startIndex handler:^(NSArray *activities) {
        if (activities.count) {
            _startIndex += activities.count ;
            [self.activitiesList addObjectsFromArray:activities] ;
            [self.tableView reloadData] ;
        }else{
            [self.tableView.footer noticeNoMoreData] ;
        }
    }] ;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView{
    WS(ws) ;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws asyncGetHomeActivityDataByactivityType:[NSNumber numberWithInteger:_activityType] startIndex:[NSNumber numberWithInteger:_startIndex]] ;
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
    NSArray * activityId =[[NSUserDefaults standardUserDefaults]objectForKey:@"activityId"];
    activityCell.praiseButton.selected = [activityId containsObject:activity.activityId] ? YES :NO;
    return activityCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRANSFER_SIZE(187) ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSHomeActivityDetailController *detailVC = [[CSHomeActivityDetailController alloc] init] ;
    CSHomeActivityModel *activityModel = self.activitiesList[indexPath.row] ;
    detailVC.htmlUrl = activityModel.htmlUrl;
    detailVC.shareTitle = activityModel.activityTheme;
    detailVC.htmlUrl= activityModel.htmlUrl;
    [self.navigationController pushViewController:detailVC animated:YES] ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1 ;
    [self.navigationController.navigationBar setBarTintColor:HEX_COLOR(0x1b162f)];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:HEX_COLOR(0x151417)];

}
@end
