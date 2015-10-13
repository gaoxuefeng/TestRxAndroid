//
//  CSRoomStateTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/7/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSChatMessageModel;
@interface CSRoomStateTableViewCell : UITableViewCell
@property(nonatomic, strong) CSChatMessageModel *item;
@property(nonatomic, assign) BOOL hiddenLine;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
