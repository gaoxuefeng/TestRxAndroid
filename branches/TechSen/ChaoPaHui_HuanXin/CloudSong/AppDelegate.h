//
//  AppDelegate.h
//  CloudSong
//
//  Created by youmingtaizi on 15/4/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
/** 更新房间信息定时器 */
@property(nonatomic, strong) NSTimer *updateRoomsTimer;

@property(strong, nonatomic) Reachability *reach;
@end

