//
//  CSForgetPwdViewController.h
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
typedef void (^LoginBlock)(BOOL loginSuccess);
@interface CSForgetPwdViewController : CSBaseViewController
/** 登录成功后执行的block */
@property (nonatomic, copy) LoginBlock loginBlock;
@end
