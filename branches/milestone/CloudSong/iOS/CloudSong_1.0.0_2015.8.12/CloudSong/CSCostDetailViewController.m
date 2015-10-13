//
//  CSCostDetailViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCostDetailViewController.h"
#import "CSSegmentControl.h"
#import <Masonry.h>

@interface CSCostDetailViewController () <CSSegmentControlDelegate, UIScrollViewDelegate> {
    UIScrollView*       _scrollView;
    UIWebView*          _standardWebView;
    UIWebView*          _activitiesWebView;
    CSSegmentControl*   _segmentControl;
}
@end

@implementation CSCostDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计费详情";
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setupSubViews
{
    _segmentControl = [[CSSegmentControl alloc] initWithTitles:@[@"进行中",@"历史消费"]];
    _segmentControl.delegate = self;
    _segmentControl.backgroundColor = HEX_COLOR(0x222126);
    _segmentControl.titleColor = HEX_COLOR(0x9898a2);
    _segmentControl.selectedTitleColor = HEX_COLOR(0xf03da2);
    _segmentControl.blockColor = HEX_COLOR(0xf03da2);
    _segmentControl.blockEdgeInsets = UIEdgeInsetsMake(0.0, 27.0, 0.0, 27.0);
    [self.view addSubview:_segmentControl];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(34.0);
    }];
    
    // 顶部分割线
    UIView *segmentControlTopLine = [[UIView alloc] init];
    segmentControlTopLine.backgroundColor = HEX_COLOR(0x141417);
    [_segmentControl addSubview:segmentControlTopLine];
    [segmentControlTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(segmentControlTopLine.superview);
        make.height.mas_equalTo(0.5);
    }];
    
    // 中间分割线
    UIView *segmentControlCenterLine = [[UIView alloc] init];
    segmentControlCenterLine.backgroundColor = HEX_COLOR(0x141417);
    [_segmentControl addSubview:segmentControlCenterLine];
    [segmentControlCenterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(segmentControlCenterLine.superview);
        make.size.mas_equalTo(CGSizeMake(0.5, 14.0));
    }];
    
    // 底部分割线
    UIView *segmentControlBottomLine = [[UIView alloc] init];
    segmentControlBottomLine.backgroundColor = HEX_COLOR(0x141417);
    [_segmentControl addSubview:segmentControlBottomLine];
    [segmentControlBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(segmentControlBottomLine.superview);
        make.height.mas_equalTo(0.5);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_segmentControl.mas_bottom);
    }];
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    _standardWebView = [[UIWebView alloc] init];
    _standardWebView.backgroundColor = HEX_COLOR(0x1d1c21);
    [container addSubview:_standardWebView];
    [_standardWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(container);
        make.width.mas_equalTo(self.view);
    }];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    [_standardWebView loadRequest:request];
    
    _activitiesWebView = [[UIWebView alloc] init];
    _activitiesWebView.backgroundColor = HEX_COLOR(0x1d1c21);
    [container addSubview:_activitiesWebView];
    [_activitiesWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(container);
        make.left.equalTo(_standardWebView.mas_right);
        make.width.mas_equalTo(self.view);
        make.right.equalTo(container);
    }];
    request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    [_activitiesWebView loadRequest:request];
}

#pragma mark - CSSegmentControlDelegate

- (void)segmentControl:(CSSegmentControl *)segmentControl selectedIndex:(NSInteger)selectedIndex {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        _segmentControl.blockX = scrollView.contentOffset.x * 0.5;
    }
}

@end
