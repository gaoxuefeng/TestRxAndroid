//
//  CSDistrictItem.m
//  CloudSong
//
//  Created by youmingtaizi on 6/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDistrictItem.h"

@implementation CSDistrictItem

- (NSArray *)circleName
{
    NSMutableArray *placeNames = [NSMutableArray arrayWithObject:_district];
    [placeNames addObjectsFromArray:_circleName];
//    [placeNames insertObject:@"全区" atIndex:0];
    [placeNames replaceObjectAtIndex:0 withObject:@"全区"];
    return placeNames;
}

@end
