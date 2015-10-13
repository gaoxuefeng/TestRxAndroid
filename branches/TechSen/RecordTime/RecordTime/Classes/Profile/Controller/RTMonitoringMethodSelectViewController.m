//
//  RTMonitoringMethodSelectViewController.m
//  RecordTime
//
//  Created by sen on 9/8/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTMonitoringMethodSelectViewController.h"
#import "RTBindingBeaconViewController.h"
@implementation RTMonitoringMethodSelectViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BG_COLOR;
    [self setupSubviews];
    
}

#pragma mark - Setup
- (void)setupSubviews
{
    
    CGFloat cornerRadius = 5.0;
    UIButton *beaconButton = [UIButton buttonWithType:UIButtonTypeSystem];
    beaconButton.layer.cornerRadius = cornerRadius;
    beaconButton.layer.masksToBounds = YES;
    [beaconButton addTarget:self action:@selector(beaconButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [beaconButton setTitle:@"通过beacon标记" forState:UIControlStateNormal];
    [beaconButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    beaconButton.titleLabel.font  = [UIFont systemFontOfSize:18.0];
    beaconButton.backgroundColor = [UIColor whiteColor];
        
    [self.view addSubview:beaconButton];
    
    UIButton *geographicalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    geographicalButton.layer.cornerRadius = cornerRadius;
    geographicalButton.layer.masksToBounds = YES;
    [geographicalButton setTitle:@"通过地理位置标记" forState:UIControlStateNormal];
    [geographicalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    geographicalButton.titleLabel.font  = [UIFont systemFontOfSize:18.0];
    geographicalButton.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:geographicalButton];
    
    CGFloat buttonXPadding = 15.0;
    
    [beaconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beaconButton.superview).offset(buttonXPadding);
        make.right.equalTo(beaconButton.superview).offset(-buttonXPadding);
        make.height.mas_equalTo(40.0);
        make.top.equalTo(beaconButton.superview).offset(100.0);
    }];
    
    [geographicalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(geographicalButton.superview).offset(buttonXPadding);
        make.right.equalTo(geographicalButton.superview).offset(-buttonXPadding);
        make.height.mas_equalTo(40.0);
        make.top.equalTo(beaconButton.mas_bottom).offset(50.0);
    }];
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = [UIFont systemFontOfSize:13.0];
    hintLabel.numberOfLines = 0;
    hintLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40.0;
    hintLabel.text = @"如果您有beacon设备,强烈推荐使用beacon进行标识位置,因为它具有更高的精度,能使测量数据更精确。";
    [self.view addSubview:hintLabel];
    
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(hintLabel.superview).offset(-50.0);
        make.centerX.equalTo(hintLabel.superview);
    }];
}

#pragma mark - Action  Methods
- (void)beaconButtonPressed
{
    [self.navigationController pushViewController:[[RTBindingBeaconViewController alloc] init] animated:YES];
}
@end
