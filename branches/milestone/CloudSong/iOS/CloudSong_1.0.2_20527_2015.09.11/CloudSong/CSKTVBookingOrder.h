//
//  CSKTVBookingOrder.h
//  CloudSong
//
//  Created by youmingtaizi on 6/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CSKTVBookingOrder : NSObject
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *reserveBoxId;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *KTVName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *boxTypeName;
@property(nonatomic, copy) NSString *totalTime;
@property(nonatomic, copy) NSNumber *rbStartTime;
@property(nonatomic, copy) NSNumber *rbEndTime;
@end
