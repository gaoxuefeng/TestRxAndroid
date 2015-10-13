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
//    [self.companyImage.layer setCornerRadius:42/2];
//    [self.companyImage.layer setMasksToBounds:YES];
//    self.companyImage.layer.borderColor=[UIColor whiteColor].CGColor;
//    self.companyImage.layer.borderWidth=1.0;
    self.activityImage.layer.masksToBounds=YES;
    self.activityImage.layer.cornerRadius = 5;
    self.activityBlackBG.layer.masksToBounds=YES;
    self.activityBlackBG.layer.cornerRadius = 5;
    self.cityBG.layer.masksToBounds=YES;
    self.cityBG.layer.cornerRadius = 4;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_typeImage.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _typeImage.bounds;
    maskLayer.path = maskPath.CGPath;
    _typeImage.layer.mask = maskLayer;
    
    self.distance.layer.masksToBounds = YES;
    self.distance.layer.cornerRadius = 2;
    

    self.layer.masksToBounds = YES;
    
//    [self arcColor];
//    self.activityType.transform =CGAffineTransformMakeRotation(-M_PI/4);
    
}

-(void)setActivity:(CSActivityModel *)activity{
    [_activityImage sd_setImageWithURL:[NSURL URLWithString:activity.activityImageUrl] placeholderImage:[UIImage imageNamed:@"activity_placeholder_bg"]];
    [_companyImage sd_setImageWithURL:[NSURL URLWithString:activity.companyImageUrl] placeholderImage:[UIImage imageNamed:@"activity_default-logo_bg"]];

    _activityPraiseCount.text =[NSString stringWithFormat:@"%@",activity.activityPraiseCount];
    _activityTheme.text = [NSString stringWithFormat:@"%@",activity.activityTheme];
    _activityTime.text =activity.activityTime;
    _KTVAdress.text =activity.address;
    
    if ([activity.distance intValue] > 0 && [GlobalObj.locationCity isEqualToString:activity.cityName]) {
        _adressLayout.constant=5;
        _distance.text = [activity.distance intValue]<1000 ? [NSString stringWithFormat:@"%@m",activity.distance] : [NSString stringWithFormat:@" %.1fkm ",[activity.distance floatValue]/1000];
        _cityName.text=[NSString stringWithFormat:@"附近 · %@",activity.activityTag];

    }else{
        _adressLayout.constant=0;
        _distance.text=@"";
        _cityName.text=[NSString stringWithFormat:@"%@ · %@",activity.cityName,activity.activityTag];
    }
    _KTVName.text =activity.kTVName;
    [_activityLevel sd_setImageWithURL:[NSURL URLWithString:activity.activityIcon]];
    [_typeImage sd_setImageWithURL:[NSURL URLWithString:activity.typeImageUrl]];
    self.cityBG.backgroundColor = activity.colorCode ? [[self printColor:activity.colorCode]colorWithAlphaComponent:.8] : [HEX_COLOR(0xeb536d)colorWithAlphaComponent:.8];
    _activity = activity;

}


#pragma make  随机城市背景色
- (void)arcColor{
    
    int colorValue = arc4random() % 6;
    
    switch (colorValue) {
        case 0:
            self.cityBG.backgroundColor=HEX_COLOR(0xeb536d);
            break;
        case 1:
            self.cityBG.backgroundColor=HEX_COLOR(0x44bb96);
            break;
        case 2:
            self.cityBG.backgroundColor=HEX_COLOR(0xf0896c);
            break;
        case 3:
            self.cityBG.backgroundColor=HEX_COLOR(0xaa5fe5);
            break;
        case 4:
            self.cityBG.backgroundColor=HEX_COLOR(0xeab117);
            break;
        case 5:
            self.cityBG.backgroundColor=HEX_COLOR(0xe835d9);
            break;
        default:
            self.cityBG.backgroundColor=HEX_COLOR(0x2bd7e2);
            break;
    }


}

- (UIColor*)printColor:(NSString *)str
{
    int red = (int)strtoul([[str substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
    int green = (int)strtoul([[str substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
    int blue = (int)strtoul([[str substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
    UIColor* hexColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return hexColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickPraise:(id)sender {
    
    NSArray * activityId =[[NSUserDefaults standardUserDefaults]objectForKey:@"activityId"];
    NSMutableArray * temp = [NSMutableArray arrayWithArray:activityId];
    
    if ([temp containsObject:_activity.activityId]) {
        [temp removeObject:_activity.activityId];
        [[CSDataService sharedInstance]asyncGetActivityClickPraiseByActivityId:_activity.activityId Type:@1 handler:^(BOOL success) {
            if (success) {
                self.praiseButton.selected= NO;
                _activityPraiseCount.text = [NSString stringWithFormat:@"%d",[_activityPraiseCount.text intValue]-1];
                [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:temp] forKey:@"activityId"];
            }
        }];
    }else{
        [temp addObject:_activity.activityId];
        [[CSDataService sharedInstance]asyncGetActivityClickPraiseByActivityId:_activity.activityId Type:@0 handler:^(BOOL success) {
            if (success) {
                self.praiseButton.selected= YES ;
                _activityPraiseCount.text = [NSString stringWithFormat:@"%d",[_activityPraiseCount.text intValue]+1];
                [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:temp] forKey:@"activityId"];
            }
        }];
    }
    
}

@end
