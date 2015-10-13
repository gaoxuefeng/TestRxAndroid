//
//  CSSingersClassifiedTableViewController.h
//  CloudSong
//
//  Created by youmingtaizi on 6/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@interface CSSingersClassifiedTableViewController : CSBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)NSInteger  type;
@property (nonatomic, strong)UITableView * tableView;
@end
