//
//  NBOrderJsonString.h
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBCommon.h"
@interface NBOrderJsonString : NSObject
@property(nonatomic, copy) NSString *ordertime;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, assign) NBOrderStatusType orderstatus;
@property(nonatomic, assign) NBPayMethodType paytype;
@property(nonatomic, copy) NSString *businessid;
@property(nonatomic, copy) NSString *businessname;
@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *addressid;
@property(nonatomic, copy) NSString *picurl;

#pragma mark - 新增
@property(nonatomic, assign) NBAddressType addresstype;

@end
