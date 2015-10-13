//
//  YSBeaconTableViewCell.h
//  YSBeaconDemo
//
//  Created by sen on 8/13/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@interface YSBeaconTableViewCell : UITableViewCell

@property(strong, nonatomic) CLBeacon *beacon;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
