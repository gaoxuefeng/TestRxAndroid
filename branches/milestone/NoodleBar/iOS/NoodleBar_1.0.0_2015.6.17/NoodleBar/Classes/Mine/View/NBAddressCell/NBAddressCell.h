//
//  NBAddressCell.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "SWTableViewCell.h"
#import "NBAddressModel.h"
@interface NBAddressCell : SWTableViewCell
/**
 *  数据模型
 */
@property(nonatomic, strong) NBAddressModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
