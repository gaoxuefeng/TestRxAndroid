//
//  CSRecordsModel.h
//  CloudSong
//
//  Created by EThank on 15/6/19.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  发现页面模型、获取录音数据

#import <Foundation/Foundation.h>

@interface CSRecordsModel : NSObject

/** 用户头像 */
@property (nonatomic, copy) NSString *avatarUrl ;

/** 听的次数 */
@property (nonatomic, copy) NSString *listenCount ;

/** 录音时长 */
@property (nonatomic, copy) NSString *musicDuration ;

/** 录音名称 */
@property (nonatomic, copy) NSString *musicName ;

/** 歌曲封面地址 */
@property (nonatomic, copy) NSString *musicPhotoUrl ;

/** 点赞次数 */
@property (nonatomic, copy) NSString *praiseCount ;

/** 歌曲ID */
@property (nonatomic, copy) NSString *songId ;

/** 用户昵称 */
@property (nonatomic, copy) NSString *userNickName ;

/** 发现ID */
@property (nonatomic, copy) NSString *discoverId ;

/** 歌曲URL */
@property (nonatomic, copy) NSString *musicUrl ;

/** 分享Url */
@property (nonatomic, copy) NSString *shareUrl ;


@end
