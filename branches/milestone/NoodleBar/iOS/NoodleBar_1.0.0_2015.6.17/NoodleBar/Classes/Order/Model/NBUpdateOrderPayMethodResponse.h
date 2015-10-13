//
//  NBUpdateOrderPayMethodResponse.h
//  NoodleBar
//
//  Created by sen on 6/9/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBResponseModel.h"
#import "NBUpdateOrderPayMethodDataModel.h"
@interface NBUpdateOrderPayMethodResponse : NBResponseModel
@property(nonatomic, strong) NBUpdateOrderPayMethodDataModel *data;
@end
