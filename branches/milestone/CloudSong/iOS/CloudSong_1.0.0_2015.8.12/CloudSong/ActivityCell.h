//
//  ActivityCell.h
//  CloudSong
//
//  Created by 汪辉 on 15/7/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSActivityModel.h"

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *activityPraiseCount;
@property (weak, nonatomic) IBOutlet UILabel *activityTheme;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UIImageView *companyImage;//公司图片
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (strong,nonatomic) CSActivityModel * activity;
- (IBAction)clickPraise:(id)sender;

@end
