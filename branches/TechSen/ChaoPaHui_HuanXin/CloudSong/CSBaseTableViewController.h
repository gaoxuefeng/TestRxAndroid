//
//  CSBaseTableViewController.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSConfigNavigationBar.h"
@interface CSBaseTableViewController : UITableViewController<CSConfigNavigationBar>
- (void)configNavigationBar;
- (void)backBtnOnClick;
- (void)setNavigationBarBGHidden;
- (void)hiddenBackgroundImageView;
@end
