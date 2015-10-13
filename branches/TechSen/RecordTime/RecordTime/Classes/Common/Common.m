//
//  Common.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "Common.h"
#import "RTBeaconTool.h"

@implementation Common
singleton_m(Common)


- (BOOL)hasSetProfile
{
//    return NO;
    return [RTBeaconTool getCompanyBeacon];
}

@end
