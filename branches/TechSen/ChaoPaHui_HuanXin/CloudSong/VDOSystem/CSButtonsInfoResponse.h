//
//  CSButtonsInfoResponse.h
//  CloudSong
//
//  Created by youmingtaizi on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"

@class CSButtonDataResponse;

@interface CSButtonsInfoResponse : CSBaseResponseModel
@property (nonatomic, strong)CSButtonDataResponse*  data;
@end
