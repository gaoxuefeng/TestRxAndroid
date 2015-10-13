//
//  CSDishDetailTableViewCell.h
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDishModel.h"
@interface CSDishDetailTableViewCell : UITableViewCell
@property(nonatomic, strong) CSDishModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
