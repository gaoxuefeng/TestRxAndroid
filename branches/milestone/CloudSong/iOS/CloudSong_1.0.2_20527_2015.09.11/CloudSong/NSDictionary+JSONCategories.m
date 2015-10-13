//
//  NSDictionary+JSONCategories.m
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NSDictionary+JSONCategories.h"

@implementation NSDictionary (JSONCategories)
- (NSString *)JSONString
{
        NSError* error = nil;
        id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) return nil;
        NSString *jsonStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        return jsonStr;
}
@end
