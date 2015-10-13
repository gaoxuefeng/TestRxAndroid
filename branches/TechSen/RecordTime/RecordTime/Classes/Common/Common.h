//
//  Common.h
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface Common : NSObject
/** 是否已填写基本数据信息 */
@property(assign, nonatomic, readonly) BOOL hasSetProfile;
singleton_h(Common)
@end
