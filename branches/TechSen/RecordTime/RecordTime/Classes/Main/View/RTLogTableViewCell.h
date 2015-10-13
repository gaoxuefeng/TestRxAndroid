//
//  RTLogTableViewCell.h
//  RecordTime
//
//  Created by sen on 9/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTDatePointModel;
@interface RTLogTableViewCell : UITableViewCell

@property(strong, nonatomic) RTDatePointModel *items;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
