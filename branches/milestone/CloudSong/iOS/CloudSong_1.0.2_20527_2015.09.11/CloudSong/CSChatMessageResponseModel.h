//
//  CSChatMessageResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSChatMessageModel.h"
@interface CSChatMessageResponseModel : CSBaseResponseModel
@property(nonatomic, strong) NSArray *data;
@end
