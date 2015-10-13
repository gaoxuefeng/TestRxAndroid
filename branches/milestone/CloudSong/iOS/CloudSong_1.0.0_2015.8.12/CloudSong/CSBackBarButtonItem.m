//
//  CSBackBarButtonItem.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBackBarButtonItem.h"
#import "CSDefine.h"



@implementation CSBackBarButtonItem

+ (instancetype)backBarButtonItemWithTitle:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(14.0)];
    [backButton setTitleColor:HEX_COLOR(0xcd418f) forState:UIControlStateNormal];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton sizeToFit];
    CSBackBarButtonItem *barButtonItem = [[CSBackBarButtonItem alloc] initWithCustomView:backButton];
    
    return barButtonItem;
}

- (void)addTarget:(id)target action:(SEL)action
{
    UIButton *backButton = (UIButton *)self.customView;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
