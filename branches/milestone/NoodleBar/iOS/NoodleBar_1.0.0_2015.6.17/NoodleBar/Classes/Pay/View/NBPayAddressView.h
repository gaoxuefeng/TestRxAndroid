//
//  NBPayAddressView.h
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBAddressModel.h"

@interface NBPayAddressView : UIView

@property(nonatomic, strong) NBAddressModel *item;

/** 桌号 */
@property(nonatomic, copy) NSString *tableCode;


- (void)addTarget:(id)target action:(SEL)action;
@end
