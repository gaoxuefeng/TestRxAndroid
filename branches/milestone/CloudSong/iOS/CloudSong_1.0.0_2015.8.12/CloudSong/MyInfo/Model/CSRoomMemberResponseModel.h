//
//  CSRoomMemberResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSJoinModel.h"
@interface CSRoomMemberResponseModel : CSBaseResponseModel
@property(nonatomic, strong) NSArray *data;
@end
