//
//  CSRegisterResponeModel.h
//  CloudSong
//
//  Created by Ronnie on 15/6/2.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseResponseModel.h"
#import "CSUserInfoModel.h"
#import "CSMyRoomInfoModel.h"
@interface CSUserDataResponeModel : NSObject
@property (nonatomic,copy) NSString *token;
@property (nonatomic,strong) CSUserInfoModel *userInfo;
@property(nonatomic, strong) NSArray *myrooms;

@end
