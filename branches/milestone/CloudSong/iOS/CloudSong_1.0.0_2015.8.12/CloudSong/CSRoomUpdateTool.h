//
//  CSRoomUpdateTool.h
//  CloudSong
//
//  Created by sen on 15/8/5.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSRoomUpdateTool : NSObject

+ (instancetype)sharedSingleton;

- (void)addTimerAfterTimeInterval:(NSTimeInterval)timeInterval;

- (void)resetTimers;
@end
