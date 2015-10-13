//
//  NBDishResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBRequestModel.h"
#import "NBDishModel.h"
@interface NBDishResponseModel : NBRequestModel
@property(nonatomic, strong) NSMutableArray *data;
@end
