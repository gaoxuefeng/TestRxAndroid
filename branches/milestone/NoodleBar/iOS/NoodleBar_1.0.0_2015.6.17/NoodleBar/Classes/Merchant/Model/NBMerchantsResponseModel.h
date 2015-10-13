//
//  NBMerchantsResponseModel.h
//  NoodleBar
//
//  Created by sen on 6/3/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBMerchantModel.h"
@interface NBMerchantsResponseModel : NBResponseModel
@property(nonatomic, strong) NSMutableArray *data;

@end
