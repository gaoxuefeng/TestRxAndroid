//
//  CSSongCategoriesResponse.m
//  CloudSong
//
//  Created by youmingtaizi on 6/10/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongCategoriesResponse.h"
#import "CSSongCategoryItem.h"
#import <MJExtension.h>

@implementation CSSongCategoriesResponse

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSSongCategoryItem class]};
}

@end
