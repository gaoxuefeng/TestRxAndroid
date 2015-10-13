//
//  NBCartListCell.h
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMenuCategoryDetailCell.h"

@interface NBCartListCell : UITableViewCell
/**
 *  数据模型
 */
@property(nonatomic, strong) NBDishModel *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 *  是否隐藏底部分割线
 */
- (void)hiddenBottomDivider:(BOOL)hidden;
@end
