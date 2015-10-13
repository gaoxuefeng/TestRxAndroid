//
//  YSBeaconItem.m
//  YSBeaconDemo
//
//  Created by sen on 8/13/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "YSBeaconItem.h"

static NSString * const YSItemNameKey = @"name";
static NSString * const YSItemUUIDKey = @"uuid";
static NSString * const YSItemMajorValueKey = @"major";
static NSString * const YSItemMinorValueKey = @"minor";


@implementation YSBeaconItem

- (instancetype)initWithName:(NSString *)name uuid:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = name;
    _uuid = uuid;
    _majorValue = major;
    _minorValue = minor;
    
    return self;
}


#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = [aDecoder decodeObjectForKey:YSItemNameKey];
    _uuid = [aDecoder decodeObjectForKey:YSItemUUIDKey];
    _majorValue = [[aDecoder decodeObjectForKey:YSItemMajorValueKey] unsignedIntegerValue];
    _minorValue = [[aDecoder decodeObjectForKey:YSItemMinorValueKey] unsignedIntegerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:YSItemNameKey];
    [aCoder encodeObject:self.uuid forKey:YSItemUUIDKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.majorValue] forKey:YSItemMajorValueKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.minorValue] forKey:YSItemMinorValueKey];
}

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon {
    if ([[beacon.proximityUUID UUIDString] isEqualToString:[self.uuid UUIDString]] &&
        [beacon.major isEqual: @(self.majorValue)] &&
        [beacon.minor isEqual: @(self.minorValue)])
    {
        return YES;
    } else {
        return NO;
    }
}

@end
