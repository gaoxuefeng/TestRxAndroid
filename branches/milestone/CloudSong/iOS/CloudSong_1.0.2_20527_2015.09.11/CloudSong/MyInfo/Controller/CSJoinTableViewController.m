//
//  CSJoinTableViewController.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSJoinTableViewController.h"
#import "CSJoinTableViewCell.h"
#import "CSDefine.h"
#import "CSMyInfoHttpTool.h"
#import "SVProgressHUD.h"
@interface CSJoinTableViewController ()
@property(nonatomic, copy) NSString *reserveBoxId;
@property(nonatomic, strong) NSArray *tableViewDatas;

@end

@implementation CSJoinTableViewController

- (instancetype)initWithReserveBoxId:(NSString *)reserveBoxId
{
    _reserveBoxId = reserveBoxId;
    return [self init];
}
//- (NSArray *)tableViewDatas
//{
//    if (!_tableViewDatas) {
//        CSJoinModel *item = [[CSJoinModel alloc] init];
//        item.nickName = @"哈哈哈";
//        item.gender = @"男";
//        item.phoneNum = @"18888888888";
//        item.date = @"已加入8分钟";
//        
//        CSJoinModel *item1 = [[CSJoinModel alloc] init];
//        item1.nickName = @"哈哈哈";
//        item1.gender = @"女";
//        item1.phoneNum = @"18888888888";
//        item1.date = @"已加入8分钟";
//        _tableViewDatas = @[item,item1];
//    }
//    return _tableViewDatas;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"已参与";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = TRANSFER_SIZE(70.0);
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSJoinTableViewCell *cell = [CSJoinTableViewCell cellWithTableView:tableView];
    cell.item = self.tableViewDatas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDeleate


#pragma mark - Load Data
- (void)loadData
{
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _reserveBoxId;
    [CSMyInfoHttpTool getRoomMembersWithParam:param success:^(CSRoomMemberResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            _tableViewDatas = result.data;
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
    
}

@end
