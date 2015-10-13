//
//  NBOrderDetailResponseDataModel.h
//  NoodleBar
//
//  Created by sen on 15/4/30.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBOrderModel.h"
#import "NBAddressModel.h"
#import "NBDishModel.h"
@interface NBOrderDetailResponseDataModel : NSObject
@property(nonatomic, strong) NBOrderModel *order;
@property(nonatomic, strong) NSMutableArray *orderDetails;
@property(nonatomic, strong) NBAddressModel *address;
@property(nonatomic, assign) int intervaltime;
@end
