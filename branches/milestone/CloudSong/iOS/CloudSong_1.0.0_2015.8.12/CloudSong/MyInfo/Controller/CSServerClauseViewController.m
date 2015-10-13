//
//  CSServerClauseViewController.m
//  CloudSong
//
//  Created by sen on 15/8/10.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSServerClauseViewController.h"

@implementation CSServerClauseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务条款";
    
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(webView.superview);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yunge.ethank.com.cn/serverterms/terms.html"]];
    
    [webView loadRequest:request];
}

@end
