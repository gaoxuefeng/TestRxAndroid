//
//  NBOrderResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBOrderModel.h"
@interface NBOrderResponseModel : NBResponseModel
@property(nonatomic, strong) NSMutableArray *data;
@end
