//
//  CSRecommendedAlbums.h
//  CloudSong
//
//  Created by youmingtaizi on 6/5/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"

@class CSRecommendedAlbumsData;

@interface CSRecommendedAlbumsResponse : CSBaseResponseModel
@property (nonatomic, strong)CSRecommendedAlbumsData*   data;
@end
