//
//  CSSendFaceViewController.m
//  CloudSong
//
//  Created by sen on 15/6/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSendFaceViewController.h"

@interface CSSendFaceViewController ()

@end

@implementation CSSendFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)backBtnOnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
