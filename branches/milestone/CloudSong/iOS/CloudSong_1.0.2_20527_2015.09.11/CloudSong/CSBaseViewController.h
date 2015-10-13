//
//  CSBaseViewController.h
//  CloudSong
//
//  Created by youmingtaizi on 5/20/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDefine.h"
#import "CSConfigNavigationBar.h"
#import <Masonry.h>

@interface CSBaseViewController : UIViewController<CSConfigNavigationBar>
@property (nonatomic, assign)BOOL isNetWorking;

- (void)configUI;
- (void)configNavigationBar;
- (void)backBtnOnClick;
- (void)setNavigationBarBGHidden;
- (void)networkReachability;
- (void)hiddenBackgroundImageView;

- (void)notShowNoNetworking;
@end
