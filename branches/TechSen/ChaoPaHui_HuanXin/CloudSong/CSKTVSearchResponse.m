//
//  CSKTVSearchResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSKTVSearchResponse.h"
#import <MJExtension.h>
#import "CSKTVModel.h"

@implementation CSKTVSearchResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSKTVModel class]};
}

@end
