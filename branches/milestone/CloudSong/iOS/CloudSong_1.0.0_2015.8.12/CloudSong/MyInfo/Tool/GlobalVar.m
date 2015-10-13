//
//  GlobalVar.m
//  CloudSong
//
//  Created by Ronnie on 15/6/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "GlobalVar.h"
#import <MJExtension.h>
#import <UIKit/UIKit.h>
//#import "CSRoomUpdateTool.h"
#define USER_ICON_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userIcon.jpg"]

@implementation GlobalVar

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

- (BOOL)isLogin
{
    return self.token.length;
}

- (BOOL)isBinding
{
    return self.roomNum.length;
}

//-(void)initMember
//{
//   self.userInfo = [[CSUserInfoModel alloc]init];
//    self.isLogin = NO;
//    self.isBinding = NO;
//}

- (NSString *)currentCity {
    if (_currentCity.length > 0) {
        return _currentCity;
    }
    else {
        NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentCity"];
        if (city.length == 0) {
            city = @"北京";
            [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"currentCity"];
        }
        return city;
    }
}

- (void)setCurrentCity:(NSString *)city {
    _currentCity = city;
    [[NSUserDefaults standardUserDefaults] setObject:_currentCity forKey:@"currentCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)token
{
    if (_token.length > 0) { // 如果内存中有token,则直接返回
        return _token;
    }else // 否则去偏好设置里取并返回
    {
        _token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        return _token;
    }
}

- (void)setToken:(NSString *)token
{
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CSUserInfoModel *)userInfo
{
    if (_userInfo) {    // 如果内存中有userInfo,则直接返回
        return _userInfo;
    }else
    {
        NSString *userInfoStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
        // json转模型
        _userInfo = [CSUserInfoModel objectWithJSONData:[userInfoStr dataUsingEncoding:NSUTF8StringEncoding]];
        return _userInfo;
    }
}
- (void)setUserInfo:(CSUserInfoModel *)userInfo
{
    _userInfo = userInfo;
    NSString *userInfoStr = nil;
    if (userInfo) {
        // 对象转字典
        NSDictionary *userInfoDic = [userInfo keyValues];
        // 字典转Json
        NSError* error = nil;
        id result = [NSJSONSerialization dataWithJSONObject:userInfoDic options:kNilOptions error:&error];
        userInfoStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userInfoStr forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)roomNum
{
    if (_roomNum.length > 0) { // 如果内存中有token,则直接返回
        return _roomNum;
    }else // 否则去偏好设置里取并返回
    {
        _roomNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"roomNum"];
        return _roomNum;
    }
}
- (void)setRoomNum:(NSString *)roomNum
{
    _roomNum = roomNum;
    [[NSUserDefaults standardUserDefaults] setObject:roomNum forKey:@"roomNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)queryID {
    if (_queryID.length > 0) { // 如果内存中有token,则直接返回
        return _queryID;
    }else // 否则去偏好设置里取并返回
    {
        _queryID = [[NSUserDefaults standardUserDefaults] valueForKey:@"queryID"];
        return _queryID;
    }
}

- (void)setQueryID:(NSString *)queryID {
    _queryID = queryID;
    [[NSUserDefaults standardUserDefaults] setObject:queryID forKey:@"queryID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 临时测试专用 */
- (NSString *)boxIp
{
    if (_boxIp.length > 0) { // 如果内存中有token,则直接返回
        return _boxIp;
    }else // 否则去偏好设置里取并返回
    {
        _boxIp = [[NSUserDefaults standardUserDefaults] valueForKey:@"boxIp"];
        return _boxIp;
    }
    return _boxIp;
}
- (void)setBoxIp:(NSString *)boxIp
{
    _boxIp = boxIp;
    [[NSUserDefaults standardUserDefaults] setObject:_boxIp forKey:@"boxIp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)centerIp
{
    if (_centerIp.length > 0) { // 如果内存中有token,则直接返回
        return _centerIp;
    }else // 否则去偏好设置里取并返回
    {
        _centerIp = [[NSUserDefaults standardUserDefaults] valueForKey:@"centerIp"];
        return _centerIp;
    }

}
- (void)setCenterIp:(NSString *)centerIp
{
    _centerIp = centerIp;
    [[NSUserDefaults standardUserDefaults] setObject:_centerIp forKey:@"centerIp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIImage *)userIcon
{
    if (_userIcon) {
        return _userIcon;
    }
    return [UIImage imageWithContentsOfFile:USER_ICON_PATH];
}
- (void)setUserIcon:(UIImage *)userIcon
{
    _userIcon = userIcon;
    NSData *imageData = UIImageJPEGRepresentation(userIcon, 1.0);
    [imageData writeToFile:USER_ICON_PATH atomically:YES];
}

/** 注销 */
- (BOOL)logout
{
    BOOL logout = NO;
    self.userInfo = nil;
    self.token = nil;
    self.boxIp = nil;
    self.centerIp = nil;
    self.roomNum = nil;
    self.scanReserveBoxId = nil;
    self.myRooms = nil;
    self.isLogin = NO;
//    [CSAlterTabBarTool alterTabBarToKtvBookingController];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL exist = [fileMgr fileExistsAtPath:USER_ICON_PATH];
    if (exist) {
         NSError *err;
        [fileMgr removeItemAtPath:USER_ICON_PATH error:&err];
        logout = err;
    }
    NSString * appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    return logout;
}

- (NSString *)selectedId
{
    if (_selectedId.length > 0) {
        return _selectedId;
    }else
    {
        _selectedId = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedId"];
        return _selectedId;
    }
}
- (void)setSelectedId:(NSString *)selectedId
{
    _selectedId = selectedId;
    if (selectedId.length == 0) return;
    for (int i = 0; i < self.myRooms.count; i++) {
        CSMyRoomInfoModel *roomInfo = self.myRooms[i];
        if ([roomInfo.reserveBoxId isEqualToString:selectedId]) { // 如果找到被标记为当前包厢的房间,则将该房间置于第一个
            NSMutableArray *myroomsM = [NSMutableArray arrayWithArray:self.myRooms];
            [myroomsM exchangeObjectAtIndex:i withObjectAtIndex:0];
            self.myRooms = myroomsM;
            break;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:selectedId forKey:@"selectedId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)myRooms
{
    return _myRooms;
}
- (void)setMyRooms:(NSArray *)array
{
    _myRooms = array;
    if (_myRooms.count == 0) return;
    
    CSMyRoomInfoModel *roomModel = array.firstObject;
    if (roomModel.ktvIP.length == 0) return;
    [self setBoxIp:roomModel.boxIP];
    [self setCenterIp:roomModel.ktvIP];
    
    

}

//- (NSString *)scanReserveBoxId
//{
//    if (_scanReserveBoxId.length > 0) { // 如果内存中有token,则直接返回
//        return _scanReserveBoxId;
//    }else // 否则去偏好设置里取并返回
//    {
//        _scanReserveBoxId = [[NSUserDefaults standardUserDefaults] valueForKey:@"scanReserveBoxId"];
//        return _scanReserveBoxId;
//    }
//    
//}

//- (void)setScanReserveBoxId:(NSString *)scanReserveBoxId
//{
//    _scanReserveBoxId = scanReserveBoxId;
//    CSMyRoomInfoModel *roomModel = [[CSMyRoomInfoModel alloc] init];
//    roomModel.reserveBoxId = scanReserveBoxId;
//    roomModel.starting = YES;
//    NSMutableArray *myroomsM = [NSMutableArray arrayWithArray:self.myRooms];
//    [myroomsM insertObject:roomModel atIndex:0];
//    self.myRooms = myroomsM;
//    [[NSUserDefaults standardUserDefaults] setObject:_scanReserveBoxId forKey:@"scanReserveBoxId"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}

//- (NSString *)scanKTVIP
//{
//    if (_scanKTVIP.length > 0) { // 如果内存中有token,则直接返回
//        return _scanKTVIP;
//    }else // 否则去偏好设置里取并返回
//    {
//        _scanKTVIP = [[NSUserDefaults standardUserDefaults] valueForKey:@"scanKTVIP"];
//        return _scanKTVIP;
//    }
//}
//- (void)setScanKTVIP:(NSString *)KTVIP
//{
//    _scanKTVIP = KTVIP;
//    [[NSUserDefaults standardUserDefaults] setObject:_scanKTVIP forKey:@"scanKTVIP"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}





@end
