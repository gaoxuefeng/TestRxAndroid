//
//  NBViewController.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBViewController.h"
#import "NBNetInstabilityView.h"
@interface NBViewController ()
/** 无网络提示视图 */
@property(nonatomic, strong) NBNetInstabilityView *netInstabilityView;
@end

@implementation NBViewController

#pragma mark - Lazy Load
- (NBNetInstabilityView *)netInstabilityView
{
    if (!_netInstabilityView) {
        _netInstabilityView = [[NBNetInstabilityView alloc] init];
        [_netInstabilityView refreshBtnaddTarget:self Action:@selector(loadData)];
        [self.view addSubview:_netInstabilityView];
        [_netInstabilityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _netInstabilityView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self configNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - Setup

#pragma mark - Public Methods
/** 显示网络不稳定视图 */
- (void)showNetInstabilityView
{
    self.netInstabilityView.hidden = NO;
    [self.view bringSubviewToFront:self.netInstabilityView];
}

- (void)dismissNetInstabilityView
{
    _netInstabilityView.hidden = YES;
}

- (void)loadData
{
    _netInstabilityView.hidden = YES;
    // TODO
}

- (void)configNavigationBar
{
    if (self.navigationController.childViewControllers.count < 2) return;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton addTarget:self action:@selector(backBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton sizeToFit];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Methods
- (void)backBtnOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
