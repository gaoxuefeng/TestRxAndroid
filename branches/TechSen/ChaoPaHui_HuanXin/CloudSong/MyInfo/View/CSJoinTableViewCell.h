//
//  CSJoinTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSJoinModel.h"
@interface CSJoinTableViewCell : UITableViewCell
@property(nonatomic, weak) CSJoinModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
 