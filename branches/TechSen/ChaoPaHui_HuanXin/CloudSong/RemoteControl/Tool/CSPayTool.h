//
//  CSPayTool.h
//  CloudSong
//
//  Created by sen on 15/7/3.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CSPayTool : NSObject
/**
 *  支付宝支付
 *
 *  @param orderId            订单号
 *  @param productName        商品名
 *  @param productDescription 商品描述
 *  @param price              商品价格
 *  @param callBack           回调
 */
+ (void)alipayWithOrderId:(NSString *)orderId productName:(NSString *)productName productDescription:(NSString *)productDescription price:(NSString *)price callBack:(void(^)(NSDictionary *resultDic))callBack;
/**
 *  微信支付
 *
 *  @param prepayOrderID 预订单号
 */
+ (void)wechatPayWithPrepayOrderID:(NSString *)prepayOrderID;
@end
