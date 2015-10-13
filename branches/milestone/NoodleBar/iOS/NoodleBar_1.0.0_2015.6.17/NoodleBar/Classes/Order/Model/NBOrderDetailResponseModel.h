//
//  NBOrderDetailResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/30.
//  Copyright (c) 2015年 sen. All rights reserved.
//
#import "NBResponseModel.h"
#import "NBOrderDetailResponseDataModel.h"
@interface NBOrderDetailResponseModel : NBResponseModel
@property(nonatomic, strong) NBOrderDetailResponseDataModel *data;
@end
