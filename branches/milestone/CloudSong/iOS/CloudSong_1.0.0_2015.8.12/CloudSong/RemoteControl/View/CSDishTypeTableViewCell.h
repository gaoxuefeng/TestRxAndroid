//
//  CSDishTypeTableViewCell.h
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSDishTypeTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, weak) UILabel *titleLabel;
@end
