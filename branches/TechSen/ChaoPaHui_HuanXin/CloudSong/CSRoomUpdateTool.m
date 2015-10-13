//
//  CSRoomUpdateTool.m
//  CloudSong
//
//  Created by sen on 15/8/5.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomUpdateTool.h"
#import <UIKit/UIKit.h>
#import "CSDefine.h"
#import "CSLoginHttpTool.h"
#import "CSAlterTabBarTool.h"
@interface CSRoomUpdateTool ()<UIAlertViewDelegate>
@property(nonatomic, strong) NSMutableArray *timers;
@end


@implementation CSRoomUpdateTool
#pragma mark - 初始化单例
static id _instance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}

- (NSMutableArray *)timers
{
    if (!_timers) {
        NSMutableArray *timers = [NSMutableArray array];
        _timers = timers;
    }
    return _timers;
}


#pragma mark - Public Methods
- (void)addTimerAfterTimeInterval:(NSTimeInterval)timeInterval
{

    NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval + 10.0 target:self selector:@selector(updateRooms:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [self.timers addObject:timer];
}

- (void)resetTimers
{
    for (int i = 0; i < self.timers.count; i++) {
        NSTimer *timer = self.timers[i];
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark - Private Methods
- (void)updateRooms:(NSTimer *)timer
{
//    // TODO
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您有房间已经开始!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//    [alertView show];

    [self updateUserInfo];
    
    [timer invalidate];
    [self.timers removeObject:timer];
    timer = nil;
    if (self.timers.count == 0) {
        _timers = nil;
    }
}




- (void)updateUserInfo
{
    if ([GlobalVar sharedSingleton].token.length > 0) {
        CSRequest *param = [[CSRequest alloc] init];
        [CSLoginHttpTool getUserInfoWithParam:param success:^(CSUserDataWrapperModel *result) {
            if (result.code == ResponseStateSuccess) {
                GlobalObj.userInfo = result.data.userInfo;
                NSArray *array = [result.data.myrooms sortedArrayUsingComparator:^NSComparisonResult(CSMyRoomInfoModel *obj1, CSMyRoomInfoModel *obj2) {
                    return [obj1.rbStartTime compare:obj2.rbStartTime] ==  NSOrderedDescending;
                }];
                GlobalObj.myRooms = array;
                GlobalObj.selectedId = GlobalObj.selectedId;
                if (GlobalObj.myRooms.count > 0) {
                    [CSAlterTabBarTool alterTabBarToRoomController];
                }else
                {
                    [CSAlterTabBarTool alterTabBarToKtvBookingController];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_ROOM_UPDATED object:nil];
            }
        } failure:^(NSError *error) {
            CSLog(@"%@",error);
        }];
    }
}


@end
