//
//  CSSettingTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/6/13.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSettingItem.h"
@interface CSSettingTableViewCell : UITableViewCell
@property(nonatomic, strong) CSSettingItem *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, assign) BOOL bottomLineHidden;
@end
