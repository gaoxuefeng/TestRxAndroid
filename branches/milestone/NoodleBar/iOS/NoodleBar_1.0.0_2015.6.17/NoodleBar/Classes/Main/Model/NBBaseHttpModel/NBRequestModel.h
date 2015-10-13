//
//  NBRequestModel.h
//  NoodleBar
//
//  Created by sen on 15/4/27.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBAddressModel.h"
#import "NBAddressJsonStringModel.h"
#import "NBFeedbackJsonStringModel.h"
#import "NBDeviceJsonString.h"
#import "NBOrderJsonString.h"
#import "NBOrderDetailJsonString.h"
#import "NBOrderJsonString.h"
@interface NBRequestModel : NSObject
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *deviceJsonString;
@property(nonatomic, copy) NSString *cityName;
/** 手机号 */
@property(nonatomic, copy) NSString *phoneNum;
/** 验证码 */
@property(nonatomic, copy) NSString *code;
@property(nonatomic, strong) NBAddressModel *address;
@property(nonatomic, copy) NSString *addressid;
@property(nonatomic, copy) NSString *addressJsonString;
@property(nonatomic, copy) NSString *orderid;
@property(nonatomic, strong) NSNumber *page;
@property(nonatomic, strong) NSNumber *orderstatus;
@property(nonatomic, copy) NSString *feedBackJsonString;
@property(nonatomic, copy) NSString *businessid;
@property(nonatomic, copy) NSString *orderJsonString;
@property(nonatomic, copy) NSString *orderDetailListJsonString;
@property(nonatomic, copy) NSNumber *paytype;
@property(nonatomic, copy) NSString *addressdetail;
@end
