//
//  CSKTVDishListResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSKTVDishListResponseDataModel.h"
@interface CSKTVDishListResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSKTVDishListResponseDataModel *data;
@end
