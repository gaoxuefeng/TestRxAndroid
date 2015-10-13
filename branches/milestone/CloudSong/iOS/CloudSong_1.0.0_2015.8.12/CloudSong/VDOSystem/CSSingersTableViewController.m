//
//  CSSingersTableViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSingersTableViewController.h"
#import "CSUtil.h"
#import "CSDataService.h"
#import "CSHotSingersCollectionViewCell.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSSingersClassifiedTableViewController.h"
#import "CSSingerHeaderView.h"
#import "CSSingersTableViewCell.h"
#import "CSSongListTableViewController.h"
#import "CSSinger.h"
#import "CSSearchViewController.h"
#import "CSNavigationController.h"
#import <MobClick.h>

@interface CSSingersTableViewController () <CSSingerHeaderViewDelegate> {
    NSArray*    _hotSingers;
    NSArray*    _titles;
}
@end

static NSString * const identifier = @"CSSingersTableViewCell";

@implementation CSSingersTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 64);
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.tableView.sectionHeaderHeight = 5 ;
    self.tableView.sectionFooterHeight = 5 ;
    self.tableView.backgroundColor = HEX_COLOR(0x151417);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CSSingersTableViewCell class] forCellReuseIdentifier:identifier];
    [CSUtil hideEmptySeparatorForTableView:self.tableView];
    
    // 设置headerView
    CGRect frame = self.tableView.bounds;
    frame.size.height = TRANSFER_SIZE(205);
    CSSingerHeaderView *header = [[CSSingerHeaderView alloc] initWithFrame:frame];
    header.delegate = self;
    self.tableView.tableHeaderView = header ;
    
    _titles = @[@[@"全部歌星"],
              @[@"华语男歌星", @"华语女歌星", @"华语组合",],
              @[@"港台男歌星", @"港台女歌星", @"港台组合"],
              @[@"欧美男歌星", @"欧美女歌星", @"欧美组合"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (NSInteger)indexInDoubleArray:(NSArray *)array withIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger arrayCount = array.count;
    NSMutableArray *sectionCounts = [NSMutableArray arrayWithCapacity:arrayCount];
    NSInteger totalIndexCount = 0;
    for (int i = 0; i < arrayCount; i++) {
        NSInteger sectionCount = 0;
        for (int j = 0; j < [array[i] count]; j++) {
            totalIndexCount++;
            sectionCount++;
        }
        [sectionCounts addObject:[NSNumber numberWithInteger:sectionCount]];
    }
    NSInteger section = indexPath.section;
    NSInteger previousCount = 0;
    for (int i = 0; i < section; i++) {
        previousCount += [sectionCounts[i] integerValue];
    }
    return previousCount + indexPath.row;
}

#pragma mark - Action Methods

- (void)searchBtnPressed {
    CSSearchViewController *vc = [[CSSearchViewController alloc] init];
    CSNavigationController *nav = [[CSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}

#pragma mark - CSSingerHeaderViewDelegate

- (void)singerHeaderView:(CSSingerHeaderView *)view didSelectSinger:(CSSinger *)singer {
    [MobClick event:@"RsCateSinger"];//歌星名
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.isSeach=YES;
    vc.title = singer.singerName;
    vc.type = CSSongListTableViewControllerTypeSinger;
    vc.singerID = singer.singerId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1 ;
    }
    return 3 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSSingersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setTitle:_titles[indexPath.section][indexPath.row]];
    NSInteger numberOfRowsInSetion = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
    CSSingersTableViewCellType type;
    if (numberOfRowsInSetion == 1)
        type = CSSingersTableViewCellTypeSingle;
    else {
        if (indexPath.row == 0)
            type = CSSingersTableViewCellTypeTop;
        else if (indexPath.row == numberOfRowsInSetion - 1)
            type = CSSingersTableViewCellTypeBottom;
        else
            type = CSSingersTableViewCellTypeMiddle;
    }
    [cell setCellType:type];
    return cell ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CSSingersClassifiedTableViewController *vc = [[CSSingersClassifiedTableViewController alloc] init];
    vc.type = [self indexInDoubleArray:_titles withIndexPath:indexPath] + 1;
    vc.title = _titles[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TRANSFER_SIZE(4);
}

@end







