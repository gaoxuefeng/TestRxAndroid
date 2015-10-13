//
//  CSFindThemeResponseModel.m
//  CloudSong
//
//  Created by Ethank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSFindThemeResponseModel.h"
#import "CSFindThemeModel.h"
@implementation CSFindThemeResponseModel

+ (NSDictionary *)objectClassInArray {
    return @{@"data" : [CSFindThemeModel class]};
}
@end
