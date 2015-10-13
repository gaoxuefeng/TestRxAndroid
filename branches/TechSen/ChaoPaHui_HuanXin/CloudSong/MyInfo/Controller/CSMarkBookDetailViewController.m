//
//  CSMarkBookDetailViewController.m
//  CloudSong
//
//  Created by sen on 15/7/31.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMarkBookDetailViewController.h"

@interface CSMarkBookDetailViewController ()
@property(nonatomic, copy) NSString *url;

@end

@implementation CSMarkBookDetailViewController



- (instancetype)initWithUrl:(NSString *)url
{
    _url = url;
//    _url = @"http://www.baidu.com";
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(webView.superview);
    }];
}
@end
