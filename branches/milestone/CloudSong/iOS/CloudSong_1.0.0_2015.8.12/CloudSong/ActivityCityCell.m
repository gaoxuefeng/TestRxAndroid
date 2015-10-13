//
//  ActivityCityCell.m
//  CloudSong
//
//  Created by 汪辉 on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "ActivityCityCell.h"

#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ActivityCityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self UI];
    }
    return self;
}

- (void)UI
{
    self.cityBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _cityBGView.backgroundColor = HEX_COLOR(0x372e57);
    [self.contentView addSubview:_cityBGView];
    
    self.cityName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _cityName.textColor =[UIColor whiteColor];
    _cityName.textAlignment = NSTextAlignmentCenter;
    _cityName.font =[UIFont systemFontOfSize:11.0];
    [self.contentView addSubview:_cityName];
    
}
@end
