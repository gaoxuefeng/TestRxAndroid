//
//  CSRoomInfoModel.h
//  CloudSong
//
//  Created by sen on 15/7/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRoomInfoModel : NSObject
@property(nonatomic, copy) NSString *ktvName;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, strong) NSArray *avatarUrls;
//@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *roomName;
@property(nonatomic, copy) NSString *reservationName;
@property(nonatomic, copy) NSString *payState;
@property(nonatomic, copy) NSString *phoneNum;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *rbEndTime;
@property(nonatomic, copy) NSString *rbStartTime;
@property(nonatomic, copy) NSString *reserveBoxId;
@property(nonatomic, copy) NSString *serverTimeStamp;
@property(nonatomic, copy) NSString *roomNum;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *countDownStr;
@property (nonatomic,assign) NSInteger duration;

@end
