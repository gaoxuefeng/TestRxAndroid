//
//  NBPayPromotCell.h
//  NoodleBar
//
//  Created by sen on 6/4/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBMerchantPromotModel.h"
@interface NBPayPromotCell : UITableViewCell
@property(nonatomic, strong) NBMerchantPromotModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
