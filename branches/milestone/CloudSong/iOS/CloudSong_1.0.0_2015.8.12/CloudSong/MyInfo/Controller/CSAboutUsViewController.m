//
//  CSAboutUsViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSAboutUsViewController.h"
#import <Masonry.h>
#import "CSAboutUsCell.h"
#import "SVProgressHUD.h"
#import "CSDefine.h"
#import "CSServerClauseViewController.h"
@interface CSAboutUsViewController ()
{
    UIScrollView *_scrollView;
}
// 打电话用
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation CSAboutUsViewController
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self setupSubViews];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupScrollView];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIView *headerView = [[UIView alloc] init];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(165.0));
    }];
    

    UIView *iconContainer = [[UIView alloc] init];
    [headerView addSubview:iconContainer];
    [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(iconContainer.superview);
    }];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"app_icon"];
    [iconContainer addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(63.0), TRANSFER_SIZE(63.0)));
        make.top.equalTo(iconView.superview);
        make.centerX.equalTo(iconView.superview);
    }];

    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"潮趴汇 1.0";
    versionLabel.textColor = HEX_COLOR(0x717071);
    versionLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [iconContainer addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(versionLabel.superview);
        make.bottom.equalTo(versionLabel.superview);
        make.top.equalTo(iconView.mas_bottom).offset(TRANSFER_SIZE(18.0));
    }];

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HEX_COLOR(0x141417);
    [headerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(bottomLine.superview);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
    
    
    CGFloat cellHeight = TRANSFER_SIZE(49.0);
    
    __weak typeof(self) weakSelf = self;
    
    
    // 服务条款
    CSAboutUsCell *serverTermsCell = [[CSAboutUsCell alloc] initWithTitle:@"服务条款"];
    [container addSubview:serverTermsCell];
    [serverTermsCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(serverTermsCell.superview);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(cellHeight);
    }];
    serverTermsCell.option = ^{
//        [SVProgressHUD showErrorWithStatus:@"暂无页面"];
        CSServerClauseViewController *serverClauseVc = [[CSServerClauseViewController alloc] init];
        [weakSelf.navigationController pushViewController:serverClauseVc animated:YES];
    };
    
//    // 系统通知
//    CSAboutUsCell *systemNotificationCell = [[CSAboutUsCell alloc] initWithTitle:@"系统通知"];
//    [container addSubview:systemNotificationCell];
//    [systemNotificationCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(systemNotificationCell.superview);
//        make.top.equalTo(serverTermsCell.mas_bottom);
//        make.height.mas_equalTo(cellHeight);
//    }];
//    systemNotificationCell.option = ^{
//        [SVProgressHUD showErrorWithStatus:@"暂无页面"];
//    };
    
    // 联系电话
    CSAboutUsCell *phoneNumCell = [[CSAboutUsCell alloc] initWithTitle:@"联系电话"];
    phoneNumCell.fullWidthDivider = YES;
    phoneNumCell.subTitle = @"010-84775234";
    [container addSubview:phoneNumCell];
    [phoneNumCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(phoneNumCell.superview);
        make.top.equalTo(serverTermsCell.mas_bottom);
        make.height.mas_equalTo(cellHeight);
        make.bottom.equalTo(phoneNumCell.superview.mas_bottom);
    }];
    __block typeof(phoneNumCell) blockPhoneCell = phoneNumCell;
    
    phoneNumCell.option = ^{
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",blockPhoneCell.subTitle];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
    };
    
    

    
}

#pragma mark - Config




#pragma mark - Action


@end
