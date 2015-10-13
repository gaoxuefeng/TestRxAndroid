//
//  RTBeaconTool.h
//  RecordTime
//
//  Created by sen on 9/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSBeaconItem;
@class CLBeaconRegion;

@interface RTBeaconTool : NSObject


/** 加载兼容的beacon模型 */
+ (NSArray *)loadSupportBeaconItems;


+ (void)setCompanyBeacon:(CLBeaconRegion *)beaconRegion;

+ (CLBeaconRegion *)getCompanyBeacon;

+ (void)setHomeBeacon:(CLBeaconRegion *)beaconRegion;

+ (CLBeaconRegion *)getHomeBeacon;

+ (BOOL)isCompanyBeacon:(CLBeaconRegion *)beaconRegion;

+ (BOOL)isHomeBeacon:(CLBeaconRegion *)beaconRegion;





@end
