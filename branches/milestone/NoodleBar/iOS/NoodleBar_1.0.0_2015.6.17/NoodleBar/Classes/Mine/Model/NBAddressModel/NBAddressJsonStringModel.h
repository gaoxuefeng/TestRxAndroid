//
//  NBAddressJsonStringModel.h
//  NoodleBar
//
//  Created by sen on 15/4/29.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBCommon.h"
@interface NBAddressJsonStringModel : NSObject
@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *uname;
@property(nonatomic, copy) NSString *phonenum;
@property(nonatomic, copy) NSString *detailaddress;
@property(nonatomic, assign) GenderType sex;
@property(nonatomic, copy) NSString *addressid;
@end
