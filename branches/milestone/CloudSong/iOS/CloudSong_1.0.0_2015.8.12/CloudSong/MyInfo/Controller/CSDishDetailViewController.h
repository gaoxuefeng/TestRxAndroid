//
//  CSDishDetailViewController.h
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
@class CSMyCostModel;
@interface CSDishDetailViewController : CSBaseViewController
- (instancetype)initWithOrderId:(NSString *)orderId;
@property(nonatomic, strong) CSMyCostModel *item;
@end
