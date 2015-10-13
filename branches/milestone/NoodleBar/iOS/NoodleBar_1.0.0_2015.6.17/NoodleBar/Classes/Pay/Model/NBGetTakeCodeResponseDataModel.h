//
//  NBGetTakeCodeResponseDataModel.h
//  NoodleBar
//
//  Created by sen on 15/5/11.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBOrderModel.h"
@interface NBGetTakeCodeResponseDataModel : NSObject
@property(nonatomic, strong) NBOrderModel *order;
@end
