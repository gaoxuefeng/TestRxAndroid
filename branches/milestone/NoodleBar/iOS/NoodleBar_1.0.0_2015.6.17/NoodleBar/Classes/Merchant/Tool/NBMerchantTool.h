//
//  NBMerchantTool.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBMerchantModel.h"
@interface NBMerchantTool : NSObject
/** 设置当前餐厅信息 */
+ (void)setCurrentMerchant:(NBMerchantModel *)currentMerchant;
/** 获取当前餐厅信息 */
+ (NBMerchantModel *)currentMerchant;
/** 设置当前桌号 */
+ (void)setCurrentTableCode:(NSString *)currentTableCode;
/** 获取当前桌号 */
+ (NSString *)currentTableCode;
/** 设置当前商户ID */
+ (void)setCurrentMerchantID:(NSString *)currentMerchantID;
/** 获取当前商户ID */
+ (NSString *)currentMerchantID;
@end
