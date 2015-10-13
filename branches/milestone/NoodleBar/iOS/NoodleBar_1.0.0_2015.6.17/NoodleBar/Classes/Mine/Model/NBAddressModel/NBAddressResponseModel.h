//
//  NBAddressResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBAddressModel.h"
@interface NBAddressResponseModel : NBResponseModel
@property(nonatomic, strong) NBAddressModel *address;
@end
