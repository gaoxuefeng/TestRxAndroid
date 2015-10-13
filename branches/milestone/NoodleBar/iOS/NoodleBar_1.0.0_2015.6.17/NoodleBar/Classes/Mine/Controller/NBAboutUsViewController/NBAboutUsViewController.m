//
//  NBAboutUsViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAboutUsViewController.h"

@interface NBAboutUsViewController ()

@end

@implementation NBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self setupSubViews];
}


- (void)setupSubViews
{
    UIWebView *webView = [[UIWebView alloc] initForAutoLayout];
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    [webView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:ABOUT_US_URL]];
    [webView loadRequest:requset];
    webView.scrollView.backgroundColor = [UIColor whiteColor];
//    // 大logo
//    UIImageView *bigLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_about_us"]];
//    [self.view addSubview:bigLogo];
//    [bigLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:AUTOLENGTH(85.f)];
//    [bigLogo autoAlignAxisToSuperviewAxis:ALAxisVertical];
//
//    // 小logo
//    UIImageView *smallLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_nav_title_view"]];
//    [self.view addSubview:smallLogo];
//    [smallLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bigLogo withOffset:AUTOLENGTH(18.f)];
//    [smallLogo autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    
//    // 版本号
//    UILabel *versionLabel = [[UILabel alloc] initForAutoLayout];
//    versionLabel.text = @"版本号1.0";
//    versionLabel.font = [UIFont systemFontOfSize:11.f];
//    versionLabel.textColor = UICOLOR_FROM_HEX(0xa7a7a7);
//    [self.view addSubview:versionLabel];
//    [versionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:smallLogo withOffset:AUTOLENGTH(12.f)];
//    [versionLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    
//    
//    // 中文名
//    UILabel *companyLabel = [[UILabel alloc] init];
//    companyLabel.text = @"壹尚科技";
//    companyLabel.font = [UIFont systemFontOfSize:11.f];
//    companyLabel.textColor = UICOLOR_FROM_HEX(0xa7a7a7);
//    [self.view addSubview:companyLabel];
//    [companyLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:AUTOLENGTH(36.f)];
//
//    [companyLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    
//    // 网址
//    UILabel *webAddressLabel = [[UILabel alloc] init];
//    webAddressLabel.text = @"www.ethank.com.cn";
//    webAddressLabel.font = [UIFont systemFontOfSize:11.f];
//    webAddressLabel.textColor = UICOLOR_FROM_HEX(0xa7a7a7);
//    [self.view addSubview:webAddressLabel];
//    [webAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:companyLabel withOffset:AUTOLENGTH(6.f)];
//    [webAddressLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
}


@end
