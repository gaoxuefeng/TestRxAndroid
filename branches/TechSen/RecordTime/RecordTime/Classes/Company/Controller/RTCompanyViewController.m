//
//  RTCompanyViewController.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTCompanyViewController.h"
#import "RTCompanyHeaderView.h"
#import "RTLogViewController.h"
#import <RESideMenu.h>
@interface RTCompanyHeaderView ()


@end


@implementation RTCompanyViewController


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BG_COLOR;
    self.navigationItem.title = @"公司";
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - SetupSubviews
- (void)setupSubviews
{
    RTCompanyHeaderView *headerView = [[RTCompanyHeaderView alloc] init];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView.superview);
        make.height.equalTo(headerView.mas_width).offset(AUTOLENGTH(50.0));
    }];
    
    UIButton *leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftMenuButton.layer.cornerRadius = 24.0;
    leftMenuButton.layer.masksToBounds = YES;
    [leftMenuButton setTitle:@"菜单" forState:UIControlStateNormal];
    [leftMenuButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    leftMenuButton.backgroundColor = MAIN_BG_COLOR;
    [self.view addSubview:leftMenuButton];
    [leftMenuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [leftMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48.0, 48.0));
        make.left.equalTo(leftMenuButton.superview).offset(20.0);
        make.top.equalTo(leftMenuButton.superview).offset(25.0);
    }];
    
    UIButton *nearlyWeekButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nearlyWeekButton addTarget:self action:@selector(nearlyWeekButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    nearlyWeekButton.backgroundColor = [UIColor whiteColor];
    [nearlyWeekButton setTitle:@"近7天数据统计" forState:UIControlStateNormal];
    [nearlyWeekButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:nearlyWeekButton];
    
    UIButton *nearlyMonthButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nearlyMonthButton addTarget:self action:@selector(nearlyMonthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    nearlyMonthButton.backgroundColor = [UIColor whiteColor];
    [nearlyMonthButton setTitle:@"近30天数据统计" forState:UIControlStateNormal];
    [nearlyMonthButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:nearlyMonthButton];
    
    CGFloat buttonXPadding = 15.0;
    
    [nearlyWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(20.0);
        make.left.equalTo(nearlyWeekButton.superview).offset(buttonXPadding);
        make.right.equalTo(nearlyWeekButton.superview).offset(-buttonXPadding);
        make.height.mas_equalTo(40.0);
    }];
    
    [nearlyMonthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nearlyWeekButton.mas_bottom).offset(20.0);
        make.left.equalTo(nearlyMonthButton.superview).offset(buttonXPadding);
        make.right.equalTo(nearlyMonthButton.superview).offset(-buttonXPadding);
        make.height.mas_equalTo(40.0);
    }];
    
    
//    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [logButton addTarget:self action:@selector(logButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:logButton];
//    [logButton setTitle:@"查看日志" forState:UIControlStateNormal];
//    [logButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(logButton.superview.mas_bottom).offset(-20.0);
//        make.right.equalTo(logButton.superview.mas_right).offset(-20.0);
//    }];

}


#pragma mark - Action Methods
- (void)leftMenuBtnOnPressed
{
    
}

- (void)nearlyWeekButtonPressed
{
    
}

- (void)nearlyMonthButtonPressed
{
    
}


@end
