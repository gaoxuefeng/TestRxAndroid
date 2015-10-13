//
//  CSHomeBannerDetailController.m
//  CloudSong
//
//  Created by EThank on 15/8/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeBannerDetailController.h"

@interface CSHomeBannerDetailController ()
@property (nonatomic, weak) UIWebView *bannerDetailView ;
@end

@implementation CSHomeBannerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情" ;
//    [self setupSubView] ;
}

- (void)setupSubView{
    
    UIWebView *bannerDetailView = [[UIWebView alloc] init] ;
    bannerDetailView.scrollView.bounces = NO ;
    [self.view addSubview:bannerDetailView] ;
    self.bannerDetailView = bannerDetailView ;
    [_bannerDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bannerDetailView.superview) ;
    }] ;
    [self.bannerDetailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adBannerUrl]]] ;
}

- (void)networkReachability{
    [super networkReachability] ;
    [self.bannerDetailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adBannerUrl]]] ;
}

@end
