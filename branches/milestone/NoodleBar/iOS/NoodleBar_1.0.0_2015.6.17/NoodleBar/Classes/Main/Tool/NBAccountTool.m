//
//  NBAccountTool.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAccountTool.h"
#define USER_TOKEN_KEY @"userToken"
#define USER_USER_ID_KEY @"userId"
@implementation NBAccountTool
static NBAccountModel *accountTemp;
static NSString *userTokenTemp;
static NSString *userIdTemp;

+ (NBAccountModel *)account
{
    return accountTemp;
}

+ (void)setAccount:(NBAccountModel *)account
{
    accountTemp = account;
//    [self setUserId:account.userid];
//    [self setUserToken:account.token];
    
}

+ (void)setAddresses:(NSMutableArray *)addresses
{
    accountTemp.addresses = addresses;
}

#pragma mark - userToken
+ (NSString *)userToken
{
    if (userTokenTemp && userTokenTemp.length >0) // 如果内存中有token直接返回
        return userTokenTemp;
    
    // 如果内存中没有token,从偏好设置中取,存入内存,并返回
    userTokenTemp = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN_KEY];
    return  userTokenTemp;
}

+ (void)setUserToken:(NSString *)userToken
{
    // 先存入内存
    userTokenTemp = userToken;
    // 再存入偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:userTokenTemp forKey:USER_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  返回userId
 *
 *  @return userId
 */
+ (NSString *)userId
{
    if (userIdTemp && userIdTemp > 0) // 如果内存中有userId直接返回
        return userIdTemp;
    
    // 如果内存中没有userId,从偏好设置中取,存入内存,并返回
    userIdTemp = [[NSUserDefaults standardUserDefaults] valueForKey:USER_USER_ID_KEY];
    return  userIdTemp;
}
/**
 *  设置userId
 */
+ (void)setUserId:(NSString *)userId
{
    // 先存入内存
    userIdTemp = userId;
    // 再存入偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
