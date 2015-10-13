//
//  CSUserInfoEditViewController.m
//  CloudSong
//
//  Created by sen on 8/26/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSUserInfoEditViewController.h"

@implementation CSUserInfoEditViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"信息编辑";
    [self setupSubviews];
    [self configNavigationRightItem];
    
}


#pragma mark - Setup
- (void)setupSubviews
{
    
}


- (void)configNavigationRightItem
{
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(saveBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [confirmButton setTitle:@"保存" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HEX_COLOR(0x818289) forState:UIControlStateNormal];
    [confirmButton sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}


- (void)saveBtnOnClick
{
    
}



@end
