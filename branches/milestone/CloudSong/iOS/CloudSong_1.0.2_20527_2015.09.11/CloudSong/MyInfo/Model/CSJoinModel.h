//
//  CSJoinModel.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSJoinModel : NSObject
@property(nonatomic, copy) NSString *joinTimeStamp;
@property(nonatomic, copy) NSString *serverTimeStamp;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *imageUrl;
@property(nonatomic, copy) NSString *gender;
@property(nonatomic, copy) NSString *phoneNum;
/** 离开始分钟数 */
@property(nonatomic, copy) NSString *date;
@end
