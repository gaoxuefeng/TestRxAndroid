//
//  NBNavigationController.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBNavigationController.h"
#import "NBCommon.h"


@interface NBNavigationController ()

@end

@implementation NBNavigationController

+ (void)initialize
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    // 设置导航栏的背景颜色
    [appearance setBarTintColor:[UIColor blackColor]];
    // 设置导航栏标题的字体和颜色
    [appearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:HEX_COLOR(0xeea300)}];
    
    // 设置返回按钮文字颜色
    [[UINavigationBar appearance] setTintColor:HEX_COLOR(0xeea300)];
    // 设置返回按钮图片颜色
    [appearance setBackIndicatorImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [appearance setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.interactivePopGestureRecognizer.delegate = (id) self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

/** 保证栈顶控制器接收状态栏修改回调 */
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}


@end
