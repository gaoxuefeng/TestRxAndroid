//
//  CSQueryKTVPriceItem.m
//  CloudSong
//
//  Created by youmingtaizi on 7/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSQueryKTVPriceItem.h"
#import <MJExtension.h>
#import "CSKTVRoomItem.h"

@implementation CSQueryKTVPriceItem

+ (NSDictionary *)objectClassInArray {
    return @{@"roomQueryList" : [CSKTVRoomItem class]};
}

@end
