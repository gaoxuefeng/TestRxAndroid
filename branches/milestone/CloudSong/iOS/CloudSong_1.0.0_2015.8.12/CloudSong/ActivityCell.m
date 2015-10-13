//
//  ActivityCell.m
//  CloudSong
//
//  Created by 汪辉 on 15/7/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "ActivityCell.h"
#import "CSDefine.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CSDataService.h"


@implementation ActivityCell

- (void)awakeFromNib {
    // Initialization code
    [self.companyImage.layer setCornerRadius:42/2];
    [self.companyImage.layer setMasksToBounds:YES];
    self.companyImage.layer.borderColor=[UIColor whiteColor].CGColor;
    self.companyImage.layer.borderWidth=1.0;
    self.activityImage.layer.masksToBounds=YES;
    [self arcColor];
    
    
}


-(void)setActivity:(CSActivityModel *)activity{
    _cityName.text=[NSString stringWithFormat:@"%@ ",activity.cityName];
    [_activityImage sd_setImageWithURL:[NSURL URLWithString:activity.activityImageUrl] placeholderImage:[UIImage imageNamed:@"activity_placeholder_bg"]];
    [_companyImage sd_setImageWithURL:[NSURL URLWithString:activity.companyImageUrl] placeholderImage:[UIImage imageNamed:@"activity_default-logo_bg"]];

    _activityPraiseCount.text =[NSString stringWithFormat:@"%@",activity.activityPraiseCount];
    _activityTheme.text = [NSString stringWithFormat:@"｢  %@  ｣",activity.activityTheme];
    _activityTime.text =activity.activityTime;
    
    _activity =activity;

}
#pragma make  随机城市背景色
- (void)arcColor{

    int colorValue = arc4random() % 6;
    
    switch (colorValue) {
        case 0:
            self.cityName.backgroundColor=HEX_COLOR(0xeb536d);
            break;
        case 1:
            self.cityName.backgroundColor=HEX_COLOR(0x44bb96);
            break;
        case 2:
            self.cityName.backgroundColor=HEX_COLOR(0xf0896c);
            break;
        case 3:
            self.cityName.backgroundColor=HEX_COLOR(0xaa5fe5);
            break;
        case 4:
            self.cityName.backgroundColor=HEX_COLOR(0xeab117);
            break;
        case 5:
            self.cityName.backgroundColor=HEX_COLOR(0xe835d9);
            break;
        default:
            self.cityName.backgroundColor=HEX_COLOR(0x2bd7e2);
            break;
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickPraise:(id)sender {
    
    self.praiseButton.selected= _praiseButton.selected ? NO :YES;
    
    NSArray * activityId =[[NSUserDefaults standardUserDefaults]objectForKey:@"activityId"];
    NSMutableArray * temp = [NSMutableArray arrayWithArray:activityId];
    
    if (_praiseButton.selected==NO) {
        [temp removeObject:_activity.activityId];
        _activityPraiseCount.text = [NSString stringWithFormat:@"%d",[_activityPraiseCount.text intValue]-1];
        [[CSDataService sharedInstance]asyncGetActivityClickPraiseByActivityId:_activity.activityId Type:@1 handler:^(BOOL success) {
            if (success) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:temp] forKey:@"activityId"];
            }
        }];
    }else{
        [temp addObject:_activity.activityId];
        _activityPraiseCount.text = [NSString stringWithFormat:@"%d",[_activityPraiseCount.text intValue]+1];
        [[CSDataService sharedInstance]asyncGetActivityClickPraiseByActivityId:_activity.activityId Type:@0 handler:^(BOOL success) {
            if (success) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:temp] forKey:@"activityId"];
            }
        }];
    }
    
}

@end
