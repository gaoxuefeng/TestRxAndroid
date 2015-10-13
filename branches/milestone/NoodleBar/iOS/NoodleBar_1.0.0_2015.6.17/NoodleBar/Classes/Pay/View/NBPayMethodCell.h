//
//  NBPayMethodCell.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCommon.h"

@interface NBPayMethodCell : UIButton
@property(nonatomic, assign, readonly) NBPayMethodType payType;
- (instancetype)initWithPayType:(NBPayMethodType)payType;



@end
