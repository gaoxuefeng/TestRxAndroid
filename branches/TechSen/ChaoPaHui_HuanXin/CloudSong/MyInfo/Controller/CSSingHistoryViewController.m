//
//  CSSingHistoryViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSingHistoryViewController.h"
#import <Masonry.h>
#import "CSSingHistoryTableViewCell.h"
@interface CSSingHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic, strong) NSArray *tableViewdatas;
@end

@implementation CSSingHistoryViewController

- (NSArray *)tableViewdatas
{
    if (!_tableViewdatas) {
        CSSong *item = [[CSSong alloc] init];
        item.language = @"国语";
        CSSinger *singer = [[CSSinger alloc] init];
        singer.singerName = @"胡夏";
        item.singers = @[singer];
        item.songName = @"那些年";
        _tableViewdatas = @[item];
    }
    return _tableViewdatas;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点唱历史";
    [self setupSubViews];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupTableView];
}
- (void)setupTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = HEX_COLOR(0x1d1c21);
    _tableView.rowHeight = TRANSFER_SIZE(82.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Config


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewdatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSSingHistoryTableViewCell *cell = [CSSingHistoryTableViewCell cellWithTableView:tableView];
    cell.item = self.tableViewdatas[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate



#pragma mark - Action


@end
