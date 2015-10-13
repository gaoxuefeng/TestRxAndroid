//
//  NBMerchantTool.m
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMerchantTool.h"

@implementation NBMerchantTool
static NBMerchantModel *currentMerchantTemp;
static NSString *currentTableCodeTemp;
static NSString *currentMerchantIDTemp;


+ (void)setCurrentMerchant:(NBMerchantModel *)currentMerchant
{
    currentMerchantTemp = currentMerchant;
}

+ (NBMerchantModel *)currentMerchant
{
    return currentMerchantTemp;
}

/** 设置当前桌号 */
+ (void)setCurrentTableCode:(NSString *)currentTableCode
{
    currentTableCodeTemp = currentTableCode;
}
/** 获取当前桌号 */
+ (NSString *)currentTableCode
{
    return currentTableCodeTemp;
}

/** 设置当前商户ID */
+ (void)setCurrentMerchantID:(NSString *)currentMerchantID
{
    currentMerchantIDTemp = currentMerchantID;
}
/** 获取当前商户ID */
+ (NSString *)currentMerchantID
{
    return currentMerchantIDTemp;
}
@end
