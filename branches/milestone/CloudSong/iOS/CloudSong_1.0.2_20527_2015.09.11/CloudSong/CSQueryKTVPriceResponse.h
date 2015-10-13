//
//  CSQueryKTVPriceResponse.h
//  CloudSong
//
//  Created by youmingtaizi on 6/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"

@class CSQueryKTVPriceItem;

@interface CSQueryKTVPriceResponse : CSBaseResponseModel
@property (nonatomic, strong)CSQueryKTVPriceItem*  data;
@end
