//
//  RTBindingBeaconViewController.m
//  RecordTime
//
//  Created by sen on 9/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTBindingBeaconViewController.h"
#import "RTBeaconTool.h"
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import "RTCompanyViewController.h"
#import <RESideMenu.h>
#import "RTLeftMenuViewController.h"
#import "RTNavigationController.h"

@import CoreLocation;

@interface RTBindingBeaconViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>
@property(strong, nonatomic) CLLocationManager *locationMgr;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) UIImageView *radarView;
@end


@implementation RTBindingBeaconViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.delegate = self;
    self.view.backgroundColor = MAIN_BG_COLOR;
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTimer];
    [self addRotateAnimation];
    [self startAllSupportBeacons];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
    self.locationMgr.delegate = nil;
}

#pragma mark - Setup
- (void)setupSubviews
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    closeButton.layer.cornerRadius = 24.0;
    closeButton.layer.masksToBounds = YES;
    closeButton.backgroundColor = [UIColor whiteColor];
    [closeButton setTitle:@"返回" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeButton.superview).offset(AUTOLENGTH(30.0));
        make.left.equalTo(closeButton.superview).offset(AUTOLENGTH(15.0));
        make.size.mas_equalTo(CGSizeMake(48.0, 48.0));
    }];
    
    UIImageView *radarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radar_Scan_light"]];
    [self.view addSubview:radarView];
    [radarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(radarView.superview);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - AUTOLENGTH(50.0), SCREEN_WIDTH - AUTOLENGTH(50.0)));
    }];
    _radarView = radarView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"正在搜索附近的beacon设备";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel.superview);
        make.top.equalTo(titleLabel.superview).offset(AUTOLENGTH(80.0));
    }];
}

#pragma mark - Private Methods
- (void)startAllSupportBeacons
{
    [self stopAllSupportBeacons];
    NSArray *supportBeacons = [RTBeaconTool loadSupportBeaconItems];
    for (CLBeaconRegion *beaconRegion in supportBeacons) {
        [self startMonitoringBeacon:beaconRegion];
    }
}

- (void)stopAllSupportBeacons
{
    NSArray *supportBeacons = [RTBeaconTool loadSupportBeaconItems];
    for (CLBeaconRegion *beaconRegion in supportBeacons) {
        [self stopMonitoringBeacon:beaconRegion];
    }
}

- (void)startMonitoringBeacon:(CLBeaconRegion *)beaconRegion {
    [self.locationMgr startMonitoringForRegion:beaconRegion];
    [self.locationMgr startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringBeacon:(CLBeaconRegion *)beaconRegion {
    [self.locationMgr stopMonitoringForRegion:beaconRegion];
    [self.locationMgr stopRangingBeaconsInRegion:beaconRegion];
}

- (void)addRotateAnimation
{
    CABasicAnimation *rotateAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnima.toValue = @(M_PI * 100);
    rotateAnima.duration = 2 * 100;
    rotateAnima.removedOnCompletion = NO;
    rotateAnima.fillMode = kCAFillModeForwards;
    rotateAnima.delegate = self;
    [_radarView.layer addAnimation:rotateAnima forKey:@"animation"];
}

- (void)removeRotateAnimation
{
    [_radarView.layer removeAnimationForKey:@"animation"];
}


- (void)timeout
{
    [self removeTimer];
    [self removeRotateAnimation];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未检测beacon设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alertView show];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    RTLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    RTLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count == 0) return;
    
    // 采集附近的beacon
    NSMutableArray *nearlyBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
    for (CLBeacon *beaconRegion in beacons) {
        if (beaconRegion.proximity == CLProximityImmediate) {
            [nearlyBeacons addObject:beaconRegion];
        }
    }
    
    // 如果靠近的beacon为空,则继续搜索
    if (nearlyBeacons.count == 0) {
        return;
    }
    
    // 如果靠近的beacon个数>1,则弹窗提示
    if (nearlyBeacons.count > 1) {
        [self removeTimer];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"检测到有多个beacon靠近设备,请保证有且仅有一个" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试",nil];
        [self removeRotateAnimation];
        [alertView show];
        return;
    }
    
    // 如果靠近的beacon个数为1,则直接绑定
    if (nearlyBeacons.count == 1) {
        CLBeacon *beacon = nearlyBeacons.lastObject;
        CLBeaconRegion *beaconRegin = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.proximityUUID major:beacon.major.intValue minor:beacon.minor.intValue identifier:beacon.proximityUUID.UUIDString];
        [RTBeaconTool setCompanyBeacon:beaconRegin];
        [self stopAllSupportBeacons];
        [self startMonitoringBeacon:beaconRegin];
        
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closeBtnPressed];
        });
    }
}


#pragma mark - Timer
- (void)addTimer
{
    if (!_timer) {
        CGFloat duration = 20.0;
        _timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(timeout) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}


- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [self addTimer];
    [self addRotateAnimation];
}


#pragma mark - Aciton Methods
- (void)closeBtnPressed
{
    [self removeTimer];
    [self removeRotateAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
