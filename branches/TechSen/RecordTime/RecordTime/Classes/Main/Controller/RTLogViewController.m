//
//  RTLogViewController.m
//  RecordTime
//
//  Created by sen on 9/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTLogViewController.h"
#import "FMDBTool.h"
#import "RTLogTableViewCell.h"
@interface RTLogViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(weak, nonatomic) UITableView *tableView;

@property(strong, nonatomic) NSArray *logItems;

@end


@implementation RTLogViewController

- (NSArray *)logItems
{
    if (!_logItems) {
        _logItems = [FMDBTool queryAllDatePoint];
    }
    return _logItems;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"日志";
    [self setupSubviews];
}


#pragma mark - Setup
- (void)setupSubviews
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableView.superview);
    }];
    _tableView = tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTLogTableViewCell *cell = [RTLogTableViewCell cellWithTableView:tableView];
    cell.items = self.logItems[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate




@end
