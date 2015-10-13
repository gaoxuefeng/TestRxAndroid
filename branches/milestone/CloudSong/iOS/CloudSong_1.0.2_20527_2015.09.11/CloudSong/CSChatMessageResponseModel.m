//
//  CSChatMessageResponseModel.m
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSChatMessageResponseModel.h"
#import <MJExtension.h>
@implementation CSChatMessageResponseModel

+ (NSDictionary *)objectClassInArray
{
    return  @{@"data":[CSChatMessageModel class]};
}

@end
