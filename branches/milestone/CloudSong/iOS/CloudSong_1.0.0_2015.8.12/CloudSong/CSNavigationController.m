//
//  CSNavigationController.m
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSNavigationController.h"
#import "CSDefine.h"
@interface CSNavigationController ()

@end

@implementation CSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    // 配置navigationbar样式
    UINavigationBar *appearance = self.navigationBar;
    appearance.translucent = NO ;
    // 设置导航栏的背景颜色
    [appearance setBarTintColor:HEX_COLOR(0x151417)];
    // 设置导航栏标题的字体和颜色
    [appearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:HEX_COLOR(0xb5b7bf)}];
    self.interactivePopGestureRecognizer.delegate = (id) self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
