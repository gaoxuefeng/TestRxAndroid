//
//  CSSettingViewController.m
//  CloudSong
//
//  Created by sen on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSettingViewController.h"
#import "CSSettingTableViewCell.h"
#import <Masonry.h>
#import "CSCleanCacheStatusBar.h"
#import "CSFeedBackViewController.h"
#import "CSBackBarButtonItem.h"
#import "CSAboutUsViewController.h"
#import "CSAlterPwdViewController.h"
#import "CSAlterTabBarTool.h"
#import <MobClick.h>
@interface CSSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    CSCleanCacheStatusBar *_cleanCacheStatusBar;
    UITableView *_tableView;
}

@property(nonatomic, strong) NSArray *tableViewDatas;
@property(nonatomic, weak) UIView *logoutView;
@property(nonatomic, weak) UIAlertView *logoutAlertView;
@end

@implementation CSSettingViewController

#pragma mark - Lazy Load
- (NSArray *)tableViewDatas
{
    if (!_tableViewDatas) {
        __weak typeof(self) weakSelf = self;
        
        CSSettingItem *alterPwd = nil;
        if (GlobalObj.token.length > 0) { // 已登录,显示修改密码
            alterPwd = [[CSSettingItem alloc] init];
            alterPwd.title = @"修改密码";
            alterPwd.option = ^{
                [MobClick event:@"MineSettingChangePass"];
                CSAlterPwdViewController *alterPwdVc = [[CSAlterPwdViewController alloc] init];
                [alterPwdVc notShowNoNetworking];
                [self.navigationController pushViewController:alterPwdVc animated:YES];
            };
        }
        
        CSSettingItem *grade = [[CSSettingItem alloc] init];
        grade.title = @"给潮趴汇评个分";
        grade.option = ^{
            [MobClick event:@"MineSettingRating"];
            NSString *appid = @"1006509480";
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        };
        CSSettingItem *feedback = [[CSSettingItem alloc] init];
        feedback.title = @"意见反馈";
        feedback.option = ^{
            // TODO 意见反馈
            [MobClick event:@"MineSettingFeedBack"];
            CSFeedBackViewController *feedBackVc = [[CSFeedBackViewController alloc] init];
            [feedBackVc notShowNoNetworking];
            [weakSelf.navigationController pushViewController:feedBackVc animated:YES];
        };
        CSSettingItem *about = [[CSSettingItem alloc] init];
        about.title = @"关于潮趴汇";
        about.option = ^{
            // TODO 关于
            [MobClick event:@"MineSettingAbout"];
            CSAboutUsViewController *aboutUsVc = [[CSAboutUsViewController alloc] init];
            [aboutUsVc notShowNoNetworking];
            [weakSelf.navigationController pushViewController:aboutUsVc animated:YES];
        };
        CSSettingItem *clean = [[CSSettingItem alloc] init];
        clean.title = @"清除缓存";
        
        clean.option = ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清除缓存数据吗?" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        };
        if (alterPwd) {
            _tableViewDatas = @[alterPwd,grade,feedback,about,clean];
        }else
        {
            _tableViewDatas = @[grade,feedback,about,clean];
        }
        
    }
    return _tableViewDatas;

}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupSubViews];
}


#pragma mark - Setup
- (void)setupSubViews
{
    _tableView = [[UITableView alloc] init];
    _tableView.contentInset = UIEdgeInsetsMake(TRANSFER_SIZE(20.0), 0, 0, 0);
    _tableView.rowHeight = 51.0;
//    _tableView.backgroundColor = HEX_COLOR(0x1d1c21);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorColor = HEX_COLOR(0x462f5e);
//    _tableView.separatorInset = UIEdgeInsetsMake(0, TRANSFER_SIZE(17.0), 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (GlobalObj.token.length > 0) {
        UIView *logoutView = [[UIView alloc] init];
        logoutView.height = TRANSFER_SIZE(60.0);
        _logoutView = logoutView;
        
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [logoutButton addTarget:self action:@selector(logoutBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        logoutButton.backgroundColor = HEX_COLOR(0xff41ab);
        [logoutButton setTitle:@"注销" forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoutButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
        logoutButton.layer.masksToBounds = YES;
        
        CGFloat logoutBtnX = TRANSFER_SIZE(10.0);
        CGFloat logoutBtnW = SCREENWIDTH - logoutBtnX * 2;
        CGFloat logoutBtnH = logoutView.height - 20;
        CGFloat logoutBtnY = 20;
        logoutButton.frame = CGRectMake(logoutBtnX, logoutBtnY, logoutBtnW, logoutBtnH);
        [logoutView addSubview:logoutButton];
//        [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(logoutButton.superview);
//            make.left.equalTo(logoutButton.superview).offset(10.0);
//            make.right.equalTo(logoutButton.superview).offset(-10.0);
//        }];
        
        _tableView.tableFooterView = logoutView;
    }
}
#pragma mark - Config



#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSSettingTableViewCell *cell = [CSSettingTableViewCell cellWithTableView:tableView];
    cell.item = self.tableViewDatas[indexPath.row];
    cell.bottomLineHidden = indexPath.row == self.tableViewDatas.count - 1;
    return cell;
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return TRANSFER_SIZE(10.0);
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return TRANSFER_SIZE(20.0);
//    }
//    return 0.01;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSSettingItem *item = self.tableViewDatas[indexPath.row];
    if (item.option) {
        item.option();
    }
}

#pragma mark - Action
- (void)logoutBtnOnClick
{
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"注销" message:@"确定注销?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _logoutAlertView = logoutAlertView;
    [logoutAlertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (alertView == _logoutAlertView) {
        [GlobalObj logout];
        _logoutView.hidden = YES;
        [MobClick event:@"MineSettingLogout"];
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CSAlterTabBarTool alterTabBarToKtvBookingController];
        });
    
    }else
    {
        // 指定清除缓存路径
        [MobClick event:@"MineSettingClean"];
        NSString *cachePath = [CACHE_DIRECTION stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
        // 创建文件管理器
        NSFileManager *mgr = [NSFileManager defaultManager];
        // 执行清除缓存
        [mgr removeItemAtPath:cachePath error:nil];
        // 创建清除缓存状态Bar
        _cleanCacheStatusBar = [[CSCleanCacheStatusBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20.0)];
        [_cleanCacheStatusBar show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_cleanCacheStatusBar dismiss];
        });
    }
    
}





@end
