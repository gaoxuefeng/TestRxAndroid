//
//  NBGetTakeCodeResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/5/11.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBGetTakeCodeResponseDataModel.h"
@interface NBGetTakeCodeResponseModel : NBResponseModel
@property(nonatomic, strong) NBGetTakeCodeResponseDataModel *data;
@end
