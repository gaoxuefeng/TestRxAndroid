//
//  NBAccountResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBAccountDataResponseModel.h"
@interface NBAccountResponseModel : NBResponseModel
@property(nonatomic, strong) NBAccountDataResponseModel *data;

@end
