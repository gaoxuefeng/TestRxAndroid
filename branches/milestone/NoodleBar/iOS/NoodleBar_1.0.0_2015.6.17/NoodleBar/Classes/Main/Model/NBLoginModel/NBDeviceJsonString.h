//
//  NBDeviceJsonString.h
//  NoodleBar
//
//  Created by sen on 15/5/4.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDeviceJsonString : NSObject
/** 设备ID */
@property(nonatomic, copy) NSString *did;
/** 设备类型 1:安卓 2:iOS*/
@property(nonatomic, copy) NSString *dev;
/** app版本号 */
@property(nonatomic, copy) NSString *appver;
/** 系统版本 */
@property(nonatomic, copy) NSString *rom;
/** 用于极光推送 */
@property(nonatomic, copy) NSString *registrationID;
@end
