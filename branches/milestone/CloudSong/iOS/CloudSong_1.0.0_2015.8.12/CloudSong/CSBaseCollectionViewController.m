//
//  CSBaseCollectionViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/18/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseCollectionViewController.h"
#import "CSBackBarButtonItem.h"

@interface CSBaseCollectionViewController ()

@end

@implementation CSBaseCollectionViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configNavigationBar
{
    if (self.navigationController.childViewControllers.count > 1) { // 如果当前控制不是根控制器
        UIViewController *vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
        NSString *backStr = nil;
        if (vc.navigationItem.title) {
            backStr = vc.navigationItem.title;
        }else if (vc.title)
            backStr = vc.title;
        CSBackBarButtonItem *backBarButtonItem = [CSBackBarButtonItem backBarButtonItemWithTitle:backStr];
        [backBarButtonItem addTarget:self action:@selector(backBtnOnClick)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

#pragma mark - Action Methods

- (void)backBtnOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
