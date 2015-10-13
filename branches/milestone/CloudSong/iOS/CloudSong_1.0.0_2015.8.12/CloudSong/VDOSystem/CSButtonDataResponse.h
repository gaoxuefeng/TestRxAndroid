//
//  CSButtonDataResponse.h
//  CloudSong
//
//  Created by youmingtaizi on 6/4/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"

@interface CSButtonDataResponse : NSObject
@property (nonatomic, assign)int        version;
@property (nonatomic, strong)NSArray*   buttonInfo;
@end
