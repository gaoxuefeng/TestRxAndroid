//
//  CSBindingRoomResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/2.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSBindingRoomResponseDataModel.h"
@interface CSBindingRoomResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSBindingRoomResponseDataModel *data;
@end
