//
//  CSMyCostViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyCostViewController.h"
#import <Masonry.h>
#import "CSSegmentControl.h"
#import "CSMyCostTableViewCell.h"
#import "CSMyCostDishTableViewCell.h"
#import "CSRoomDetailViewController.h"
#import "CSDishDetailViewController.h"
#import "CSMyInfoHttpTool.h"
#import <MJRefresh.h>
@interface CSMyCostViewController ()<UIScrollViewDelegate,CSSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_scrollView;
    UITableView *_inProgressTableView;
    UITableView *_historyTableView;
}
@property(nonatomic, weak) CSSegmentControl *segmentControl;
/** 进行中数据 */
@property(nonatomic, strong) NSMutableArray *inProgressDatas;
/** 历史数据 */
@property(nonatomic, strong) NSMutableArray *historyDatas;

@end

@implementation CSMyCostViewController
#pragma mark - Lazy Load
- (NSMutableArray *)inProgressDatas
{
    if (!_inProgressDatas) {
        _inProgressDatas = [NSMutableArray array];
    }
    return _inProgressDatas;
}

- (NSMutableArray *)historyDatas
{
    if (!_historyDatas) {
        _historyDatas = [NSMutableArray array];
    }
    return _historyDatas;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消费";
    [self setupSubViews];
    [self loadMoreDataWithTableView:_inProgressTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Setup
- (void)setupSubViews
{
    CSSegmentControl *segmentControl = [[CSSegmentControl alloc] initWithTitles:@[@"进行中",@"历史消费"]];
    _segmentControl = segmentControl;
    segmentControl.delegate = self;
    segmentControl.backgroundColor = HEX_COLOR(0x222126);
    segmentControl.titleColor = HEX_COLOR(0x9898a2);
    segmentControl.selectedTitleColor = HEX_COLOR(0xf03da2);
    segmentControl.blockColor = HEX_COLOR(0xf03da2);
    segmentControl.blockEdgeInsets = UIEdgeInsetsMake(0.0, 27.0, 0.0, 27.0);
    [self.view addSubview:segmentControl];
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(TRANSFER_SIZE(34.0));
    }];
    
    UIView *segmentControlTopLine = [[UIView alloc] init];
    segmentControlTopLine.backgroundColor = HEX_COLOR(0x141417);
    [segmentControl addSubview:segmentControlTopLine];
    [segmentControlTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(segmentControlTopLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
    UIView *segmentControlCenterLine = [[UIView alloc] init];
    segmentControlCenterLine.backgroundColor = HEX_COLOR(0x141417);
    [segmentControl addSubview:segmentControlCenterLine];
    [segmentControlCenterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(segmentControlCenterLine.superview);
        make.size.mas_equalTo(CGSizeMake(1 / [UIScreen mainScreen].scale, TRANSFER_SIZE(14.0)));
    }];
    UIView *segmentControlBottomLine = [[UIView alloc] init];
    segmentControlBottomLine.backgroundColor = HEX_COLOR(0x141417);
    [segmentControl addSubview:segmentControlBottomLine];
    [segmentControlBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(segmentControlBottomLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
//    _scrollView.delegate = self;
    segmentControl.scrollView = _scrollView;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(segmentControl.mas_bottom);
    }];
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    _inProgressTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _inProgressTableView.backgroundColor = HEX_COLOR(0x1d1c21);
    _inProgressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _inProgressTableView.delegate = self;
    _inProgressTableView.dataSource = self;
    
    MJRefreshAutoNormalFooter *inProgressFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [inProgressFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [inProgressFooter setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [inProgressFooter setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    inProgressFooter.stateLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    // 设置颜色
    inProgressFooter.stateLabel.textColor = [UIColor whiteColor];
    _inProgressTableView.footer = inProgressFooter;

    
    [container addSubview:_inProgressTableView];
    [_inProgressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(container);
        make.width.mas_equalTo(self.view);
    }];
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _historyTableView.backgroundColor = HEX_COLOR(0x1d1c21);
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    MJRefreshAutoNormalFooter *historyFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [historyFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [historyFooter setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [historyFooter setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    historyFooter.stateLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    // 设置颜色
    historyFooter.stateLabel.textColor = [UIColor whiteColor];
    _historyTableView.footer = historyFooter;
//    _historyFooter = historyFooter;
    [container addSubview:_historyTableView];
    [_historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(container);
        make.left.equalTo(_inProgressTableView.mas_right);
        make.width.mas_equalTo(self.view);
        make.right.equalTo(container);
    }];
}



//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (_scrollView == scrollView) {
//        _segmentControl.blockX = scrollView.contentOffset.x * 0.5;
//    }
//}

#pragma mark - CSSegmentControlDelegate
//- (void)segmentControl:(CSSegmentControl *)segmentControl selectedIndex:(NSInteger)selectedIndex
//{
//    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH * selectedIndex, 0) animated:YES];
//}

- (void)selectedChanged:(NSInteger)selectedIndex
{
    UITableView *currentTableView = selectedIndex?_historyTableView:_inProgressTableView;
    [self loadMoreDataWithTableView:currentTableView];
    [currentTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _inProgressTableView) {
        return self.inProgressDatas.count;
    }else
    {
        return self.historyDatas.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *datas = tableView == _inProgressTableView?_inProgressDatas:_historyDatas;
    CSMyCostModel *item = datas[indexPath.section];
    switch (item.orderType.integerValue) {
        case CSMyCostTypeRoom:
        {
            CSMyCostTableViewCell *cell = [CSMyCostTableViewCell cellWithTableView:tableView];
            cell.item = item;
            return cell;
            break;
        }
        case CSMyCostTypeRoomDish:
        case CSMyCostTypeCloudDish:
        {
            CSMyCostDishTableViewCell *cell = [CSMyCostDishTableViewCell cellWithTableView:tableView];
            cell.item = item;
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TRANSFER_SIZE(9.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMyCostModel *item;
    if (tableView == _inProgressTableView) { // 进行时
        item = _inProgressDatas[indexPath.section];
    }else
    {
        item = _historyDatas[indexPath.section];
    }
    return item.orderType.integerValue == CSMyCostTypeRoom?TRANSFER_SIZE(95.0):TRANSFER_SIZE(77.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *datas = tableView == _inProgressTableView?_inProgressDatas:_historyDatas;
    CSMyCostModel *item = datas[indexPath.section];
    switch (item.orderType.integerValue) {
        case CSMyCostTypeCloudDish:
        case CSMyCostTypeRoomDish:
        {
            CSDishDetailViewController *dishDetailVc = [[CSDishDetailViewController alloc] initWithOrderId:item.reserveGoodsId];
            [self.navigationController pushViewController:dishDetailVc animated:YES];
            break;
        }
        case CSMyCostTypeRoom:
        {
            CSRoomDetailViewController *roomDetailVc = [[CSRoomDetailViewController alloc] initWithOrderId:item.reserveBoxId];
            [self.navigationController pushViewController:roomDetailVc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)loadMoreDataWithTableView:(UITableView *)tableView
{
    CSRequest *param = [[CSRequest alloc] init];
    NSMutableArray *datas;
    if (tableView == _inProgressTableView) {
        param.action = @0;
        datas = self.inProgressDatas;
    }else
    {
        param.action = @1;
        datas = self.historyDatas;
    }
    param.startIndex = [NSNumber numberWithInteger:datas.count];
    [CSMyInfoHttpTool getCostListWithParam:param success:^(CSMyCostResponseModel *result) {
        [tableView.footer endRefreshing];
        if (result.code == ResponseStateSuccess) {
            [datas addObjectsFromArray:result.data];
            if (result.data.count < 10) {
                tableView.footer.hidden = YES;
            }
            [tableView reloadData];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
        [tableView.footer endRefreshing];
    }];
}

- (void)loadMoreData
{
    [self loadMoreDataWithTableView:_segmentControl.currentIndex?_historyTableView:_inProgressTableView];
}


- (void)dealloc
{
    _inProgressTableView.delegate = nil;
    _inProgressTableView.dataSource = nil;
    _historyTableView.delegate = nil;
    _historyTableView.dataSource = nil;
}

@end
