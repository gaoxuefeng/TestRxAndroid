//
//  NBPayDishCell.h
//  NoodleBar
//
//  Created by sen on 15/4/22.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBDishModel.h"

@interface NBPayDishCell : UITableViewCell
/**
 *  数据模型
 */
@property(nonatomic, strong) NBDishModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
