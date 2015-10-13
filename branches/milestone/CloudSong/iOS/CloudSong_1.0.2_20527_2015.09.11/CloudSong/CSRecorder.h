//
//  CSRecorder.h
//  CloudSong
//
//  Created by youmingtaizi on 8/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRecorder : NSObject
+ (instancetype)sharedInstance;
- (void)startRecord;
- (void)stopRecord;
@end
