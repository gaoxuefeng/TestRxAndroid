//
//  NBCitySelectorViewController.m
//  NoodleBar
//
//  Created by sen on 6/8/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBCitySelectorViewController.h"
#define COL_COUNT 3
#define V_PADDING 10.0
#define H_PADDING 12.0
@interface NBCitySelectorViewController ()
@property(nonatomic, strong) NSArray *cityNames;
@end

@implementation NBCitySelectorViewController
#pragma mark - Lazy Load
- (NSArray *)cityNames
{
    if (!_cityNames) {
        _cityNames = @[@"北京",@"广州",@"深圳",@"成都",@"重庆",@"天津",@"杭州",@"南京",@"上海",@"苏州",@"武汉",@"青岛"];
    }
    return _cityNames;
    
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市选择";
    self.view.backgroundColor = HEX_COLOR(0xeeeeee);
    [self setupSubViews];
}
#pragma mark - Setup
- (void)setupSubViews
{
    [self setupHotCityTitle];
    [self setupCityButtons];
    
    }

- (void)setupHotCityTitle
{
    UILabel *hotCityLabel = [[UILabel alloc] init];
    hotCityLabel.text = @"热门城市";
    hotCityLabel.textColor = HEX_COLOR(0xabacb2);
    if (iPhone6Plus) {
        hotCityLabel.font = [UIFont systemFontOfSize:15.0];
    }else
    {
        hotCityLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    [self.view addSubview:hotCityLabel];
    [hotCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12.0);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(36.0);
    }];
}

- (void)setupCityButtons
{
    CGFloat cityButtonW = (SCREEN_WIDTH - H_PADDING * (COL_COUNT + 1)) / COL_COUNT;
    CGFloat cityButtonH = 31.0;
    for (int i = 0; i < self.cityNames.count; i++) {
        int row = i / COL_COUNT; // 行号
        int col = i % COL_COUNT; // 列号
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cityButton addTarget:self action:@selector(cityBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        cityButton.layer.borderColor = HEX_COLOR(0xdbdbdb).CGColor;
        cityButton.layer.borderWidth = 0.5;
        cityButton.backgroundColor = [UIColor whiteColor];
        [cityButton setTitle:self.cityNames[i] forState:UIControlStateNormal];
        [cityButton setTitleColor:HEX_COLOR(0x363636) forState:UIControlStateNormal];
        if (iPhone6Plus) {
            cityButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        }else
        {
            cityButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        }
        
        [self.view addSubview:cityButton];
        CGFloat cityButtonX = H_PADDING + col * (cityButtonW + H_PADDING);
        CGFloat cityButtonY = 36.0 + row * (cityButtonH + V_PADDING);
        cityButton.frame = CGRectMake(cityButtonX, cityButtonY, cityButtonW, cityButtonH);
    }
}

#pragma mark - Action
- (void)cityBtnOnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(citySelectorViewControllerDidSelectCity:)]) {
        [self.delegate citySelectorViewControllerDidSelectCity:button.currentTitle];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
