//
//  NBOrderInfomationView.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBOrderModel.h"
@interface NBOrderInfomationView : UIView

@property(nonatomic, strong) NBOrderModel *item;

@property(nonatomic, assign) CGFloat selfHeight;
@end
