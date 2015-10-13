//
//  CSDishDetailViewController.h
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
@class CSMyCostModel;

typedef void (^payDishStatusChanged)(CSMyCostDishStatusType payStatus);
@interface CSDishDetailViewController : CSBaseViewController
- (instancetype)initWithOrderId:(NSString *)orderId;
@property(nonatomic, strong) CSMyCostModel *item;
@property(copy, nonatomic) payDishStatusChanged payStatusChanged;
@end
