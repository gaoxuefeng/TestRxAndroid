//
//  CSGenerateOrderResponse.h
//  CloudSong
//
//  Created by youmingtaizi on 6/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"

@class CSKTVBookingOrder;

@interface CSGenerateOrderResponse : CSBaseResponseModel
@property (nonatomic, strong)CSKTVBookingOrder*  data;
@end
