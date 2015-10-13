//
//  CSCategoryTableViewCell.h
//  CloudSong
//
//  Created by 汪辉 on 15/8/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSongCategoryItem.h"

@interface CSCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *song1;
@property (weak, nonatomic) IBOutlet UILabel *song2;
@property (weak, nonatomic) IBOutlet UILabel *song3;
@property (strong,nonatomic) CSSongCategoryItem * category;

@end
