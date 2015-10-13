//
//  CSEditUserInfoViewController.h
//  CloudSong
//
//  Created by sen on 15/6/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
typedef void (^StartBlock)();
typedef enum
{
    CSEditUserInfoViewControllerTypeEdit,   // 编辑
    CSEditUserInfoViewControllerTypeConfirm // 确认
}CSEditUserInfoViewControllerType;
@interface CSEditUserInfoViewController : CSBaseViewController
- (instancetype)initWithType:(CSEditUserInfoViewControllerType)type;
/** 点击开始后后执行的block */
@property (nonatomic, copy) StartBlock startBlock;
@end
