//
//  AppDelegate.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "AppDelegate.h"
#import <RESideMenu.h>
#import "RTLeftMenuViewController.h"
#import "RTCompanyViewController.h"
#import "RTNavigationController.h"
#import "Header.h"
#import "RTInitializationProfileViewController.h"
#import "RTBeaconTool.h"
#import "FMDBTool.h"
@import CoreLocation;
@interface AppDelegate ()<RESideMenuDelegate,CLLocationManagerDelegate>
@property(strong, nonatomic) CLLocationManager *locationMgr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RTCompanyViewController *companyVc = [[RTCompanyViewController alloc] init];
    RTNavigationController *companyNavVc = [[RTNavigationController alloc] initWithRootViewController:companyVc];
    
    RTLeftMenuViewController *leftMenuVc = [[RTLeftMenuViewController alloc] init];
    
    RESideMenu *sideMenuVc = [[RESideMenu alloc] initWithContentViewController:companyNavVc leftMenuViewController:leftMenuVc rightMenuViewController:nil];
//    sideMenuVc.delegate = self;
    sideMenuVc.panFromEdge = NO;
    sideMenuVc.panMinimumOpenThreshold = 50;
    sideMenuVc.contentViewScaleValue = 0.8;
    sideMenuVc.contentViewInPortraitOffsetCenterX = -30.0;
    sideMenuVc.contentViewShadowColor = [UIColor whiteColor];
    sideMenuVc.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuVc.contentViewShadowOpacity = 0.6;
    sideMenuVc.contentViewShadowRadius = 5;
    sideMenuVc.contentViewShadowEnabled = YES;
    
    if ([Common sharedCommon].hasSetProfile) {
        self.window.rootViewController = sideMenuVc;
    }else
    {
        RTInitializationProfileViewController *profileVc = [[RTInitializationProfileViewController alloc] init];
        self.window.rootViewController = [[RTNavigationController alloc] initWithRootViewController:profileVc];
    }
    
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.delegate = self;
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [self.locationMgr requestAlwaysAuthorization];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([RTBeaconTool isCompanyBeacon:beaconRegion]) {
            [FMDBTool insertDatePointWithType:RTDatePointTypeExitCompany];
            notification.alertBody = @"你离开了公司";
        }else if ([RTBeaconTool isHomeBeacon:beaconRegion])
        {
            [FMDBTool insertDatePointWithType:RTDatePointTypeExitHome];
            notification.alertBody = @"你离开了家";
        }
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([RTBeaconTool isCompanyBeacon:beaconRegion]) {
            [FMDBTool insertDatePointWithType:RTDatePointTypeEnterCompany];
            notification.alertBody = @"你进入了公司";
        }else if ([RTBeaconTool isHomeBeacon:beaconRegion])
        {
            [FMDBTool insertDatePointWithType:RTDatePointTypeEnterHome];
            
            notification.alertBody = @"你进入了家";
        }
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

@end
