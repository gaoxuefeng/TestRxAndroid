//
//  CSMyCostDishTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMyCostModel.h"
@interface CSMyCostDishTableViewCell : UITableViewCell
@property(nonatomic, weak) CSMyCostModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
