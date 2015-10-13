//
//  CSRoomInfoResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSRoomInfoModel.h"
@interface CSRoomInfoResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSRoomInfoModel *data;
@end
