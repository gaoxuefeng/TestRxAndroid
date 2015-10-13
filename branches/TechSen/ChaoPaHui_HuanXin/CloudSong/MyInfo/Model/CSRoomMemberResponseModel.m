//
//  CSRoomMemberResponseModel.m
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomMemberResponseModel.h"
#import <MJExtension.h>
@implementation CSRoomMemberResponseModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[CSJoinModel class]};
}
@end
