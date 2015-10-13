//
//  CSSettingItem.h
//  CloudSong
//
//  Created by sen on 15/6/13.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^option)();
@interface CSSettingItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) option option;
@end
