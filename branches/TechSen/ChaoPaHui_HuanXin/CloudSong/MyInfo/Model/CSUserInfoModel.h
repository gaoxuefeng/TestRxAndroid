//
//  CSUserInfoModel.h
//  CloudSong
//
//  Created by Ronnie on 15/6/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUserInfoModel : NSObject <NSCopying>
@property (nonatomic,strong) NSNumber *age;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *bloodType;
/** 星座 */
@property (nonatomic,copy) NSString *constellation;
@property(nonatomic, copy) NSString *signature;
@property (nonatomic,copy) NSString *loveSingers;
@property (nonatomic,copy) NSString *loveSongs;
//@property (nonatomic,copy) NSString *wechatId;
//@property (nonatomic,copy) NSString *weiboId;
//@property (nonatomic,copy) NSString *whatIsUp;

- (BOOL)isEqualUserInfo:(CSUserInfoModel *)userInfo;
@end
