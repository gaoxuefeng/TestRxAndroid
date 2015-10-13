//
//  CSInRoomStatusTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/6/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSInRoomUserModel.h"
@interface CSInRoomStatusTableViewCell : UITableViewCell
@property(nonatomic, weak) CSInRoomUserModel *item;
@property(nonatomic, weak) UIColor *circleColor;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, assign,getter=isHiddenVline) BOOL hiddenVLine;
@end
