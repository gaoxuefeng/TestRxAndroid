//
//  CSRoomDetailResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/6.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSRoomDetailModel.h"
@interface CSRoomDetailResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSRoomDetailModel *data;
@end
