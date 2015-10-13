//
//  NBMenuCategoryDetailCell.h
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBDishModel.h"


@interface NBMenuCategoryDetailCell : UITableViewCell
/**
 *  数据模型
 */
@property(nonatomic, strong) NBDishModel *item;
/**
 *  选择的数量
 */
@property(nonatomic, assign) int selectedAmount;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
