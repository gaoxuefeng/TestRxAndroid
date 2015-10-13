//
//  NBOrderModel.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBCommon.h"
#import "NBMerchantPromotModel.h"

@interface NBOrderModel : NSObject
{
    @public
    NSString *_orderTime;
}
/**
 *  订单号码
 */
@property(nonatomic, copy) NSString *orderID;
/**
 *  订单时间
 */
@property(nonatomic, copy) NSString *orderTime;
/** 判断过是否为今天明天的订单时间 */
@property(nonatomic, copy) NSString *autoOrderTime;
/**
 *  支付方式
 */
@property(nonatomic, assign) NBPayMethodType payMethod;
/**
 *  手机号码
 */
@property(nonatomic, copy) NSString *phone;
/**
 *  收餐地址
 */
@property(nonatomic, copy) NSString *address;
/**
 *  取餐号
 */
@property(nonatomic, copy) NSString *takeCode;
/**
 *  商家
 */
@property(nonatomic, copy) NSString *merchant;
/**
 *  商家图片
 */
@property(nonatomic, copy) NSString *merchantImage;
/**
 *  商户ID
 */
@property(nonatomic, copy) NSString *merchantID;
/**
 *  订单状态
 */
@property(nonatomic, assign) NBOrderStatusType status;
/**
 *  菜品详情
 */
@property(nonatomic, strong) NSArray *dishes;
/**
 *  总价格
 */
@property(nonatomic, assign) CGFloat price;

#pragma mark - 新增
/** 实际价格 */
@property(nonatomic, copy) NSString *realMoney;
/** 优惠类型 */
@property(nonatomic, assign) NBPromotType promottype;

@property(nonatomic, copy) NSString *promotdetail;
/** 微信预订单 */
@property(nonatomic, copy) NSString *prepayid;

@property(nonatomic, copy) NBMerchantPromotModel *promot;

@end
