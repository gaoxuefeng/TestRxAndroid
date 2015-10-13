//
//  NBOrderTakeCodeView.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCommon.h"
@interface NBOrderTakeCodeView : UIView
@property(nonatomic, assign) NBOrderStatusType statusType;
@property(nonatomic, copy) NSString *takeCode;
@end
