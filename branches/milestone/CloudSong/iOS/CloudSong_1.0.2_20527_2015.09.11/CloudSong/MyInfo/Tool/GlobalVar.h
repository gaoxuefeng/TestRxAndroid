//
//  GlobalVar.h
//  CloudSong
//
//  Created by Ronnie on 15/6/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSUserInfoModel.h"
#import "CSMyRoomInfoModel.h"
#import <UIKit/UIKit.h>
#import "ActivityCityView.h"

@class UIImage;
@interface GlobalVar : NSObject
{
    NSString *_currentCity;
    NSString *_token;
    CSUserInfoModel *_userInfo;
    NSString *_roomNum;
    NSString *_queryID;
    NSString * _boxIp;
    NSString *_centerIp;
    UIImage *_userIcon;
    NSArray *_myRooms;
    NSString *_selectedId;
//    NSString *_scanReserveBoxId;
//    NSString *_scanKTVIP;
}
/*********************************************************************************************
 
 初始化单例 这个单例用来保存全局变量
 
 ********************************************************************************************/




+ (GlobalVar *)sharedSingleton;

/** cityView */
@property(nonatomic, strong) ActivityCityView *cityView;

@property(nonatomic, strong) NSMutableArray *cityName;

/** tabBarController */
@property(nonatomic, strong) UITabBarController *tabBarController;

/** 登录状态 */
@property (nonatomic) BOOL isLogin;
/** 绑定包厢状态 */
@property (nonatomic) BOOL isBinding;
/** 经度 */
@property(nonatomic, assign) double longitude;
/** 纬度 */
@property(nonatomic, assign) double latitude;

@property(nonatomic, copy) NSString *locationCity;
/** 扫描获得的房间ID */
@property(nonatomic, strong) NSString *scanReserveBoxId;
/* 当前是否有网  */
@property(nonatomic, assign) BOOL isNetConnection;

//- (NSString *)scanKTVIP;
//- (void)setScanKTVIP:(NSString *)KTVIP;
//
//- (NSString *)scanReserveBoxId;
//- (void)setScanReserveBoxId:(NSString *)scanReserveBoxId;
//

- (NSString *)currentCity;
- (void)setCurrentCity:(NSString *)city;
- (NSString *)token;
- (void)setToken:(NSString *)token;
- (CSUserInfoModel *)userInfo;
- (void)setUserInfo:(CSUserInfoModel *)userInfo;
- (NSString *)roomNum;
- (void)setRoomNum:(NSString *)roomNum;
- (NSString *)queryID;
- (void)setQueryID:(NSString *)queryID;
- (UIImage *)userIcon;
- (void)setUserIcon:(UIImage *)userIcon;
- (NSString *)boxIp;
- (void)setBoxIp:(NSString *)boxIp;
- (NSString *)centerIp;
- (void)setCenterIp:(NSString *)centerIp;

- (NSString *)selectedId;
- (void)setSelectedId:(NSString *)selectedId;

- (NSArray *)myRooms;
- (void)setMyRooms:(NSArray *)array;

/** 注销 */
- (BOOL)logout;
@end
