//
//  CSWeiboShareViewController.m
//  CloudSong
//
//  Created by sen on 15/8/11.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSWeiboShareViewController.h"
#import "CSTextView.h"
#import <Masonry.h>
#import "UMSocialDataService.h"
#import "UMSocial.h"
#import "SVProgressHUD.h"
#import <WeiboSDK.h>

@interface CSWeiboShareViewController ()
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *shareDefaultTextLabel;
@property(nonatomic, copy) NSString *shareTitle;
@property(nonatomic, copy) NSString *shareContent;
@property(nonatomic, copy) UIImage *shareImage;

@end


@implementation CSWeiboShareViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.title = @"微博分享";
    [self configNavigationRightItem];
    [self setupSubViews];
    self.shareTitle = @"潮趴汇";
    self.shareImage = [UIImage imageNamed:@"share_icon"];
}

#pragma mark - Setup
- (void)setupSubViews
{
    CSTextView *textView = [[CSTextView alloc] init];
    textView.backgroundColor = HEX_COLOR(0x222126);
    textView.textColor = [UIColor whiteColor];
    textView.placeHolder = @"给大家说点什么吧";
    textView.returnKeyType = UIReturnKeyNext;
    textView.layer.cornerRadius = TRANSFER_SIZE(4.0);
    textView.layer.masksToBounds = YES;
    textView.placeHolderColor = HEX_COLOR(0x56565c);
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.superview).offset(TRANSFER_SIZE(16.0));
        make.left.equalTo(textView.superview).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(textView.superview).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(125.0));
    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"room_share_icon"];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.equalTo(logoView.superview).offset(TRANSFER_SIZE(10.0));
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(60.0), TRANSFER_SIZE(60.0)));
    }];
    _logoView = logoView;
    
    UILabel *shareDefaultTextLabel = [[UILabel alloc] init];
    shareDefaultTextLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    shareDefaultTextLabel.textColor = HEX_COLOR(0x939394);
    shareDefaultTextLabel.numberOfLines = 0;
    
    
    [self.view addSubview:shareDefaultTextLabel];
    [shareDefaultTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoView.mas_right).offset(TRANSFER_SIZE(8.0));
        make.centerY.equalTo(logoView);
        make.right.lessThanOrEqualTo(shareDefaultTextLabel.superview).offset(-TRANSFER_SIZE(10.0));
    }];
    _shareDefaultTextLabel = shareDefaultTextLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _shareDefaultTextLabel.text = self.shareContent;
}

#pragma mark - Config
- (void)configNavigationRightItem
{
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPwdButton addTarget:self action:@selector(inviteFriendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    forgetPwdButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(14.0)];
    [forgetPwdButton setTitle:@"分享" forState:UIControlStateNormal];
    [forgetPwdButton setTitleColor:HEX_COLOR(0x818289) forState:UIControlStateNormal];
    [forgetPwdButton sizeToFit];
    
    UIBarButtonItem *rightButtonBtn = [[UIBarButtonItem alloc] initWithCustomView:forgetPwdButton];
    self.navigationItem.rightBarButtonItem = rightButtonBtn;
}


- (void)inviteFriendBtnOnClick
{
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        [SVProgressHUD show];
    }
    
//    NSString *totalInviteUrl = [NSString stringWithFormat:@"%@?reserveBoxId=%@",INVITE_HTML,_roomInfo.reserveBoxId];
//    NSString *contentString = [NSString stringWithFormat:@"%@%@",self.shareContent,totalInviteUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:nil image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功!"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:shareResponse.message];
        }
    }];
    
    
}
@end
