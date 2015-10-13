//
//  NBMerchantResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBMerchantModel.h"
@interface NBMerchantResponseModel : NBResponseModel
@property(nonatomic, strong) NBMerchantModel *data;
@end
