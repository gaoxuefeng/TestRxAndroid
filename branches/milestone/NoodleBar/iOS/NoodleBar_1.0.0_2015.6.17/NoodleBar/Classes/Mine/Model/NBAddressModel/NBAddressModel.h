//
//  NBAddressModel.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBCommon.h"


@interface NBAddressModel : NSObject
/**
 *  地址编号
 */
@property(nonatomic, copy) NSString *addressID;
/**
 *  姓名
 */
@property(nonatomic, copy) NSString *name;
/**
 *  性别
 */
@property(nonatomic, assign) GenderType gender;
/**
 *  地址
 */
@property(nonatomic, copy) NSString *address;
/**
 *  手机号
 */
@property(nonatomic, copy) NSString *phone;
/**
 *  是否被选中
 */
@property(nonatomic, assign) BOOL selected;
@end
