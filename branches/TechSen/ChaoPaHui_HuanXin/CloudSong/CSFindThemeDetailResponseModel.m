//
//  CSFindThemeDetailResponseModel.m
//  CloudSong
//
//  Created by Ethank on 15/8/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSFindThemeDetailResponseModel.h"
#import "CSFindThemeDetailModel.h"

@implementation CSFindThemeDetailResponseModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data":[CSFindThemeDetailModel class]};
}

@end
