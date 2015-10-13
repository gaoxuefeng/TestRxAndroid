//
//  CSKTVBookingCell.h
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseTableViewCell.h"

@class CSKTVModel;

@interface CSKTVBookingCell : CSBaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, assign) BOOL hiddenDistance;
- (void)setDataithKTVModel:(CSKTVModel *)ktvModel;
@end
