//
//  NBOrderCell.h
//  NoodleBar
//
//  Created by sen on 15/4/23.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <SWTableViewCell.h>
#import "NBOrderModel.h"
@interface NBOrderCell : UITableViewCell
/**
 *  数据模型
 */
@property(nonatomic, strong) NBOrderModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
