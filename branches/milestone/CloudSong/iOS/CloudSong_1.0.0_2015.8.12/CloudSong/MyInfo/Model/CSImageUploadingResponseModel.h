//
//  CSImageUploadingResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/8.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSImageUploadingResponseDataModel.h"
@interface CSImageUploadingResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSImageUploadingResponseDataModel *data;
@end
