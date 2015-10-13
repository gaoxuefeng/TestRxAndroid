//
//  CSPlayingModel.h
//  CloudSong
//
//  Created by EThank on 15/6/19.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  播放器界面模型、

#import <Foundation/Foundation.h>

@interface CSPlayingModel : NSObject

/** 用户头像 */
@property (nonatomic, copy) NSString *avatarUrl ;

/** 点赞用户的头像 */
@property (nonatomic, strong) NSArray *praiseAvatarUrls ;

/** 点赞个数 */
@property (nonatomic, copy) NSString *praiseCount ;

/** 分享地址 */
@property (nonatomic, copy) NSString *shareUrl ;

/** 用户个性签名 */
@property (nonatomic, copy) NSString *signature ;

/** 该用户录的所有歌曲 */
@property (nonatomic, copy) NSArray *discoveryIds ;

/** 歌曲名 */
@property (nonatomic, copy) NSString *songName ;

/** 用户名 */
@property (nonatomic, copy) NSString *userName ;


@end
