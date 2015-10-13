//
//  CSRoomResponseModel.m
//  CloudSong
//
//  Created by sen on 15/7/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomResponseModel.h"
#import <MJExtension.h>
#import "CSMyRoomModel.h"
@implementation CSRoomResponseModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[CSMyRoomModel class]};
}


@end
