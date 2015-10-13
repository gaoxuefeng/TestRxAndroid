//
//  NBMerchantTableViewCell.h
//  NoodleBar
//
//  Created by sen on 6/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBMerchantModel.h"
#define LISTCELL_DEFAULT_HEIGHT 82.0
#define PROMOTVIEW_HEIGHT 38.0
@interface NBMerchantTableViewCell : UITableViewCell
@property(nonatomic, strong) NBMerchantModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
