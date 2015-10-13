//
//  CSRoomQRResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSRoomQRModel.h"
@interface CSRoomQRResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSRoomQRModel *data;
@end
