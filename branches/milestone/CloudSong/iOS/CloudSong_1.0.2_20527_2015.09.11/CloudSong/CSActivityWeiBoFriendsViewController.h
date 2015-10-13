//
//  CSActivityWeiBoFriendsViewController.h
//  CloudSong
//
//  Created by 汪辉 on 15/8/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"
typedef void(^AtBlock)(NSString *);
@interface CSActivityWeiBoFriendsViewController : CSBaseViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (copy, nonatomic) AtBlock atBlock;
@end
