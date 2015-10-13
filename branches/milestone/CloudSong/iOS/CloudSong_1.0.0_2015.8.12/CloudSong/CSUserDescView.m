//
//  CSUserDescView.m
//  CloudSong
//
//  Created by EThank on 15/6/13.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSUserDescView.h"
#import "CSDefine.h"
#import "SGActionView.h"
#import "CSPlayingModel.h"
#import <UIImageView+WebCache.h>
#import "WXApi.h"

@interface CSUserDescView () <UIActionSheetDelegate>

/** 用户头像 */
@property (nonatomic, weak) UIImageView *headView ;
/** 用户名 */
@property (nonatomic, weak) UILabel *userName ;
/** 签名信息 */
@property (nonatomic, weak) UILabel *signatureLabel ;
/** 分享按钮 */
@property (nonatomic, weak) UIButton *shareBtn ;

@end

@implementation CSUserDescView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self) {
        
//        self.backgroundColor = [UIColor grayColor] ;
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1] ;
//        self.alpha = 0.3 ;
        // 初始化头像
        UIImageView *headView = [[UIImageView alloc] init] ;
        [self addSubview:headView] ;
        headView.image = [UIImage imageNamed:@"mine_default_avatar"] ;
        self.headView = headView ;
        
        // 用户名
        UILabel *userName = [[UILabel alloc] init] ;
//        userName.text = @"BeyondChao" ;
        [userName setTextColor:Color_168_168_165] ;
        [self addSubview:userName] ;
        self.userName = userName ;
        
        // 描述信息
        UILabel *signatureLabel = [[UILabel alloc] init] ;
//        signatureLabel.text = @"Hello World! Hello BeyondChao" ;
        [signatureLabel setTextColor:Color_168_168_165] ;
        signatureLabel.font = [UIFont systemFontOfSize:12] ;
        [self addSubview:signatureLabel] ;
        self.signatureLabel = signatureLabel ;
        
        // 分享按钮
        UIButton *shareBtn = [[UIButton alloc] init] ;
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"player_share_icon"] forState:UIControlStateNormal] ;
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:shareBtn] ;
        self.shareBtn = shareBtn ;
        
    }
    return self ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 头像frame
    CGFloat headImageX = TRANSFER_SIZE(5) ;
    CGFloat headImageY = TRANSFER_SIZE(15) ;
    CGFloat headImageWH = TRANSFER_SIZE(30) ;
    self.headView.frame = CGRectMake(headImageX, headImageY, headImageWH, headImageWH) ;
    self.headView.layer.cornerRadius = headImageWH/2;
    self.headView.layer.masksToBounds = YES;
    
    // 2. 用户姓名frame
    CGFloat margin = TRANSFER_SIZE(10) ;
    CGFloat nameX = headImageWH + margin ;
    CGFloat nameY = margin ;
    CGFloat nameW = TRANSFER_SIZE(200) ;
    CGFloat nameH = TRANSFER_SIZE(20) ;
    self.userName.frame = CGRectMake(nameX, nameY, nameW, nameH) ;
    
    // 3. 用户描述信息frame
    CGFloat descX = nameX ;
    CGFloat descY = CGRectGetMaxY(self.userName.frame) + 2 ;
    CGFloat descW = nameW ;
    CGFloat descH = TRANSFER_SIZE(20) ;
    self.signatureLabel.frame = CGRectMake(descX, descY, descW, descH) ;
    
    // 4. 分享按钮frame
    CGFloat btnX = SCREENWIDTH - TRANSFER_SIZE(50) ;
    CGFloat btnY = TRANSFER_SIZE(20) ;
    CGFloat btnW = TRANSFER_SIZE(20) ;
    CGFloat btnH = TRANSFER_SIZE(20) ;
    self.shareBtn.frame = CGRectMake(btnX, btnY, btnW, btnH) ;
} 

- (void)setPlayerModel:(CSPlayingModel *)playerModel{
    _playerModel = playerModel ;
    
    self.userName.text = playerModel.userName ;
    self.signatureLabel.text = playerModel.signature ;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:playerModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"mine_default_avatar"]] ;
}

#pragma mark - 点击分享按钮

- (void)shareBtnClick
{
//    NSArray *titleArray = @[@"微信", @"朋友圈", @"QQ", @"微博"] ; 
//    
//    NSArray *images = @[[UIImage imageNamed:@"player_wechat_icon"],
//                        [UIImage imageNamed:@"player_friends_icon"],
//                        [UIImage imageNamed:@"player_qq_icon"],
//                        [UIImage imageNamed:@"player_weibo_icon"],] ;
    //        @"微信", @"朋友圈", @"QQ", @"微博"
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
                             [self handleShare:index] ;
    }] ;
}

#pragma mark - 处理分享
- (void)handleShare:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(userDescView:didSelectShareBtnIndex:)]) {
        
        [self.delegate userDescView:self didSelectShareBtnIndex:index] ;
    }
}

- (void)dealloc
{
    CSLog(@"UserDescView dealloc...") ;
}
@end
