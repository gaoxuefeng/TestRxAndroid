//
//  RTBeaconTool.m
//  RecordTime
//
//  Created by sen on 9/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTBeaconTool.h"
#import "YSBeaconItem.h"

@import CoreLocation;


NSString * const RTCompanyItemKey = @"companyItem";
NSString * const RTHomeItemKey = @"homeItem";

@implementation RTBeaconTool
static NSArray *beaconItemsTmp;
static CLBeaconRegion *companyRegionTmp;
static CLBeaconRegion *homeRegionTmp;

+ (NSArray *)loadSupportBeaconItems
{
    YSBeaconItem *aprilBeacon = [[YSBeaconItem alloc] initWithName:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0" uuid:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] major:0 minor:0];
    YSBeaconItem *appleAirLocate = [[YSBeaconItem alloc] initWithName:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5" uuid:[[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"] major:0 minor:0];
    YSBeaconItem *appleAirLocate2 = [[YSBeaconItem alloc] initWithName:@"74278BDA-B644-4520-8F0C-720EAF059935" uuid:[[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"] major:0 minor:0];
    YSBeaconItem *eSTimote = [[YSBeaconItem alloc] initWithName:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" uuid:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] major:0 minor:0];
    
    CLBeaconRegion *aprilBeaconRegion = [self beaconRegionWithItem:aprilBeacon];
    CLBeaconRegion *appleAirLocateRegion = [self beaconRegionWithItem:appleAirLocate];
    CLBeaconRegion *appleAirLocate2Region = [self beaconRegionWithItem:appleAirLocate2];
    CLBeaconRegion *eSTimoteRegion = [self beaconRegionWithItem:eSTimote];
    
    return @[aprilBeaconRegion,appleAirLocateRegion,appleAirLocate2Region,eSTimoteRegion];
}

+ (CLBeaconRegion *)beaconRegionWithItem:(YSBeaconItem *)item
{
    if (item.majorValue == 0 & item.minorValue == 0) {
        return [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid identifier:item.name];
    }else if (item.majorValue != 0 & item.minorValue == 0)
    {
        return [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid major:item.majorValue identifier:item.name];
    }
    return [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid major:item.majorValue minor:item.minorValue identifier:item.name];
}

+ (void)setCompanyBeacon:(CLBeaconRegion *)beaconRegion
{
    companyRegionTmp = beaconRegion;
    YSBeaconItem *beaconItem = [[YSBeaconItem alloc] initWithName:@"companyBeacon" uuid:beaconRegion.proximityUUID major:beaconRegion.major.intValue minor:beaconRegion.minor.intValue];
    NSData *beaconItemData = [NSKeyedArchiver archivedDataWithRootObject:beaconItem];
    [[NSUserDefaults standardUserDefaults] setObject:beaconItemData forKey:RTCompanyItemKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CLBeaconRegion *)getCompanyBeacon
{
    if (!companyRegionTmp) {
        NSData *companyItemData = [[NSUserDefaults standardUserDefaults] objectForKey:RTCompanyItemKey];
        YSBeaconItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:companyItemData];
        CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
        companyRegionTmp = beaconRegion;
    }
    return companyRegionTmp;
    
}

+ (void)setHomeBeacon:(CLBeaconRegion *)beaconRegion
{
    homeRegionTmp = beaconRegion;
    YSBeaconItem *beaconItem = [[YSBeaconItem alloc] initWithName:@"homeBeacon" uuid:beaconRegion.proximityUUID major:beaconRegion.major.intValue minor:beaconRegion.minor.intValue];
    NSData *beaconItemData = [NSKeyedArchiver archivedDataWithRootObject:beaconItem];
    [[NSUserDefaults standardUserDefaults] setObject:beaconItemData forKey:RTHomeItemKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CLBeaconRegion *)getHomeBeacon
{
    if (!homeRegionTmp) {
        NSData *homeItemData = [[NSUserDefaults standardUserDefaults] objectForKey:RTHomeItemKey];
        YSBeaconItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:homeItemData];
        CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
        homeRegionTmp = beaconRegion;
    }
    return homeRegionTmp;
}

+ (BOOL)isCompanyBeacon:(CLBeaconRegion *)beaconRegion
{
    return [self compareBeacon:[self getCompanyBeacon] beacon:beaconRegion];
}

+ (BOOL)isHomeBeacon:(CLBeaconRegion *)beaconRegion
{
    return [self compareBeacon:[self getHomeBeacon] beacon:beaconRegion];
}


+ (BOOL)compareBeacon:(CLBeaconRegion *)firstBeacon beacon:(CLBeaconRegion *)secondBeacon
{
    BOOL isEqual = YES;
    if (![[firstBeacon.proximityUUID UUIDString] isEqualToString:[secondBeacon.proximityUUID UUIDString]]) {
        return NO;
    }
    if (!(firstBeacon.major.intValue == secondBeacon.major.intValue)) {
        return NO;
    }
    if (!(firstBeacon.minor.intValue == secondBeacon.minor.intValue)) {
        return NO;
    }
    return isEqual;
}


@end
