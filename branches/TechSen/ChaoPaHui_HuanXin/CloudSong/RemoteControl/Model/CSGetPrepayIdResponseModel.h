//
//  CSGetPrepayIdResponseModel.h
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSGetPrepayIdDataResponseModel.h"
@interface CSGetPrepayIdResponseModel : CSBaseResponseModel
@property(nonatomic, strong) CSGetPrepayIdDataResponseModel *data;
@end
