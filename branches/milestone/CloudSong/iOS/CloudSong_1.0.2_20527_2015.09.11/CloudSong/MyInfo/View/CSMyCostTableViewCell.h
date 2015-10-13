//
//  CSMyCostTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/6/16.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMyCostModel.h"
@interface CSMyCostTableViewCell : UITableViewCell
@property(nonatomic, weak) CSMyCostModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
