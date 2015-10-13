//
//  CSFeedBackViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSFeedBackViewController.h"
#import <Masonry.h>
#import "CSTextView.h"
#import "CSBackBarButtonItem.h"
#import "CSMyInfoHttpTool.h"
#import "SVProgressHUD.h"


@interface CSFeedBackViewController ()
{
    UIScrollView *_scrollView;
    CSTextView *_textView;
    UIButton *_sendButton;
}
@end

@implementation CSFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setupSubViews];
    [self configNavigationBarRightItem];
}

#pragma mark - Setup
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    _textView = [[CSTextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _textView.placeHolder = @"请输入您宝贵的意见";
    _textView.placeHolderColor = HEX_COLOR(0x56565c);
    _textView.textColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = TRANSFER_SIZE(4.0);
    _textView.layer.masksToBounds = YES;
    _textView.backgroundColor = HEX_COLOR(0x222126);
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(self.view).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(self.view).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(125.0));
        make.bottom.equalTo(container);
    }];
    
    
}

#pragma mark - Config
- (void)configNavigationBarRightItem
{

    _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [_sendButton setTitleColor:HEX_COLOR(0x64656d) forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.size = CGSizeMake(TRANSFER_SIZE(40.0), TRANSFER_SIZE(40.0));
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sendButton];

}

#pragma mark - Action


- (void)sendBtnOnClick
{
    CSRequest *param = [[CSRequest alloc] init];
    param.message = _textView.text;
    [CSMyInfoHttpTool sendFeedBackWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.view endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }]; 
}

@end
