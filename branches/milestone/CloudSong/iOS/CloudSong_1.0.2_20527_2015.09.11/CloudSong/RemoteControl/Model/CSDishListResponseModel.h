//
//  CSDishListResponseModel.h
//  CloudSong
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSDishModel.h"
@interface CSDishListResponseModel : CSBaseResponseModel
@property(nonatomic, strong) NSArray *data;
@end
