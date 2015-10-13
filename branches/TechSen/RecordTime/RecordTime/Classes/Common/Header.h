//
//  Header.h
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#ifndef RecordTime_Header_h
#define RecordTime_Header_h

#import <Masonry.h>
#import "Common.h"
#import "UIView+Extension.h"
#import "FMDBTool.h"
#import "RTBeaconTool.h"
#import "RTDateTool.h"

/** rgb颜色转换（16进制->10进制）*/
#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define AUTOLENGTH(x) (x / 320.0 * SCREEN_WIDTH)

#define DEFAULT_BG_COLOR HEX_COLOR(0xF3F3F3)

#define MAIN_BG_COLOR HEX_COLOR(0xBFFDCA)


/** Document路径 */
#define DOCUMENT_DIRECTION [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

// DEBUG
#if DEBUG
#define RTLog(...) NSLog(__VA_ARGS__)
#else
#define RTLog(...)
#endif


#endif
