//
//  CSGetPlayerDataResponse.h
//  CloudSong
//
//  Created by EThank on 15/7/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
@class CSPlayingModel ;

@interface CSDiscoveryPlayerResponse : CSBaseResponseModel
@property (nonatomic, strong) CSPlayingModel *data ;

@end
