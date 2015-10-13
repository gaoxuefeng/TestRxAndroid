//
//  CSMyInfoViewController.m
//  CloudSong
//
//  Created by Ronnie on 15/5/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyInfoViewController.h"
#import "CSLoginViewController.h"
#import <Masonry.h>
#import "CSMyInfoCell.h"
#import "CSMyInfoHeaderView.h"
#import "CSSettingViewController.h"
#import "CSMyCostViewController.h"
#import "CSMyRecordViewController.h"
#import "CSSingHistoryViewController.h"
#import "CSMarkBookViewController.h"
#import "CSMyRecordViewController.h"
#import "CSMyRoomViewController.h"
#import "CSPersonPageViewController.h"
#import "CSDefine.h"
#import <MobClick.h>
#define HEADER_HEIGHT TRANSFER_SIZE(170.0)

typedef enum {
    CSMyInfoCellTypeMyCost,
    CSMyInfoCellTypeMyRecord,
    CSMyInfoCellTypeMySingHistory,
    CSMyInfoCellTypeMarkBook,
    CSMyInfoCellTypeMyRoom
}CSMyInfoCellType;
@interface CSMyInfoViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    CSMyInfoHeaderView *_headerView;
    BOOL _didSetupConstraint;
}
@end

@implementation CSMyInfoViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    [self setupSubViews];
    [self configNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _headerView.item = GlobalObj.userInfo;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdated) name:USER_INFO_UPDATED object:nil];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_INFO_UPDATED object:nil];
    [super viewWillDisappear:animated];
    
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupScrollView];
}


- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = HEX_COLOR(0x1d1c21);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    CGFloat cellHeight = TRANSFER_SIZE(59.0);
    _headerView = [[CSMyInfoHeaderView alloc] init];
    [_headerView loginButtonAddTarget:self action:@selector(loginBtnOnClick)];
    [_headerView personPageButtonAddTarget:self action:@selector(personPageBtnOnClick)];
    [container addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(container);
        make.height.mas_equalTo(HEADER_HEIGHT);
    }];
    
    CSMyInfoCell *costCell = [[CSMyInfoCell alloc] initWithIcon:[UIImage imageNamed:@"mine_cost_icon"] title:@"我的消费" subTitle:nil];
    [costCell addTarget:self action:@selector(cellBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    costCell.tag = CSMyInfoCellTypeMyCost;
    [container addSubview:costCell];
    [costCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.right.equalTo(container);
        make.height.mas_equalTo(cellHeight);
    }];
    
//    CSMyInfoCell *myRecordCell = [[CSMyInfoCell alloc] initWithIcon:[UIImage imageNamed:@"mine_sound recording_icon"] title:@"我的录音" subTitle:nil];
//    [myRecordCell addTarget:self action:@selector(cellBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    myRecordCell.tag = CSMyInfoCellTypeMyRecord;
//    [container addSubview:myRecordCell];
//    [myRecordCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(container);
//        make.top.equalTo(costCell.mas_bottom);
//        make.height.mas_equalTo(cellHeight);
//    }];
//    CSMyInfoCell *singHistoryCell = [[CSMyInfoCell alloc] initWithIcon:[UIImage imageNamed:@"mine_sing history_icon"] title:@"点唱历史" subTitle:nil];
//    [singHistoryCell addTarget:self action:@selector(cellBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    singHistoryCell.tag = CSMyInfoCellTypeMySingHistory;
//    [container addSubview:singHistoryCell];
//    [singHistoryCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(container);
//        make.top.equalTo(myRecordCell.mas_bottom);
//        make.height.mas_equalTo(cellHeight);
//    }];
    CSMyInfoCell *myRoomCell = [[CSMyInfoCell alloc] initWithIcon:[UIImage imageNamed:@"mine_room_icon"] title:@"我的房间" subTitle:nil];
    [myRoomCell addTarget:self action:@selector(cellBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    myRoomCell.tag = CSMyInfoCellTypeMyRoom;
    [container addSubview:myRoomCell];
    [myRoomCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(costCell.mas_bottom);
        make.height.mas_equalTo(cellHeight);
    }];
    
    CSMyInfoCell *markBookCell = [[CSMyInfoCell alloc] initWithIcon:[UIImage imageNamed:@"mine_memorial_icon"] title:@"纪念册" subTitle:nil];
    [markBookCell addTarget:self action:@selector(cellBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    markBookCell.tag = CSMyInfoCellTypeMarkBook;
    [container addSubview:markBookCell];
    [markBookCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(myRoomCell.mas_bottom);
        make.height.mas_equalTo(cellHeight).priorityHigh();
        make.bottom.equalTo(container).priorityMedium();
    }];
}

- (void)configNavigationBar
{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [settingButton setImage:[[UIImage imageNamed:@"mine_setting_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    settingButton.size = CGSizeMake(40.0, 40.0);
    settingButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30.0);
    [settingButton addTarget:self action:@selector(settingBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // y偏移量
    CGFloat offsetY = -(scrollView.contentOffset.y);
    // 头部视图需放大比例
    CGFloat scale = (HEADER_HEIGHT + offsetY) / HEADER_HEIGHT;
    // 如果偏移量 > 0 则拉伸,否则不拉伸
    if (offsetY > 0) {
        if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
            [_headerView.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
            }];
        }
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0,-offsetY * 0.5);
        transform = CGAffineTransformScale(transform, scale, scale);
        _headerView.backgroundView.transform = transform;
        _headerView.centerView.transform = CGAffineTransformMakeTranslation(0.0, -offsetY * 0.5);
        
    }else
    {
        _headerView.backgroundView.transform = CGAffineTransformIdentity;
        _headerView.centerView.transform = CGAffineTransformIdentity;
    }
    
}



#pragma mark - Action Methods
- (void)personPageBtnOnClick
{
    [MobClick event:@"MineInfo"];
    CSPersonPageViewController *personPageVc = [[CSPersonPageViewController alloc] init];
    [self.navigationController pushViewController:personPageVc animated:YES];
}

- (void)loginBtnOnClick
{
    [MobClick event:@"MineLogin"];
    CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (void)settingBtnOnClick
{
    [MobClick event:@"MineSetting"];
    CSSettingViewController *settingVc = [[CSSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)cellBtnOnClick:(UIButton *)button
{
    if (!GlobalObj.isLogin) {
        CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVc animated:YES];
        return;
    }
    
    switch (button.tag) {
        case CSMyInfoCellTypeMyCost:
        {
            [MobClick event:@"MineConsum"];
            CSMyCostViewController *myCostVc = [[CSMyCostViewController alloc] init];
            [self.navigationController pushViewController:myCostVc animated:YES];
            break;
        }
        case CSMyInfoCellTypeMyRecord:
        {
            [MobClick event:@"MineRecord"];
            CSMyRecordViewController *myRecordVc = [[CSMyRecordViewController alloc] init];
            [self.navigationController pushViewController:myRecordVc animated:YES];
            break;
        }
        case CSMyInfoCellTypeMySingHistory:
        {
            CSSingHistoryViewController *singHistoryVc = [[CSSingHistoryViewController alloc] init];
            [self.navigationController pushViewController:singHistoryVc animated:YES];
            
            break;
        }
        case CSMyInfoCellTypeMarkBook:
        {
            [MobClick event:@"MineAutograph"];
            CSMarkBookViewController *markBookVc = [[CSMarkBookViewController alloc] init];
            [self.navigationController pushViewController:markBookVc animated:YES];
            break;
        }
        case CSMyInfoCellTypeMyRoom:
        {
            [MobClick event:@"MineRoom"];
            CSMyRoomViewController *myRoomVc = [[CSMyRoomViewController alloc] init];
            [self.navigationController pushViewController:myRoomVc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)userInfoUpdated
{
    _headerView.item = GlobalObj.userInfo;
}
@end
