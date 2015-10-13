//
//  CSKTVRoomItem.h
//  CloudSong
//
//  Created by youmingtaizi on 6/24/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CSKTVRoomItem : NSObject
/** 时间 */
@property (nonatomic, strong)NSString*  reserveTime;
/** 价格 */
@property (nonatomic, strong)NSString*  price;
/** 选择的房间类型 */
@property (nonatomic, strong)NSString*  boxTypeChoice;
/** 房间是否可用 */
@property (nonatomic, assign)BOOL       boxTypeState;
/** 持续小时数 */
@property (nonatomic, strong)NSString*  durationTime;
@property (nonatomic, strong)NSString*  boxTypeName;
@property (nonatomic, strong)NSNumber*  boxTypeId;
@end