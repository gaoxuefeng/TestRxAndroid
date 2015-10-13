//
//  CSWeiboShareEditViewController.m
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSWeiboShareEditViewController.h"
#import "CSTextView.h"
#import <Masonry.h>
#import "UMSocialDataService.h"
#import "UMSocial.h"
#import "SVProgressHUD.h"
#import <WeiboSDK.h>
#import "CSMyRoomModel.h"
#define INVITE_HTML @"http://yunge.ethank.com.cn/ethank-yunge-deploy/html/market/invite-ktv.html"

@interface CSWeiboShareEditViewController ()
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *shareDefaultTextLabel;
@property(nonatomic, copy) NSString *shareTitle;
@property(nonatomic, copy) NSString *shareContent;
@property(nonatomic, copy) UIImage *shareImage;
@property(nonatomic, strong) CSMyRoomInfoModel *roomInfo;
@end

@implementation CSWeiboShareEditViewController

- (instancetype)initWithRoomInfo:(CSMyRoomInfoModel *)roomInfo
{
    _roomInfo = roomInfo;
    return [self init];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    [self configNavigationRightItem];
    [self setupSubViews];
    self.shareTitle = @"潮趴汇";
    self.shareContent = [NSString stringWithFormat:@"我在潮趴汇上预订了\"%@K歌活动\",诚邀各位参与!",_roomInfo.ktvName];
    self.shareImage = [UIImage imageNamed:@"share_icon"];
}

#pragma mark - Setup
- (void)setupSubViews
{
    CSTextView *textView = [[CSTextView alloc] init];
    textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
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
    [forgetPwdButton setTitle:@"邀请" forState:UIControlStateNormal];
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
    
    
    NSString *totalInviteUrl = [NSString stringWithFormat:@"%@?reserveBoxId=%@",INVITE_HTML,_roomInfo.reserveBoxId];
    
    
    NSString *contentString = [NSString stringWithFormat:@"%@%@",self.shareContent,totalInviteUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:contentString image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"邀请成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"邀请失败!"];
        }
    }];
    
        
}

@end
