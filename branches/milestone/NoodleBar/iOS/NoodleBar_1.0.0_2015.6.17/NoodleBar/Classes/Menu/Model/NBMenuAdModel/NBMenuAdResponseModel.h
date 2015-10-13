//
//  NBMenuAdResponseModel.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBMenuAdModel.h"
#import "NBGetMerchantAdResponseDataModel.h"
@interface NBMenuAdResponseModel : NBResponseModel
@property(nonatomic, strong) NBGetMerchantAdResponseDataModel *data;
@end
