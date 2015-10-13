//
//  CSQueryKTVPriceItem.h
//  CloudSong
//
//  Created by youmingtaizi on 7/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSQueryKTVPriceResponse.h"

@interface CSQueryKTVPriceItem : CSQueryKTVPriceResponse
@property (nonatomic, strong)NSString*  day;
@property (nonatomic, strong)NSString*  hour;
@property (nonatomic, strong)NSString*  duration;
@property (nonatomic, strong)NSArray*   roomQueryList;
@end
