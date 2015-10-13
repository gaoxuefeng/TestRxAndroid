//
//  NBAddressViewController.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBViewController.h"
typedef enum{
    NBAddressViewControllerTypeMine,  // 用户查看编辑
    NBAddressViewControllerTypePay // 用于下单支付
    
}NBAddressViewControllerType;
@interface NBAddressViewController : NBViewController

- (instancetype)initWithType:(NBAddressViewControllerType) type;
@end
