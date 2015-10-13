//
//  CSTuanGouResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 7/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSTuanGouResponse.h"
#import <MJExtension.h>
#import "CSTuanGouItem.h"

@implementation CSTuanGouResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSTuanGouItem class]};
}

@end
