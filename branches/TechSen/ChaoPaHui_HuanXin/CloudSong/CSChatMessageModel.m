//
//  CSChatMessageModel.m
//  CloudSong
//
//  Created by sen on 15/7/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSChatMessageModel.h"
#import <MJExtension.h>
@implementation CSChatMessageModel


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"content":@"msgContent",@"nickName":@"userName",@"type":@"msgType"};
}
@end
