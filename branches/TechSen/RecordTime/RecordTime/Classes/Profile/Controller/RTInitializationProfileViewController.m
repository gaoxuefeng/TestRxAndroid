//
//  RTInitializationProfileViewController.m
//  RecordTime
//
//  Created by sen on 8/31/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTInitializationProfileViewController.h"
#import "RTTimePickerView.h"
#import "RTBindingBeaconViewController.h"
#import "RTMonitoringMethodSelectViewController.h"
@interface RTInitializationProfileViewController () <RTTimePickerViewDelegate>
@property(weak, nonatomic) RTTimePickerView *timePickerView;
@property(weak, nonatomic) UIButton *pressedButton;
@end


@implementation RTInitializationProfileViewController

#pragma mark - Lazy Load

- (RTTimePickerView *)timePickerView
{
    if (!_timePickerView) {
        RTTimePickerView *timePickerView = [[RTTimePickerView alloc] init];
        timePickerView.delegate = self;
        [self.view addSubview:timePickerView];
        [timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(timePickerView.superview);
        }];
        _timePickerView = timePickerView;
    }
    return _timePickerView;
}


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BG_COLOR;
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - Setup
- (void)setupSubviews
{
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"请根据实际情况设置规定的上下班时间";
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hintLabel.superview);
        make.top.equalTo(hintLabel.superview).offset(50.0);
    }];
    
    CGFloat containerRadius = 5.0;
    UIView *arriveContainer = [[UIView alloc] init];
    arriveContainer.layer.cornerRadius = containerRadius;
    arriveContainer.layer.masksToBounds = YES;
    arriveContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:arriveContainer];
    
    UIView *leftContainer = [[UIView alloc] init];
    leftContainer.layer.cornerRadius = containerRadius;
    leftContainer.layer.masksToBounds = YES;
    leftContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftContainer];
    
    UILabel *arriveCompanyTimeLabel = [[UILabel alloc] init];
    arriveCompanyTimeLabel.text = @"上班时间:";
    arriveCompanyTimeLabel.textColor = [UIColor grayColor];
    [arriveContainer addSubview:arriveCompanyTimeLabel];
    
    CGFloat left_padding = 30.0;
    [arriveCompanyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(arriveCompanyTimeLabel.superview).offset(left_padding);
        make.centerY.equalTo(arriveCompanyTimeLabel.superview);
        
    }];
    
    CGFloat buttonCornerRadius = 3.0;
    UIButton *arriveCompanyTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arriveCompanyTimeButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    arriveCompanyTimeButton.layer.borderColor = [UIColor grayColor].CGColor;
    arriveCompanyTimeButton.layer.cornerRadius = buttonCornerRadius;
    arriveCompanyTimeButton.layer.masksToBounds = YES;
    [arriveCompanyTimeButton addTarget:self action:@selector(showTimePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [arriveCompanyTimeButton setTitle:@"点击选择" forState:UIControlStateNormal];
    arriveCompanyTimeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [arriveCompanyTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    arriveCompanyTimeButton.backgroundColor = MAIN_BG_COLOR;
    
    [arriveContainer addSubview:arriveCompanyTimeButton];
    [arriveCompanyTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arriveCompanyTimeButton.superview).offset(-50.0);
        make.centerY.equalTo(arriveCompanyTimeLabel);
        make.width.mas_equalTo(100.0);
        make.height.mas_equalTo(28.0);
    }];
    
    CGFloat containerXPadding = 15.0;
    [arriveContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(arriveContainer.superview).offset(containerXPadding);
        make.right.equalTo(arriveContainer.superview).offset(-containerXPadding);
        make.height.mas_equalTo(50.0);
        make.top.equalTo(hintLabel.mas_bottom).offset(40.0);
    }];
    
    UILabel *leftCompanyTimeLabel = [[UILabel alloc] init];
    leftCompanyTimeLabel.text = @"下班时间:";
    leftCompanyTimeLabel.textColor = [UIColor grayColor];
    
    [leftContainer addSubview:leftCompanyTimeLabel];
    [leftCompanyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftCompanyTimeLabel.superview).offset(left_padding);
        make.centerY.equalTo(leftCompanyTimeLabel.superview);
    }];
    
    UIButton *leftCompanyTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftCompanyTimeButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    leftCompanyTimeButton.layer.borderColor = [UIColor grayColor].CGColor;
    leftCompanyTimeButton.layer.cornerRadius = buttonCornerRadius;
    leftCompanyTimeButton.layer.masksToBounds = YES;
    [leftCompanyTimeButton addTarget:self action:@selector(showTimePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [leftCompanyTimeButton setTitle:@"点击选择" forState:UIControlStateNormal];
    leftCompanyTimeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [leftCompanyTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    leftCompanyTimeButton.backgroundColor = MAIN_BG_COLOR;
    
    [leftContainer addSubview:leftCompanyTimeButton];
    [leftCompanyTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftCompanyTimeButton.superview).offset(-50.0);
        make.centerY.equalTo(leftCompanyTimeLabel);
        make.width.mas_equalTo(100.0);
        make.height.mas_equalTo(28.0);
    }];
    
    [leftContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftContainer.superview).offset(containerXPadding);
        make.right.equalTo(leftContainer.superview).offset(-containerXPadding);
        make.height.mas_equalTo(50.0);
        make.top.equalTo(arriveContainer.mas_bottom).offset(30.0);
    }];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
    nextButton.backgroundColor = [UIColor whiteColor];
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat nextButtonRadius = 50.0;
    nextButton.layer.cornerRadius = nextButtonRadius;
    nextButton.layer.masksToBounds = YES;
    [self.view addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nextButton.superview).offset(-80.0);
        make.centerX.equalTo(nextButton.superview);
        make.size.mas_equalTo(CGSizeMake(nextButtonRadius * 2, nextButtonRadius * 2));
    }];
    
    
//    UIButton *setBeaconButton = [[UIButton alloc] init];
//    [setBeaconButton addTarget:self action:@selector(beaconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    setBeaconButton.layer.cornerRadius = 5.0;
//    setBeaconButton.layer.masksToBounds = YES;
//    [self.view addSubview:setBeaconButton];
//    [setBeaconButton setTitle:@"设置Beacon" forState:UIControlStateNormal];
//    setBeaconButton.backgroundColor = [UIColor grayColor];
//    [setBeaconButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(leftCompanyTimeLabel.mas_bottom).offset(150.0);
//        make.size.mas_equalTo(CGSizeMake(150.0, 30.0));
//    }];
}

#pragma mark Action
- (void)nextButtonPressed
{
    RTMonitoringMethodSelectViewController *monitoringMethodSelectedVc = [[RTMonitoringMethodSelectViewController alloc] init];
    [self.navigationController pushViewController:monitoringMethodSelectedVc animated:YES];
}


- (void)showTimePickerView:(UIButton *)button
{
    _pressedButton = button;
    [self.timePickerView show];
}

- (void)beaconButtonPressed:(UIButton *)button
{
    [self presentViewController:[[RTBindingBeaconViewController alloc] init] animated:YES completion:nil];
}

#pragma mark - RTTimePickerViewDelegate
- (void)timePickerDidGetDate:(NSDate *)date
{
    RTTime *time = [RTDateTool timeFromDate:date];
    [_pressedButton setTitle:[NSString stringWithFormat:@"%ld:%ld",time.hour,time.minute] forState:UIControlStateNormal];
    
}
@end
