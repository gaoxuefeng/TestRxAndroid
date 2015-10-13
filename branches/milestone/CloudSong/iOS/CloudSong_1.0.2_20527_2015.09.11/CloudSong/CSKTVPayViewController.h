//
//  CSKTVPayViewController.h
//  CloudSong
//
//  Created by youmingtaizi on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBaseViewController.h"



@class CSKTVBookingOrder;

@interface CSKTVPayViewController : CSBaseViewController
@property (nonatomic, strong) CSKTVBookingOrder *order;
/** 是否是订单详情发起的付款 */
@property(nonatomic, assign,getter=isRepay) BOOL repay;
@end
