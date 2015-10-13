//
//  CSMyRoomTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/6/17.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMyRoomModel.h"
@class CSMyRoomTableViewCell;
@protocol CSMyRoomTableViewCellDelegate <NSObject>
@optional
- (void)myRoomTableViewCellJoinCountBtnOnClick:(CSMyRoomTableViewCell *)myRoomTableViewCell;
- (void)myRoomTableViewCellAddressBtnOnClick:(CSMyRoomTableViewCell *)myRoomTableViewCell;
@end


@interface CSMyRoomTableViewCell : UITableViewCell
@property(nonatomic, weak) CSMyRoomModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, weak) id<CSMyRoomTableViewCellDelegate> delegate;
@end
