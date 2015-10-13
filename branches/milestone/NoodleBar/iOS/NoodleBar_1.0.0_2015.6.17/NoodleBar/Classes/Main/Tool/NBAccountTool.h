//
//  NBAccountTool.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//  账号工具类

#import <Foundation/Foundation.h>
#import "NBAccountModel.h"
@interface NBAccountTool : NSObject
/**
 *  获取账号信息
 *
 *  @return 账号信息
 */
+ (NBAccountModel *)account;
/**
 *  设置账号信息
 *
 *  @param account 账号
 */
+ (void)setAccount:(NBAccountModel *)account;

/**
 *  返回userToken
 *
 *  @return userToken
 */
+ (void)setAddresses:(NSMutableArray *)addresses;


+ (NSString *)userToken;
/**
 *  设置userToken
 */
+ (void)setUserToken:(NSString *)userToken;
/**
 *  返回userId
 *
 *  @return userId
 */
+ (NSString *)userId;
/**
 *  设置userId
 */
+ (void)setUserId:(NSString *)userId;

@end
