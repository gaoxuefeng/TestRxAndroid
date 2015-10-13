//
//  CSMessageTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/7/23.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSChatMessageModel;
@interface CSMessageTableViewCell : UITableViewCell
@property(nonatomic, strong) CSChatMessageModel *item;
@property(nonatomic, assign) BOOL topLineHidden;
@property(nonatomic, assign) BOOL bottomLineHidden;
//- (void)hiddenBottomLine;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
