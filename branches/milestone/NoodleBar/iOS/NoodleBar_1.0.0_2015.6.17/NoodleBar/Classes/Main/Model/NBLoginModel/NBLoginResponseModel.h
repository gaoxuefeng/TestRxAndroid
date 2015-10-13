//
//  NBLoginResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBLoginResponseDataModel.h"
@interface NBLoginResponseModel : NBResponseModel
@property(nonatomic, strong) NBLoginResponseDataModel *data;
@end
