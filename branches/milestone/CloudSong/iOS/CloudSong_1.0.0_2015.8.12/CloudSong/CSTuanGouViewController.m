//
//  CSTuanGouViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 7/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSTuanGouViewController.h"
#import <Masonry.h>

@interface CSTuanGouViewController () {
    UIWebView*  _webView;
}
@end

@implementation CSTuanGouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团购";
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
