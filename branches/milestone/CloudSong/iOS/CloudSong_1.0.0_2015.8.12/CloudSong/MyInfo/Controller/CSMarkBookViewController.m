//
//  CSMarkBookViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMarkBookViewController.h"
#import "CSMarkBookModel.h"
#import "CSMarkBookTableViewCell.h"
#import "CSDefine.h"
#import "CSMarkBookDetailViewController.h"
@interface CSMarkBookViewController ()
@property(nonatomic, strong) NSArray *tableViewDatas;
@end

@implementation CSMarkBookViewController

//- (NSArray *)tableViewDatas
//{
//    if (!_tableViewDatas) {
//        CSMarkBookModel *model = [[CSMarkBookModel alloc] init];
//        model.ktvName = @"宝乐迪量贩KTV九棵松店";
//        model.date = @"2015-04-19 19:00:20:00";
//        _tableViewDatas = @[model];
//    }
//    return _tableViewDatas;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"纪念册";
    self.tableView.rowHeight = TRANSFER_SIZE(60.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMarkBookTableViewCell *cell = [CSMarkBookTableViewCell cellWithTableView:tableView];
    cell.item = self.tableViewDatas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMarkBookModel *item = self.tableViewDatas[indexPath.row];
    [self.navigationController pushViewController:[[CSMarkBookDetailViewController alloc] initWithUrl:item.url] animated:YES];
}

@end
