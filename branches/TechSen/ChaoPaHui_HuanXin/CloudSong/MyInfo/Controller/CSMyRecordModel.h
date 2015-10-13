//
//  CSMyRecordModel.h
//  CloudSong
//
//  Created by EThank on 15/7/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMyRecordModel : NSObject
/**
 *  时长
 */
@property (nonatomic, copy) NSString *duration ;
/**
 *  音乐名称
 */
@property (nonatomic, copy) NSString *musicName ;
/**
 *  录音时间
 */
@property (nonatomic, copy) NSString *recordTime ;
/**
 *  录音地址
 */
@property (nonatomic, copy) NSString *recordUrl ;

@end
