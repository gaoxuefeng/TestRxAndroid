//
//  CSMusicPlayerViewController.m
//  CloudSong
//
//  Created by EThank on 15/6/12.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMusicPlayerViewController.h"
#import "CSUserDescView.h"
#import "CSBottomHeadView.h"
#import "CSPlayerView.h"
#import "CSPlayControlView.h" 
#import "CSPlayingModel.h"
#import <UMSocial.h>
#import "CSLoginViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "CSDataService.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "WXApi.h"
#import "SVProgressHUD.h"
#import "CSActivityWeiBoShareEditeViewController.h"


#define Bar_Tint_Color [UIColor colorWithRed:4.0/255.0 green:3.0/255.0 blue:2.0/255.0 alpha:1]

@interface CSMusicPlayerViewController () <UserDescViewDelegate,
                                           PlayControlViewDelegate,
                                           BottomHeadViewDelegate>
{
    BOOL flag;
    NSInteger ind;
}
@property (nonatomic, weak) UIImageView *bgImageView ;
/** 播放控件视图 */
@property (nonatomic, weak) CSPlayControlView *playControlView;
/** 播放针唱片视图 */
@property (nonatomic, weak) CSPlayerView *playerView ;
/** 底部头像视图 */
@property (nonatomic, weak) CSBottomHeadView *bottomHeadView ;
/** 下方用户信息视图 */
@property (nonatomic, weak) CSUserDescView *descView ;

// 一些分享的信息
@property (nonatomic, copy) NSString *shareUrl ;
@property (nonatomic, copy) NSString *shareTitle ;
@property (nonatomic, copy) NSString *shareContent ;
@property (nonatomic, strong) UIImage *shareImage ;


/** 媒体播放器 */
@property (nonatomic, strong) MPMoviePlayerController *mediaPlayer ;

//是否跳转登陆页面
@property (nonatomic, assign) BOOL goLogin;

@end

@implementation CSMusicPlayerViewController


- (instancetype)initWithShareUrl:(NSString *)shareUrl
{
    _shareUrl = shareUrl;
    
    return [self init];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = self.musicName ;
    ind = 0;
    UILabel *playerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)] ;
    playerTitleLabel.textColor = [UIColor whiteColor] ;
    playerTitleLabel.text = self.musicName ;
    self.navigationItem.titleView = playerTitleLabel ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLastPage) name:DISCOVER_NET_BAD object:nil];
    // 0. 请求数据
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
    [self.navigationController.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} forState:UIControlStateNormal];
    
//    [self customBottomUI] ;
    if (self.playCountBlock) {
        self.playCountBlock();
    }
    
    // 设置分享信息
    self.shareTitle = self.musicName;
//    self.shareContent = GlobalObj.userInfo.nickName;
    
    // 初始化媒体播放器
    [self initMoviePlayerControllerWithURL:self.musicUrl];
    
}
- (void)goToLastPage
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (ind == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        ind = 1;
    });
}
#pragma mark -- UIAlertViewDelegate

- (void)customBottomUI
{
    WS(ws) ;
    // 1. 创建底部头像view
    CGFloat bottomViewH = TRANSFER_SIZE(52) ;
    CGFloat bottomHeadViewY = SCREENHEIGHT - bottomViewH  - 64;
    CSBottomHeadView *bottomHeadView = [[CSBottomHeadView alloc] initWithFrame:CGRectMake(0, bottomHeadViewY, SCREENWIDTH, bottomViewH)] ;
    bottomHeadView.delegate = self ;
    [self.view addSubview:bottomHeadView] ;
    self.bottomHeadView = bottomHeadView ;
    
    self.bottomHeadView.praiseBlock =^(NSNumber * count){
        ws.praiseBlock(count); // 用self会造成循环引用
    };
    // 2. 创建用户信息view
    CGFloat descViewH = bottomViewH ;
    CGFloat desvViewY = bottomHeadViewY - bottomViewH - 1;
    CSUserDescView *descView = [[CSUserDescView alloc] initWithFrame:CGRectMake(0, desvViewY , SCREENWIDTH, descViewH)] ;
    descView.delegate = self ;
    [self.view addSubview:descView ] ;
    self.descView = descView ;
    
    // 3. 创建播放控件view
    CGFloat playControlViewH = TRANSFER_SIZE(55) ;
    CGFloat playControlViewY = desvViewY - playControlViewH;
    CSPlayControlView *playControlView = [[CSPlayControlView alloc] initWithFrame:CGRectMake(0, playControlViewY, SCREENWIDTH, playControlViewH)] ;
    playControlView.delegate = self ;

    [self.view addSubview:playControlView] ;
    _playControlView = playControlView;
    
    
    // 4. 创建播放器view
    CGFloat playerViewH = SCREENHEIGHT - bottomViewH - descViewH - playControlViewH- TRANSFER_SIZE(64);
    CSPlayerView *playerView = [[CSPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, playerViewH)] ;//TRANSFER_SIZE(64)
    [self.view addSubview:playerView] ;
    self.playerView = playerView ;
    
    // 设置播放针位置
    self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI_4);
    self.playControlView.playPauseBtn.selected = YES;
}


#pragma mark - 监听 networkReachability
- (void)networkReachability{
    [super networkReachability] ;
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
    [self initMoviePlayerControllerWithURL:self.musicUrl] ;
}

#pragma mark - 数据请求
- (void)asyncGetPlayerDataByDiscoveryId:(NSString *)discoveryId{

    [[CSDataService sharedInstance] asyncGetDiscoveryPlayerDataByDiscoveryId:discoveryId handler:^(CSPlayingModel *playerData) {
        // 传递模型设置数据
        self.bottomHeadView.discoverId = self.discoveryId ;
        self.descView.playerModel = playerData ;
        self.bottomHeadView.playerModel = playerData ;
//        self.shareContent = [NSString stringWithFormat:@"小伙伴们，赶紧来听听@%@ 唱的《%@》吧，TA马上就要变成歌神啦！你还在等什么，赶快来挑战吧！", playerData.userName, playerData.songName];
        self.shareContent = playerData.shareContent;
        self.shareImage = [UIImage imageNamed:@"room_share_icon"];
    }];
}

#pragma mark - UserDescViewDelegate 处理分享事件
- (void)userDescView:(CSUserDescView *)userDescView didSelectShareBtnIndex:(NSInteger)index
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
    NSString * shareUrl = [NSString stringWithFormat:@"%@?id=%@", self.shareUrl ,self.discoveryId];
    switch (index+newIndex) {
        case CSShareCategoryCancel:
            // cancel
            CSLog(@"click cancel") ;
            break;
        case CSShareCategoryWechat:
            // wechat
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享微信好友成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享微信好友失败！"];
                }
            }] ;
            break ;
        case CSShareCategoryTimeLine:
            // friends
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareContent;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享朋友圈成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享朋友圈失败！"];
                }
            }] ;
            break ;
        case CSShareCategoryQQ:{
            [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
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
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@\n\n%@", self.shareContent, shareUrl] image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                //                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享sina微博成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享sina微博失败！"];
                }
            }];
//            [self shareToWeiBo];
            break ;
        default:
            break;
    }
    
}
- (void)shareToWeiBo
{
    CSActivityWeiBoShareEditeViewController * weiBoShareVC = [[CSActivityWeiBoShareEditeViewController alloc] initWithShareContentText:_shareContent htmlUrl:_shareUrl shareImage:_shareImage];
    UINavigationController * shareNC= [[UINavigationController alloc]initWithRootViewController:weiBoShareVC];
    [self presentViewController:shareNC animated:YES completion:nil];
}
#pragma mark 播放 暂停滑竿动画
#pragma mark - PlayControlViewDelegate 播放器的播放和暂停事件
- (void)playControlView:(CSPlayControlView *)playControlView playStatus:(CSPlayStatus)playStatus
{
    if (playStatus == CSPlayStatusPause) {
        if (CGAffineTransformIsIdentity(self.playerView.playerNeedleView.transform)) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.playerView removeLink] ;
                [self.mediaPlayer pause] ; // 暂停播放
                self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI_4);
            }];
        }
    }else if (playStatus == CSPlayStatusPlaying){
        if (self.isNetWorking || GlobalObj.isNetConnection) {
            [self.playerView addLink] ;
            [self.mediaPlayer play] ;  // 播放
        }
        if (!CGAffineTransformIsIdentity(self.playerView.playerNeedleView.transform)) {
            [UIView animateWithDuration:0.3 animations:^{
                self.playerView.playerNeedleView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

#pragma mark - PlayControlViewDelegate
// 改变进度
- (void)playControlView:(CSPlayControlView *)playControlView changeProgress:(CGFloat)progressValue{
    
    NSTimeInterval time = _mediaPlayer.duration * progressValue ;
    _mediaPlayer.currentPlaybackTime = time ;
    [_playControlView setPlayTime:time];

    [_playControlView setProgress:progressValue] ;
    BOOL currentFlag = self.playControlView.playPauseBtn.selected;
    [self.mediaPlayer pause];
    flag = YES;
    if (!currentFlag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mediaPlayer play];
        });
        
        flag = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tranAnimation];
        });
    }
}
- (void)tranAnimation
{
    if (!flag) {
        [self monitorPlaybackTime];
        self.playControlView.playPauseBtn.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.playerView.playerNeedleView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self.playerView addLink];
        }] ;
    }
}
#pragma mark - BottomHeadViewDelegate 处理点赞需先登录
- (void)bottomHeadView:(CSBottomHeadView *)bottomHeadView didClickLikeBtn:(UIButton *)likeBtn
{
    self.goLogin=YES;
    CSLoginViewController *loginVC = [[CSLoginViewController alloc] init] ;
    loginVC.loginBlock = ^(BOOL success){
        [self.navigationController popViewControllerAnimated:YES] ;
//        CSLog(@"loginBlock....") ;
    } ;
    [self.navigationController pushViewController:loginVC animated:YES] ;
}

- (void)bottomHeadViewDidChangePraiseState:(CSBottomHeadView *)bottomHeadView {
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
    
//  self.mediaPlayer.initialPlaybackTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"playTime"] doubleValue];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreashData:) name:NET_WORK_REACHABILITY object:nil];

}

////////////////////////////////////////////////

- (void)resetStates {
    [self.playerView removeLink];
    [self.playControlView setPlayTime:0];
    [self.playControlView setDuration:0];
    [self.playControlView setProgress:0];
}

- (void)initMoviePlayerControllerWithURL:(NSString *)url {

    
    if (self.mediaPlayer == nil) {
        [self customBottomUI] ;

        self.mediaPlayer = [[MPMoviePlayerController alloc] init];
        
        // 设置一些属性
        self.mediaPlayer.view.backgroundColor = [UIColor clearColor] ;
        self.mediaPlayer.backgroundView.backgroundColor = [UIColor clearColor] ;
        self.mediaPlayer.view.frame = CGRectZero ;
        [self.mediaPlayer setRepeatMode:MPMovieRepeatModeOne] ;
        [self.view addSubview:self.mediaPlayer.view];
        
        // 1.创建音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance] ;
        // 2.设置会话类型
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 3.激活会话
        [session setActive:YES error:nil];
        
    }
    [self.mediaPlayer setContentURL:[NSURL URLWithString:url]] ;
    [self.mediaPlayer prepareToPlay];
    [self.mediaPlayer play] ;
    
    // 添加通知
    [self addNotificationForPlayer] ;

}

#pragma mark - 添加通知
- (void)addNotificationForPlayer{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDurationAvailableNotification)
                                                 name:MPMovieDurationAvailableNotification
                                               object:self.mediaPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayerPlaybackStateChanged)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.mediaPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayerPrepareToPlay)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.mediaPlayer];
    
}

#pragma mark - 删除通知
- (void)deleteNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:self.mediaPlayer] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mediaPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.mediaPlayer];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_REACHABILITY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DISCOVER_NET_BAD object:nil];}

- (BOOL)isPlaying {
    return self.mediaPlayer.playbackState == MPMoviePlaybackStatePlaying
   || self.mediaPlayer.playbackState == MPMoviePlaybackStateSeekingBackward
    || self.mediaPlayer.playbackState == MPMoviePlaybackStateSeekingForward ;
}

#pragma mark - Player Notifications

- (void) handleDurationAvailableNotification {
//    [self.playControlView.playPauseBtn setImage:[UIImage imageNamed:@"player_pause_icon"] forState:UIControlStateNormal];
    self.playControlView.playPauseBtn.selected = NO;
    [self.playControlView setDuration:self.mediaPlayer.duration];

}

- (void)musicPlayerPrepareToPlay{
//    [self monitorPlaybackTime];
//    [UIView animateWithDuration:1.0 animations:^{
//        self.playerView.playerNeedleView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        [self.playerView addLink];
//    }] ;

}

- (void)musicPlayerPlaybackStateChanged {

    if ([self.mediaPlayer playbackState] == MPMoviePlaybackStatePlaying) {
        [self monitorPlaybackTime];
        self.playControlView.playPauseBtn.selected = NO;//player_pause_icon
        if (!CGAffineTransformIsIdentity(self.playerView.playerNeedleView.transform)) {
            [UIView animateWithDuration:0.5 animations:^{
                self.playerView.playerNeedleView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self.playerView addLink];
            }] ;
        }
    }
    else if ([self.mediaPlayer playbackState] == MPMoviePlaybackStatePaused) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(monitorPlaybackTime) object:nil];
        //缓存播放完毕
        [self.playerView removeLink] ;
        self.playControlView.playPauseBtn.selected = YES;//player_play_icon
        if (CGAffineTransformIsIdentity(self.playerView.playerNeedleView.transform)) {
            [UIView animateWithDuration:0.8 animations:^{
                self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI_4);
            }];
        }
    }else if ([self.mediaPlayer playbackState] == MPMoviePlaybackStateInterrupted){
        // 被其他音乐app打断了
        [self.playerView removeLink] ;
        [self.mediaPlayer pause] ; // 暂停播放
        self.playControlView.playPauseBtn.selected = YES;//player_play_icon
        self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }
}

- (void) monitorPlaybackTime {
    
    [self.playControlView setProgress:self.mediaPlayer.currentPlaybackTime / self.mediaPlayer.duration];
    [self.playControlView setDuration:self.mediaPlayer.duration];
    [self.playControlView setPlayTime:self.mediaPlayer.currentPlaybackTime];
    
    // 播放完当前视频
    if (self.mediaPlayer.duration != 0 && self.mediaPlayer.currentPlaybackTime >= self.mediaPlayer.duration - 1) {
                [self resetStates];
//                [self.mediaPlayer pause];
                [UIView animateWithDuration:0.5 animations:^{
                    self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI_4);
                } completion:^(BOOL finished) {
                    [self initMoviePlayerControllerWithURL:self.musicUrl];
                }] ;
    }
    else {
        if ([self isPlaying])
            [self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:0.1];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated] ;
    
    NSInteger controllerCount = self.navigationController.viewControllers.count ;
    
    if (controllerCount == 1 || controllerCount == 2) { // 播放器返回(点击返回btn或拖动)销毁mediaPlayer
        [self.playerView removeLink];                   // UIScreenEdgePanGestureRecognizer
        [self.mediaPlayer stop] ;
        self.mediaPlayer = nil ;
        [self.mediaPlayer setContentURL:nil];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_goLogin) {
        [self playControlView:self.playControlView playStatus:CSPlayStatusPlaying];
    }
}

- (void)dealloc{
    CSLog(@"CSMusicPlayerViewController....dealloc...") ;
    [self deleteNotification] ;
}

@end
