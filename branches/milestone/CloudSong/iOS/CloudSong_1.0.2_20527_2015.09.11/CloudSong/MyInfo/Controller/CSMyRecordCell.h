//
//  CSMyRecordCell.h
//  CloudSong
//
//  Created by EThank on 15/7/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSMyRecordModel   ;
@class CSMyRecordCell ;

@protocol MyRecordCellDelegate <NSObject>

@optional
- (void)myRecordCell:(CSMyRecordCell *)myRecordcell didSelectShareBtnIndex:(NSInteger)index ;

@end
@interface CSMyRecordCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView ;

@property (nonatomic, strong) CSMyRecordModel *recordModel ;
@property (nonatomic, weak) id <MyRecordCellDelegate> delegate ;
@end
