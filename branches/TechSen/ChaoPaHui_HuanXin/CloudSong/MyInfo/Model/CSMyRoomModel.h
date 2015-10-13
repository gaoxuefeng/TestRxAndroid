//
//  CSMyRoomModel.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMyRoomModel : NSObject
@property(nonatomic, copy) NSString *reservationName;
@property(nonatomic, copy) NSString *reservationAvatarUrl;
@property(nonatomic, assign) BOOL starting;
@property(nonatomic, strong) NSNumber *lat;
@property(nonatomic, strong) NSNumber *lng;
@property(nonatomic, copy) NSString *ktvName;
@property(nonatomic, copy) NSString *discribe;
@property(nonatomic, strong) NSNumber *joinCount;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *reserveBoxId;
@end
