//
//  CSSingHistoryTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSong.h"
@interface CSSingHistoryTableViewCell : UITableViewCell
@property(nonatomic, weak) CSSong *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
