//
//  CSMusicPlayerViewController.h
//  CloudSong
//
//  Created by EThank on 15/6/12.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSDefine.h"
typedef void(^PraiseBlock)(NSNumber * count);
typedef void(^PlayCountBlock)();


@interface CSMusicPlayerViewController : CSBaseViewController

- (instancetype)initWithShareUrl:(NSString *)shareUrl;

/** 发现id */
@property (nonatomic, copy) NSString *discoveryId ; // 获取歌曲以及其他相关信息
/** 音乐链接 */
@property (nonatomic, copy) NSString *musicUrl ;
/** 音乐名 */
@property (nonatomic, copy) NSString *musicName ;

@property (nonatomic,copy) PraiseBlock praiseBlock;
@property (nonatomic,copy) PlayCountBlock playCountBlock;


@end
