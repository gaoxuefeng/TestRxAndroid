//
//  CSSingersClassifiedTableViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSingersClassifiedTableViewController.h"
#import "CSDataService.h"
#import <UIImageView+WebCache.h>
#import "CSSinger.h"
#import "CSSingerCell.h"
#import "CSUtil.h"
#import "CSDefine.h"
#import "CSSongListTableViewController.h"
#import <MJRefresh.h>
#import "CSSearchViewController.h"
#import "CSNavigationController.h"
#import <MobClick.h>


@interface CSSingersClassifiedTableViewController () {
    NSMutableArray*    _singersClassified;
    NSInteger          _responseDataCount ;
    NSInteger _startIndex;
}
@end

static NSString* identifier = @"CSSingerCell";

@implementation CSSingersClassifiedTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _startIndex = 0 ;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 64);
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _singersClassified = [NSMutableArray array];
    [self.tableView registerClass:[CSSingerCell class] forCellReuseIdentifier:identifier];
    [CSUtil hideEmptySeparatorForTableView:self.tableView];
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // 集成刷新控件
    [self setupRefreshView] ;
    [self.tableView.header beginRefreshing] ;
}
#pragma mark - Action Methods

- (void)searchBtnPressed {
    CSSearchViewController *vc = [[CSSearchViewController alloc] init];
    CSNavigationController *nav = [[CSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self asyncGetSingers] ;
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    __weak UITableView *tableView = self.tableView ;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _startIndex = 0 ;
//        [self asyncGetSingers] ;
//        [tableView.header endRefreshing] ;
//    }] ;
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _startIndex += _responseDataCount ;
        [self asyncGetSingers] ;
        [tableView.footer endRefreshing] ;
    }] ;
}

#pragma mark - 获取歌星列表
- (void)asyncGetSingers
{
    __weak UITableView *tableView = self.tableView ;
    [[CSDataService sharedInstance] asyncGetSingersClassifiedWithType:self.type startIndex:_startIndex handler:^(NSArray *singers) {
//        if (_startIndex == 0) {
//            [_singersClassified removeAllObjects] ;
//            [_singersClassified addObjectsFromArray:singers] ;
//            [tableView.footer resetNoMoreData] ;
//        }else{
        _responseDataCount = singers.count ;
        if (_responseDataCount == 0) {
            [tableView.footer noticeNoMoreData] ;
        }
        [_singersClassified addObjectsFromArray:singers] ;
        
//        }
        [tableView reloadData];
    }];

}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _singersClassified.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSSingerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setDataWithSinger:_singersClassified[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(71);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"RsCateSinger"];//歌星名
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    CSSinger *singer = _singersClassified[indexPath.row];
    vc.isSeach=YES;
    vc.title = singer.singerName;
    vc.type = CSSongListTableViewControllerTypeSinger;
    vc.singerID = singer.singerId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
