//
//  CSMessageMagicFaceTableViewCell.h
//  CloudSong
//
//  Created by sen on 8/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSChatMessageModel;
@interface CSMessageMagicFaceTableViewCell : UITableViewCell
@property(nonatomic, strong) CSChatMessageModel *item;
@property(nonatomic, assign) BOOL topLineHidden;
@property(nonatomic, assign) BOOL bottomLineHidden;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
