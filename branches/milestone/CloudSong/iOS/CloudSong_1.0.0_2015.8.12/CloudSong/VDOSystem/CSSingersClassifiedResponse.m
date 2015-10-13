//
//  CSSingersClassifiedResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSingersClassifiedResponse.h"
#import "CSSinger.h"
#import <MJExtension.h>

@implementation CSSingersClassifiedResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSinger class]};
}

@end
