//
//  CSBaseViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 5/20/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSDefine.h"
#import "CSBackBarButtonItem.h"
#import <Masonry.h>
@interface CSBaseViewController ()
@property(nonatomic, assign) BOOL navigationBarBGHidden;
@property(nonatomic, weak) UIView *tempNavBar;
@end

@implementation CSBaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configNavigationBar];
    if (_navigationBarBGHidden) {
        [self setBackBarButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_navigationBarBGHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view bringSubviewToFront:self.tempNavBar];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachability) name:NET_WORK_REACHABILITY object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_REACHABILITY object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - Public Methods
- (void)configUI {
    self.navigationController.navigationBar.barTintColor = Color_Hex_15_14_17;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:TRANSFER_SIZE(17.0)],
                                                                    NSForegroundColorAttributeName:Color_168_168_165};
    self.tabBarController.tabBar.barTintColor = Color_21_20_23;
    self.view.backgroundColor = HEX_COLOR(0x1d1c21);
}

- (void)networkReachability
{
    // Custom
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
    _tempNavBar = tempNavBar;
    UIButton *backButton = (UIButton *)[self getBackBarButtonItem].customView;
    [tempNavBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backButton.superview);
        make.top.bottom.equalTo(backButton.superview);
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
    NSLog(@"%@销毁",self.title);
}
@end
