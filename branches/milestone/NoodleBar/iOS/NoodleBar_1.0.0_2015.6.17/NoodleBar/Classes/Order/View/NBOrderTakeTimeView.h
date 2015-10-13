//
//  NBOrderTakeTimeView.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//  取餐时间

#import <UIKit/UIKit.h>
#import "NBCommon.h"
@interface NBOrderTakeTimeView : UIView
@property(nonatomic, assign) NBOrderStatusType statusType;
@property(nonatomic, copy) NSString *time;

@end
