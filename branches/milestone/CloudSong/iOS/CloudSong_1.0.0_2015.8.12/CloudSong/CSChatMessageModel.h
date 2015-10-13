//
//  CSChatMessageModel.h
//  CloudSong
//
//  Created by sen on 15/7/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    CSChatMessageTypeMessage,
    CSChatMessageTypeRoomState,
    CSChatMessageTypePicture
}CSChatMessageType;


@interface CSChatMessageModel : NSObject
@property(nonatomic, copy) NSString *headUrl;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *msgId;
@property(nonatomic, assign) CSChatMessageType type;
@end
