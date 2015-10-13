//
//  NBCartTool.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBDishModel.h"
#import "NBMerchantPromotModel.h"

@interface NBCartTool : NSObject

/**
 *  改变菜
 *
 *  @param good 菜模型
 */
+ (void)alterDish:(NBDishModel *)dish;

/**
 *  清空购物车
 */
+ (void)emptyShoppingCart;

/**
 *  获取所有购物车中的所有菜
 *
 *  @return 然会菜数组
 */
+ (NSArray *)dishes;

/**
 *  获取购物车菜品数量
 *
 *  @return 菜的数量
 */
+ (int)dishesCount;

/**
 *  获取购物车菜品总价
 *
 *  @return 菜的总价
 */
+ (float)dishesPrice;

/** 原总价 */
+ (float)originalPrice;

/**
 *  设置优惠规则数组
 */
+ (void)setPromots:(NSArray *)promots;

/** 返回当前符合的优惠 无返回nil */
+ (NBMerchantPromotModel *)promot;


@end
