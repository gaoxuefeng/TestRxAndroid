//
//  CSLoginViewController.h
//  CloudSong
//
//  Created by Ronnie on 15/5/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
typedef void (^LoginBlock)(BOOL loginSuccess);
@interface CSLoginViewController : CSBaseViewController
/** 登录成功后执行的block */
@property (nonatomic, copy) LoginBlock loginBlock;
@end
