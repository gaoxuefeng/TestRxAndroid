//
//  NBMineViewController.m
//  NoodleBar
//
//  Created by sen on 6/6/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBMineViewController.h"
#import "NBToLoginView.h"
#import "NBLoginViewController.h"
#import "NBAddressViewController.h"
#import "NBCell.h"
#import "NBAccountTool.h"
#import "NBAccountModel.h"
#import "NBAboutUsViewController.h"
#import "NBFeedBackViewController.h"
#import "NBLoginHttpTool.h"
@interface NBMineViewController ()
{
    NBToLoginView *_toLoginView;
}
@end

@implementation NBMineViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(0xf3f3f3);
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([NBAccountTool userToken] && ![NBAccountTool account]) { // 有缓存的token和userid但是没账号
        NBRequestModel *param = [[NBRequestModel alloc] init];
        [NBLoginHttpTool getUserInfoWithParam:param success:^(NBAccountResponseModel *result) {
            [NBAccountTool setAccount:result.data.account];
            [NBAccountTool setAddresses:result.data.addresses];
            _toLoginView.phone = [NBAccountTool account].phonenum;
        } failure:^(NSError *error) {
            NBLog(@"%@",error);
        }];
    }else if(![NBAccountTool userToken] && ![NBAccountTool userId] && ![NBAccountTool account])// 三无
    {
        
    }else
    {
        _toLoginView.phone = [NBAccountTool account].phonenum;
    }
}

- (void)setupSubViews
{
    // 登录
    _toLoginView = [[NBToLoginView alloc] initForAutoLayout];
    [self.view addSubview:_toLoginView];
    [_toLoginView autoSetDimension:ALDimensionHeight toSize:175.f];
    [_toLoginView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_toLoginView toLoginBtnAddTarget:self Action:@selector(toLoginBtnOnClick)];
    
    // 送餐地址
    NBCell *addressCell = [[NBCell alloc] initForAutoLayout];
    [self.view addSubview:addressCell];
    
    
    __weak typeof(self) weakSelf = self;
    addressCell.option = ^{
        [weakSelf.navigationController pushViewController:[[NBAddressViewController alloc] init] animated:YES];
    };
    if (iPhone6Plus) {
        [addressCell setText:@"送餐地址" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:16.f]];
    }else
    {
        [addressCell setText:@"送餐地址" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:13.f]];
    }
    
    [addressCell setImage:[UIImage imageNamed:@"merchant_location"]];
    addressCell.showBottomDivider = YES;
    
    [addressCell autoSetDimension:ALDimensionHeight toSize:AUTOLENGTH(40.0)];
    [addressCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_toLoginView];
    [addressCell autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_toLoginView];
    [addressCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
    // 意见反馈
    NBCell *feedBackCell = [[NBCell alloc] initForAutoLayout];
    [self.view addSubview:feedBackCell];
    if (iPhone6Plus) {
        [feedBackCell setText:@"意见反馈" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:16.f]];
    }else
    {
        [feedBackCell setText:@"意见反馈" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:13.f]];
    }

    [feedBackCell setImage:[UIImage imageNamed:@"mine_feedback_icon"]];
    feedBackCell.showBottomDivider = YES;
    feedBackCell.option = ^{
        
        [weakSelf.navigationController pushViewController:[[NBFeedBackViewController alloc] init] animated:YES];
    };
    [feedBackCell autoSetDimension:ALDimensionHeight toSize:AUTOLENGTH(40.0)];
    [feedBackCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:addressCell];
    [feedBackCell autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:addressCell];
    [feedBackCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 关于我们
    NBCell *aboutUsCell = [[NBCell alloc] initForAutoLayout];
    [self.view addSubview:aboutUsCell];
    if (iPhone6Plus) {
        [aboutUsCell setText:@"关于我们" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:16.f]];
    }else
    {
        [aboutUsCell setText:@"关于我们" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:13.f]];
    }
    [aboutUsCell setImage:[UIImage imageNamed:@"mine_about_us_icon"]];
    aboutUsCell.option = ^{
        [weakSelf.navigationController pushViewController:[[NBAboutUsViewController alloc] init] animated:YES];
    };
    
    [aboutUsCell autoSetDimension:ALDimensionHeight toSize:AUTOLENGTH(40.0)];
    [aboutUsCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:feedBackCell];
    [aboutUsCell autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:feedBackCell];
    [aboutUsCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
}

#pragma mark - Action
- (void)toLoginBtnOnClick
{
    [self.navigationController pushViewController:[[NBLoginViewController alloc] init] animated:YES];
}

@end
