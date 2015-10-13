//
//  CSSingersTableViewController.h
//  CloudSong
//
//  Created by youmingtaizi on 6/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@interface CSSingersTableViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;


@end
