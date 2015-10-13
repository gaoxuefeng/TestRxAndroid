//
//  CSGetDistrictDataResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSGetDistrictDataResponse.h"
#import <MJExtension.h>
#import "CSDistrictItem.h"

@implementation CSGetDistrictDataResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSDistrictItem class]};
}

@end
