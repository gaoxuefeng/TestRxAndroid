//
//  YSBeaconItem.h
//  YSBeaconDemo
//
//  Created by sen on 8/13/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface YSBeaconItem : NSObject<NSCoding>

@property (strong, nonatomic, readonly) NSString *name;

@property (strong, nonatomic, readonly) NSUUID *uuid;

@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;

@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;

- (instancetype)initWithName:(NSString *)name

                        uuid:(NSUUID *)uuid

                       major:(CLBeaconMajorValue)major

                       minor:(CLBeaconMinorValue)minor;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
