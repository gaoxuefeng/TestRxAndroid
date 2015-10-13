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

@property(nonatomic, assign) BOOL hiddenDistance;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataithKTVModel:(CSKTVModel *)ktvModel;

@end
