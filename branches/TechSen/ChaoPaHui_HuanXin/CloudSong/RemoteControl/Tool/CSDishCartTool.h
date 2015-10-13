//
//  CSDishCartTool.h
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDishModel.h"
#define CART_CONTENT_CHANGED @"cartContentChanged"// 购物车内容改变通知
@interface CSDishCartTool : NSObject
/** 修改菜品 */
+ (void)alterDish:(CSDishModel *)dish;

/** 获取购物车所有菜品 */
+ (NSArray *)dishes;

/** 购物车所有菜品的总价 */
+ (float)totalPrice;

/** 清空购物车 */
+ (void)emptyCart;

/** 是否为空 */
+ (BOOL)isEmpty;

/** 获取购物车菜品数量 */
+ (int)dishesAmount;
@end
