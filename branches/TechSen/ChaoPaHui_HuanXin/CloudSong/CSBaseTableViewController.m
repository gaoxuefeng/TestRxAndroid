//
//  CSTableViewController.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseTableViewController.h"
#import "CSBackBarButtonItem.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSBaseTableViewController ()
@property(nonatomic, assign) BOOL navigationBarBGHidden;

@end

@implementation CSBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(0x1d1c21);
    [self configUI];
    [self configNavigationBar];
    if (_navigationBarBGHidden) {
        [self setBackBarButton];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_navigationBarBGHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - Public Methods
- (void)configUI {    
    NSString *imageName = nil;
    if (iPhone4) {
        imageName = @"base_bg_4";
    }else if (iPhone5)
    {
        imageName = @"base_bg_5";
    }else if (iPhone6)
    {
        imageName = @"base_bg_6";
    }else if (iPhone6Plus)
    {
        imageName = @"base_bg_6p";
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

- (void)setNavigationBarBGHidden
{
    _navigationBarBGHidden = YES;
}

- (void)setBackBarButton
{
    UIView *tempNavBar = [[UIView alloc] init];
    [self.view addSubview:tempNavBar];
    [tempNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tempNavBar.superview).offset(20.0);
        make.left.right.equalTo(tempNavBar.superview);
        make.height.mas_equalTo(44.0);
    }];
    UIButton *backButton = (UIButton *)[self getBackBarButtonItem].customView;
    [tempNavBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backButton.superview);
        make.left.equalTo(backButton.superview).offset(15.0);
    }];
}

#pragma mark - Private
- (CSBackBarButtonItem *)getBackBarButtonItem
{
    if (self.navigationController.childViewControllers.count > 1) { // 如果当前控制不是根控制器
        UIViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
        NSString *backStr = nil;
        if (vc.navigationItem.title) {
            backStr = vc.navigationItem.title;
        }else if (vc.title)
        {
            backStr = vc.title;
        }
        CSBackBarButtonItem *backBarButtonItem = [CSBackBarButtonItem backBarButtonItemWithTitle:backStr];
        [backBarButtonItem addTarget:self action:@selector(backBtnOnClick)];
        return backBarButtonItem;
    }
    return nil;
}

- (void)configNavigationBar
{
    self.navigationItem.leftBarButtonItem = [self getBackBarButtonItem];
}


#pragma mark - Action
- (void)backBtnOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    CSLog(@"%@销毁",self.title);
}

@end
