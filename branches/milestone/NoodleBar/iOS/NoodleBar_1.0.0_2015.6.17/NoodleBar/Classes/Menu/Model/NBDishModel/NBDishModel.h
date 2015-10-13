    //
//  NBDishModel.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDishModel : NSObject
@property(nonatomic, copy) NSString *dishID;
/**
 *  名称
 */
@property(nonatomic, copy) NSString *name;
/**
 *  售出总量
 */
@property(nonatomic, assign) int soldAmount;
/**
 *  价格(傻逼后台搞两个字段)
 */
@property(nonatomic, assign) float price;
/**
 *  价格(傻逼后台搞两个字段)
 */
@property(nonatomic, assign) float unitprice;
/**
 *  数量
 */
@property(nonatomic, assign) int amount;
/**
 *  类型
 */
@property(nonatomic, copy) NSString *type;
/**
 *  大图片
 */
@property(nonatomic, copy) NSString *uriraw;
/**
 *  小图片
 */
@property(nonatomic, copy) NSString *urismall;
/**
 *  所属商户
 */
@property(nonatomic, copy) NSString *merchantID;

@property(nonatomic, copy) NSString *available;
@end
