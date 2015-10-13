//
//  CSRemoteControlViewController.h
//  CloudSong
//
//  Created by sen on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
@class CSMyRoomInfoModel;


@interface CSRemoteControlViewController : CSBaseViewController
- (instancetype)initWithRoomInfo:(CSMyRoomInfoModel *)roomInfo;
@end
