//
//  CSMyRoomInfoModel.h
//  CloudSong
//
//  Created by sen on 15/7/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMyRoomInfoModel : NSObject
@property(nonatomic, copy) NSString *discribe;
@property(nonatomic, copy) NSString *boxToken;
@property(nonatomic, assign) BOOL starting;
@property(nonatomic, copy) NSString *reserveBoxId;
@property(nonatomic, copy) NSString *joinCount;
@property(nonatomic, copy) NSString *reservationAvatarUrl;
@property(nonatomic, strong) NSNumber *lat;
@property(nonatomic, strong) NSNumber *lng;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *ktvIP;
@property(nonatomic, copy) NSString *boxIP;
@property(nonatomic, copy) NSString *reservationName;
@property(nonatomic, copy) NSString *ktvName;
@property(nonatomic, copy) NSString *roomName;
/** 包厢开始时间 */
@property(nonatomic, copy) NSString *startTime;
/** 服务器当前时间 */
@property(nonatomic, copy) NSString *serviceDate;

@end
