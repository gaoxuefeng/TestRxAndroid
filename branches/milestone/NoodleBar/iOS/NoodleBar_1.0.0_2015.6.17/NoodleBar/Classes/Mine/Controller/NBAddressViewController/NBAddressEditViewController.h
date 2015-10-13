//
//  NBAddressEditViewController.h
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBViewController.h"
#import "NBAddressModel.h"
typedef enum{
    NBAddressEditViewControllerTypeEdit,  // 编辑  默认
    NBAddressEditViewControllerTypeAdd // 增加
    
}NBAddressEditViewControllerType;

@interface NBAddressEditViewController : NBViewController

@property(nonatomic, strong) NBAddressModel *item;

- (instancetype)initWithType:(NBAddressEditViewControllerType)type;
@end
