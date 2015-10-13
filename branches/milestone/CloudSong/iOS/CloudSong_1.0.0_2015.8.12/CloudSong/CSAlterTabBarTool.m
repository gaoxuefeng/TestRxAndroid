//
//  CSAlterTabBarTool.m
//  CloudSong
//
//  Created by EThank on 15/7/28.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSAlterTabBarTool.h"
#import "CSDefine.h"
// 用于测试，点击进入房间按钮
#import "CSKTVBookingViewController.h"
#import "CSInRoomViewController.h"
#import "CSNavigationController.h"

@interface CSAlterTabBarTool ()


@end

@implementation CSAlterTabBarTool




/**
 *  预定切换为房间
 */
+ (void)alterTabBarToRoomController{
    UITabBarController *mainTabBarController = GlobalObj.tabBarController;
    CSNavigationController *navVc = mainTabBarController.childViewControllers[1];
    if ([navVc.topViewController isKindOfClass:[CSInRoomViewController class]]) return;

    CSInRoomViewController *roomVC = [[CSInRoomViewController alloc] init] ;
    CSNavigationController *roomNav = [[CSNavigationController alloc] initWithRootViewController:roomVC] ;
    roomNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:mainTabBarController.viewControllers] ;
    [vcArray replaceObjectAtIndex:1 withObject:roomNav] ;
    mainTabBarController.viewControllers = vcArray ;

    
    // 切换图片
    UITabBarItem *secondItem = mainTabBarController.tabBar.items[1] ;
    NSString *normalImage = @"tabbar_room_normal" ;
    NSString *pressImage = @"tabbar_room_press" ;
    secondItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    secondItem.selectedImage = [[UIImage imageNamed:pressImage] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] ;
}

+ (void)alterTabBarToKtvBookingController{
    
    UITabBarController *mainTabBarController = GlobalObj.tabBarController;

    
    CSNavigationController *navVc = mainTabBarController.childViewControllers[1];
    if ([navVc.topViewController isKindOfClass:[CSKTVBookingViewController class]]) return;
    
    CSKTVBookingViewController *bookingVC = [[CSKTVBookingViewController alloc] init] ;
    CSNavigationController *bookingNav = [[CSNavigationController alloc] initWithRootViewController:bookingVC] ;
    bookingNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:mainTabBarController.viewControllers] ;
    [vcArray replaceObjectAtIndex:1 withObject:bookingNav] ;
    mainTabBarController.viewControllers = vcArray ;
    
    // 切换图片
    UITabBarItem *secondItem = mainTabBarController.tabBar.items[1] ;
    NSString *normalImage = @"tabbar_reserve_normal" ;
    NSString *pressImage = @"tabbar_reserve_press" ;
    secondItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    secondItem.selectedImage = [[UIImage imageNamed:pressImage] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] ;
}

@end
