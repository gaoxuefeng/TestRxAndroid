//
//  CSDianPingViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 4/30/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSDianPingViewController.h"
#import <Masonry.h>

@implementation CSDianPingViewController

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIWebView*  webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:self.ktvURL];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
