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
#import "AppDelegate.h"
#import "CSNoNetworkView.h"
@interface CSBaseViewController ()
@property(nonatomic, assign) BOOL navigationBarBGHidden;
@property(nonatomic, weak) UIView *tempNavBar;
@property(weak, nonatomic) UIImageView *backgroundImageView;
@property(weak, nonatomic) CSNoNetworkView *noNetworkView;
@property(nonatomic, assign) BOOL notShowNoNetworkView;
@end

@implementation CSBaseViewController

- (CSNoNetworkView *)noNetworkView
{
    if (!_noNetworkView) {
        CSNoNetworkView *noNetworkView = [[CSNoNetworkView alloc] init];
        noNetworkView.backgroundImage = _backgroundImageView.image;
        [self.view addSubview:noNetworkView];
        [noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(noNetworkView.superview);
        }];
        _noNetworkView = noNetworkView;
    }
    return _noNetworkView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configNavigationBar];
    if (_navigationBarBGHidden) {
        [self setBackBarButton];
    }

    if (!_notShowNoNetworkView) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!appDelegate.reach.currentReachabilityStatus) {
            CSNoNetworkView *noNetworkView = [[CSNoNetworkView alloc] init];
            noNetworkView.backgroundImage = _backgroundImageView.image;
            [self.view addSubview:noNetworkView];
            [noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(noNetworkView.superview);
            }];
            _noNetworkView = noNetworkView;
        }
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
    [self.view insertSubview:self.backgroundImageView atIndex:0];
    
    
    if (!_notShowNoNetworkView) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!appDelegate.reach.currentReachabilityStatus) {
            [self.view bringSubviewToFront:_noNetworkView];
            if (_navigationBarBGHidden) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view bringSubviewToFront:self.tempNavBar];
            }
        }else
        {
            [_noNetworkView removeFromSuperview];
        }
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_REACHABILITY object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - Public Methods

- (void)notShowNoNetworking {
    _notShowNoNetworkView = YES;
}

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

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:backgroundImageView];
    _backgroundImageView = backgroundImageView;
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgroundImageView.superview);
    }];
}

- (void)networkReachability
{
    // Custom
    [_noNetworkView removeFromSuperview];
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

- (void)hiddenBackgroundImageView
{
    [_backgroundImageView removeFromSuperview];
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


- (void)setIsNetWorking:(BOOL)isNetWorking
{
    _isNetWorking = isNetWorking;
    if (isNetWorking) {
        [_noNetworkView removeFromSuperview];
    }
}


#pragma mark - Action
- (void)backBtnOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSString *title = nil;
    if (self.navigationItem.titleView) {
        if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
            UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
            title = titleLabel.text;
        }else if ([self.navigationItem.titleView isKindOfClass:[UIButton class]])
        {
            UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
            title = [titleButton currentTitle];
        }
    }else if(self.title)
    {
        title = self.title;
    }else
    {
        title = self.navigationItem.title;
    }
    CSLog(@"%@控制器销毁",title);
}
@end
