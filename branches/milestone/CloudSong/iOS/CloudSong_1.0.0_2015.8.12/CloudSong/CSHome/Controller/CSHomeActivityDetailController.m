//
//  CSThemeDetailViewController.m
//  CloudSong
//
//  Created by EThank on 15/7/22.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeActivityDetailController.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "SGActionView.h"
#import <UMSocial.h>
#import "WXApi.h"
#import "CSUserInfoModel.h"
#import "SVProgressHUD.h"


@interface CSHomeActivityDetailController () <UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView ;


@end

@implementation CSHomeActivityDetailController
{
    UIButton * shareBut;

}
- (void)viewDidLoad{
    [super viewDidLoad] ;
    
    self.view.backgroundColor = [UIColor blueColor] ;
//    self.navigationController.navigationBar.translucent = YES ;
//    self.urlStr = @"https://www.baidu.com/" ;
    self.title = @"活动详情" ;
    
//    CSUserInfoModel * userInfo =GlobalObj.userInfo;
//    if (userInfo) {
//        self.shareContent = [NSString stringWithFormat:@"小伙伴们，赶紧来参加@%@ 发起的“%@”活动吧，Fashional Party， 你还在等什么，再不来你就OUT啦",userInfo.nickName,_shareTitle];
//    }else{
    self.shareContent = [NSString stringWithFormat:@"小伙伴们，赶紧来参加@潮趴汇 发起的“%@”活动吧，Fashional Party， 你还在等什么，再不来你就OUT啦",_shareTitle];

//    }
    shareBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBut addTarget:self action:@selector(clickShareBut) forControlEvents:UIControlEventTouchUpInside];
    [shareBut setTitle:@"分享" forState:UIControlStateNormal];
    shareBut.tintColor=HEX_COLOR(0Xe20399);
    shareBut.titleLabel.font=[UIFont systemFontOfSize:16];
    shareBut.frame=CGRectMake(0, 0, 50, 30);
    
    UIBarButtonItem * rightShareBar = [[UIBarButtonItem alloc]initWithCustomView:shareBut];
    self.navigationItem.rightBarButtonItem = rightShareBar;
    self.shareImage = [UIImage imageNamed:@"room_share_icon"];
    [self setupSubviews] ;
}

- (void)setupSubviews{
    UIWebView *webView = [[UIWebView alloc] init] ;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]] ;
    [self.view addSubview:webView] ;
    self.webView = webView ;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(webView.superview) ;
    }] ;
}
-(void)clickShareBut{
    
//    NSArray *titleArray = @[@"微信", @"朋友圈", @"QQ", @"微博"] ;
//    
//    NSArray *images = @[[UIImage imageNamed:@"player_wechat_icon"],
//                        [UIImage imageNamed:@"player_friends_icon"],
//                        [UIImage imageNamed:@"player_qq_icon"],
//                        [UIImage imageNamed:@"player_weibo_icon"],] ;
    NSArray *titleArray = nil;
    NSArray * images = nil;
    if ([WXApi isWXAppInstalled] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        titleArray = @[@"微信", @"朋友圈", @"QQ", @"微博"] ;
        images = @[[UIImage imageNamed:@"player_wechat_icon"],
                   [UIImage imageNamed:@"player_friends_icon"],
                   [UIImage imageNamed:@"player_qq_icon"],
                   [UIImage imageNamed:@"player_weibo_icon"],] ;
    }else if ([WXApi isWXAppInstalled] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
        titleArray = @[@"微信", @"朋友圈",@"微博"] ;
        images = @[[UIImage imageNamed:@"player_wechat_icon"],
                   [UIImage imageNamed:@"player_friends_icon"],
                   [UIImage imageNamed:@"player_weibo_icon"],] ;
    }else if(![WXApi isWXAppInstalled] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
        titleArray = @[@"QQ", @"微博"] ;
        images = @[
                   [UIImage imageNamed:@"player_qq_icon"],
                   [UIImage imageNamed:@"player_weibo_icon"],] ;
    }else if (![WXApi isWXAppInstalled] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
        titleArray = @[@"微博"];
        images = @[
                   [UIImage imageNamed:@"player_weibo_icon"],] ;
    }
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:titleArray
                                 images:images
                         selectedHandle:^(NSInteger index) {
                             // 处理分享
                             [self didSelectShareBtnIndex:index];
                         }] ;
    
}


//#pragma mark - UserDescViewDelegate 处理分享事件
- (void)didSelectShareBtnIndex:(NSInteger)index
{
    NSInteger newIndex = 0;
    if (index == 0) {
        newIndex = 0;
    }else{
        if ([WXApi isWXAppInstalled] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
        }else if ([WXApi isWXAppInstalled] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
            if (index == 3) {
                newIndex = 1;
            }
        }else if(![WXApi isWXAppInstalled] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
            newIndex = 2;
        }else if (![WXApi isWXAppInstalled] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
            newIndex = 3;
        }
    }
    
    switch (index+newIndex) {
        case CSShareCategoryCancel:
            // cancel
            CSLog(@"click cancel") ;
            break;
        case CSShareCategoryWechat:
            // wechat
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _htmlUrl;
            [UMSocialData defaultData].extConfig.wechatSessionData.title =_shareTitle;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享微信好友成功") ;
                    [SVProgressHUD showSuccessWithStatus:@"分享微信好友成功"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享微信好友失败！"];
                }
            }] ;
            break ;
        case CSShareCategoryTimeLine:
            // friends
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _htmlUrl;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享朋友圈成功") ;
                    [SVProgressHUD showSuccessWithStatus:@"分享朋友圈成功"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享朋友圈失败！"];
                }
            }] ;
            break ;
        case CSShareCategoryQQ:{
            [UMSocialData defaultData].extConfig.qqData.url = _htmlUrl;
            [UMSocialData defaultData].extConfig.qqData.title =_shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享QQ成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享QQ成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享QQ失败！"];
                }
            }];
            CSLog(@"qq share") ;
        }
            // QQ
            break ;
        case CSShareCategoryWeibo:
            // sinaWeibo
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",_shareContent,_htmlUrl] image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享sina微博成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享sina微博成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享sina微博失败！"];
                }
            }];

            CSLog(@"player_weibo_icon") ;
            break ;
        default:
            break;
    }
}


#pragma mark - Action Method
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error = %@", error) ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"DidFinishLoad....") ;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"DidStartLoad....") ;
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 1 ;
    [self.navigationController.navigationBar setBarTintColor:HEX_COLOR(0x1b162f)];

    [super viewWillAppear:animated] ;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:HEX_COLOR(0x151417)];
    [super viewWillDisappear:animated] ;
}

#pragma mark - 网络监听恢复
- (void)networkReachability
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]];
}
@end
