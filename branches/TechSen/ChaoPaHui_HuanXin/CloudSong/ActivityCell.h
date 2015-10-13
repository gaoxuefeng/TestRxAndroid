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
@property (weak, nonatomic) IBOutlet UIImageView *activityBlackBG;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *cityBG;
@property (weak, nonatomic) IBOutlet UIButton *praiseBut;
@property (weak, nonatomic) IBOutlet UILabel *activityPraiseCount;
@property (weak, nonatomic) IBOutlet UILabel *activityTheme;
@property (weak, nonatomic) IBOutlet UIImageView *activityLevel;//皇冠
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *KTVName;
@property (weak, nonatomic) IBOutlet UILabel *KTVAdress;
@property (weak, nonatomic) IBOutlet UILabel *activityType;
@property (weak, nonatomic) IBOutlet UILabel *distanceBG;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *companyImage;//公司图片
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adressLayout;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (strong,nonatomic) CSActivityModel * activity;
- (IBAction)clickPraise:(id)sender;

@end
