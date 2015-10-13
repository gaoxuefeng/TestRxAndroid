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
#import "QuickMarkImageVIew.h"
@interface CSAboutUsViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIView * bgView;
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
    self.title = @"关于潮趴汇";
    [self setupSubViews];
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupScrollView];
}

- (void)setupScrollView
{
//    _scrollView = [[UIScrollView alloc] init];
//    _scrollView.alwaysBounceVertical = YES;
//    [self.view addSubview:_scrollView];
//    _scrollView.delegate=self;
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_scrollView.superview);
//    }];
    
    UIView *container = [[UIView alloc] init];
    [self.view addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_scrollView);
//        make.width.equalTo(_scrollView);
        make.edges.equalTo(container.superview);
    }];
    float topMargin = SCREENHEIGHT > 480?35:-10;
    
    UIView *headerView = [[UIView alloc] init];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.superview).offset(TRANSFER_SIZE(topMargin));
        make.left.right.equalTo(headerView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(135.0));
    }];
    

//    UIView *iconContainer = [[UIView alloc] init];
//    [headerView addSubview:iconContainer];
//    [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(iconContainer.superview);
//    }];
    
    //app图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"app_icon"];
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(63.0), TRANSFER_SIZE(63.0)));
        make.top.equalTo(iconView.superview).offset(15);
        make.centerX.equalTo(iconView.superview);
    }];

    UILabel *appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = @"潮趴汇";
    appNameLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    appNameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [headerView addSubview:appNameLabel];
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(appNameLabel.superview);
//        make.bottom.equalTo(appNameLabel.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(16));
        make.top.equalTo(iconView.mas_bottom).offset(TRANSFER_SIZE(10.0));
    }];
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [self getAppVersionAndName];
//    versionLabel.textColor = HEX_COLOR(0x717071);
    versionLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    versionLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [headerView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(versionLabel.superview);
        make.bottom.equalTo(versionLabel.superview).offset(-15);
        make.top.equalTo(appNameLabel.mas_bottom);
    }];
    
    //二维码
    
    UIImageView * quickMarkImg = [[UIImageView alloc] init];
    [quickMarkImg setBackgroundColor:[UIColor whiteColor]];
    quickMarkImg.image = [UIImage imageNamed:@"quickMark"];
    quickMarkImg.layer.cornerRadius = 4;
    quickMarkImg.layer.masksToBounds = YES;
    quickMarkImg.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popUpBigImage)];
//    tapGR.numberOfTapsRequired = 2;
//    [quickMarkImg addGestureRecognizer:tapGR];
    [container addSubview:quickMarkImg];
    [quickMarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(quickMarkImg.superview);
        make.top.equalTo(headerView.mas_bottom);//.offset(TRANSFER_SIZE(2))
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(150.0), TRANSFER_SIZE(150.0)));
    }];
    
    UILabel * tipLabel = [[UILabel alloc] init];
//    tipLabel.text = @"点击分享二维码给好友";
    tipLabel.text = @"邀请好友扫一扫分享给TA";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    [container addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipLabel.superview);
        make.top.equalTo(quickMarkImg.mas_bottom).offset(TRANSFER_SIZE(10));
        make.height.mas_equalTo(TRANSFER_SIZE(14.));
    }];
    
    //版权
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.text = @"壹尚科技 版权所有\ncopyright © 2015 Ethank.com.cn.All Right Reserved";
    copyrightLabel.numberOfLines=2;
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    copyrightLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    [container addSubview:copyrightLabel];
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TRANSFER_SIZE(50));
    }];
    
    
    UIButton * protocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [protocolButton addTarget:self action:@selector(goToProtocolPage:) forControlEvents:UIControlEventTouchUpInside];
    [protocolButton setBackgroundColor:[UIColor clearColor]];
    [protocolButton setTitle:@"潮趴汇软件许可使用协议" forState:UIControlStateNormal];
    [protocolButton setTitleColor:HEX_COLOR(0xa93275) forState:UIControlStateNormal];
    [protocolButton.titleLabel setFont:[UIFont systemFontOfSize:TRANSFER_SIZE(12.0)]];
    [container addSubview:protocolButton];
    [protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(TRANSFER_SIZE(14));
        make.bottom.equalTo(copyrightLabel.mas_top).offset(TRANSFER_SIZE(-10));
    }];
    
//    UIView *bottomLine = [[UIView alloc] init];
//    bottomLine.backgroundColor = HEX_COLOR(0x3f2757);
//    [headerView addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(bottomLine.superview);
//        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
//    }];
    
    
   /*
    CGFloat cellHeight = TRANSFER_SIZE(49.0);
    
    __weak typeof(self) weakSelf = self;
    
    
    // 服务条款
    CSAboutUsCell *serverTermsCell = [[CSAboutUsCell alloc] initWithTitle:@"免责声明"];
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
    
    */

    
}
- (NSString*)getAppVersionAndName
{
//    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];    //获取项目名称
//    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
//    
//    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"当前版本号：%@ (Build %@)",app_Version,app_build];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}
- (void)goToProtocolPage:(UIButton*)btn
{
    CSServerClauseViewController *serverClauseVc = [[CSServerClauseViewController alloc] init];
    [self.navigationController pushViewController:serverClauseVc animated:YES];
}
- (void)popUpBigImage
{
    QuickMarkImageVIew * bigQuickMarkImg = [[QuickMarkImageVIew alloc] initWithTitle:@"扫码分享" image:[UIImage imageNamed:@"quickMark"] tip:@"邀请好友扫一扫分享给TA"];
    [bigQuickMarkImg show];
}
#pragma mark - Config




#pragma mark - Action


@end
