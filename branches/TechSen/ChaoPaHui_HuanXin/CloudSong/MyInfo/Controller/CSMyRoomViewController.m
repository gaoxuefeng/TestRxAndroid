//
//  CSMyRoomViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyRoomViewController.h"
#import <Masonry.h>
#import "CSBackBarButtonItem.h"
#import "CSMyRoomTableViewCell.h"
#import "CSJoinTableViewController.h"
#import "CSInRoomViewController.h"
#import "CSNavigationController.h"
#import "CSMyInfoHttpTool.h"
#import "CSKTVMapViewController.h"
#import "CSAlterTabBarTool.h"
#import "SVProgressHUD.h"
@interface CSMyRoomViewController ()<UITableViewDataSource,UITableViewDelegate,CSMyRoomTableViewCellDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic, strong) NSArray *tableViewDatas;
@end

@implementation CSMyRoomViewController

//- (NSArray *)tableViewDatas
//{
//    if (!_tableViewDatas) {
//        CSMyRoomModel *item = [[CSMyRoomModel alloc] init];
//        item.reservationName = @"TechSen";
////        item.createrGender = @"男";
//        item.ktvName = @"宝乐迪量贩KTV十一棵松店";
//        item.discribe = @"离开始还有3天";
//        item.address = @"北京市朝阳区天上人间";
//        item.joinCount = @15;
//        _tableViewDatas = @[item,item];
//    }
//    return _tableViewDatas;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的房间";
//    [self notShowNoNetworking];
    [self setupSubViews];
    [self loadData];


}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupTableView];
}

- (void)setupTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(15.0), 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = TRANSFER_SIZE(120.0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.backgroundColor = HEX_COLOR(0x1d1c21);
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableViewDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMyRoomTableViewCell *cell = [CSMyRoomTableViewCell cellWithTableView:tableView];
    cell.item = self.tableViewDatas[indexPath.section];
    cell.delegate = self;
    return cell;
}
#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return TRANSFER_SIZE(15.0);
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 将被选中的房间模型防止数组第一个
    CSMyRoomModel *roomModel = self.tableViewDatas[indexPath.section];

    GlobalObj.selectedId = roomModel.reserveBoxId;
    
    [self.navigationController popViewControllerAnimated:NO];
    //创建核心动画
    CATransition *ca=[CATransition animation];
    //告诉要执行什么动画
    //设置过度效果
    ca.type=@"push";
    //设置动画的过度方向（向左）
    ca.subtype=kCATransitionFromLeft;
    //设置动画的时间
    ca.duration = 0.3;
    
    UITabBarController *tabBarVc = GlobalObj.tabBarController;
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [CSAlterTabBarTool alterTabBarToRoomController];
    tabBarVc.selectedIndex = 1;
    [tabBarVc.view.layer addAnimation:ca forKey:nil];
}


#pragma mark - CSMyRoomTableViewCellDelegate
- (void)myRoomTableViewCellJoinCountBtnOnClick:(CSMyRoomTableViewCell *)myRoomTableViewCell
{
    CSMyRoomModel *roomModel = myRoomTableViewCell.item;
    CSJoinTableViewController *joinVc = [[CSJoinTableViewController alloc] initWithReserveBoxId:roomModel.reserveBoxId];
    [self.navigationController pushViewController:joinVc animated:YES];
}

- (void)myRoomTableViewCellAddressBtnOnClick:(CSMyRoomTableViewCell *)myRoomTableViewCell
{
    CSMyRoomModel *roomModel = myRoomTableViewCell.item;
    CSKTVMapViewController *ktvMapVc = [[CSKTVMapViewController alloc] initWithKTVName:roomModel.ktvName address:roomModel.address longitude:[roomModel.lng floatValue] latitude:[roomModel.lat floatValue]];
    [self.navigationController pushViewController:ktvMapVc animated:YES];
}

#pragma mark - Load Data
- (void)loadData
{
    CSRequest *param = [[CSRequest alloc] init];
    
    [SVProgressHUD show];
    [CSMyInfoHttpTool getRoomsWithParam:param success:^(CSRoomResponseModel *result) {
//        CSLog(@"%@",result);
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
//            if (result.data.count == 0) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您暂无参与的房间" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                [alertView show];
//                return;
//            }
            _tableViewDatas = result.data;
            [_tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
