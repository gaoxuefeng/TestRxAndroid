//
//  CSFindThemeModel.h
//  CloudSong
//
//  Created by Ethank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFindThemeModel : NSObject

/*  播放次数  */
@property (nonatomic, copy)NSString * listenCount;
/*  专题期数  */
@property (nonatomic, copy)NSString * period;
/*  点赞数  */
@property (nonatomic, copy)NSString * praiseCount;
/*  专题id  */
@property (nonatomic, copy)NSString * specialId;
/*  专题背景图片路径  */
@property (nonatomic, copy)NSString * specialImgPath;
/*  专题名称  */
@property (nonatomic, copy)NSString * specialName;
@end
