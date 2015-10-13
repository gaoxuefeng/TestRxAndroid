//
//  NBViewController.h
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCommon.h"
@interface NBViewController : UIViewController
/** 显示网络不稳定视图 */
- (void)showNetInstabilityView;
/** 隐藏网络不稳定视图 */
- (void)dismissNetInstabilityView;
/** 加载数据 */
- (void)loadData;
/** 配置导航栏 */
- (void)configNavigationBar;
@end
