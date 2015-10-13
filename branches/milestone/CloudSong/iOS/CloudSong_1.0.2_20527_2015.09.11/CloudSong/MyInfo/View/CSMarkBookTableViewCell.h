//
//  CSMarkBookTableViewCell.h
//  CloudSong
//
//  Created by sen on 15/7/31.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSMarkBookModel;
@interface CSMarkBookTableViewCell : UITableViewCell
@property(nonatomic, strong) CSMarkBookModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
