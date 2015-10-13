//
//  NBOrderDetailViewController.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBViewController.h"
#import "NBOrderModel.h"
typedef void (^statusChangeBlock)(NBOrderStatusType status);
@interface NBOrderDetailViewController : NBViewController


- (instancetype)initWithOrderID:(NSString *)orderID;
@property(nonatomic, strong) NBOrderModel *orderModel;
@property(nonatomic, copy) statusChangeBlock statusChangeBlock;
@end
