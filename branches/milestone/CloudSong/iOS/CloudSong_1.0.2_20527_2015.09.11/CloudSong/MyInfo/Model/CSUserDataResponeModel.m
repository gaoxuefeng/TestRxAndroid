//
//  CSRegisterResponeModel.m
//  CloudSong
//
//  Created by Ronnie on 15/6/2.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSUserDataResponeModel.h"
#import <MJExtension.h>

@implementation CSUserDataResponeModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"myrooms":[CSMyRoomInfoModel class]};
}

@end
