//
//  CSRegisterViewController.h
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"

@class CSRegisterViewController;

typedef void (^FinishBlock)();

@protocol CSRegisterViewControllerDelegate <NSObject>

@optional
- (void)registerViewControllerDidClickForgetPwdButton;

@end

@interface CSRegisterViewController : CSBaseViewController
/** 点击开始后后执行的block */
@property (nonatomic, copy) FinishBlock finishBlock;
@property(weak, nonatomic) id delegate;
@end
