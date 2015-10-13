//
//  NBAccountModel.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBAddressModel.h"
@interface NBAccountModel : NSObject
/**
 *  用户编码
 */
@property(nonatomic, copy) NSString *userid;
/**
 *  用户昵称
 */
@property(nonatomic, copy) NSString *username;
/**
 *  用户性别
 */
@property(nonatomic, assign) GenderType gender;
/**
 *  手机号
 */
@property(nonatomic, copy) NSString *phonenum;
/**
 *  送餐地址
 */
@property(nonatomic, strong) NSMutableArray *addresses;

@property(nonatomic, copy) NSString *token;

@end
