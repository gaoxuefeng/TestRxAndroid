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


#define Bar_Tint_Color [UIColor colorWithRed:4.0/255.0 green:3.0/255.0 blue:2.0/255.0 alpha:1]

@interface CSMusicPlayerViewController () <UserDescViewDelegate,
                                           PlayControlViewDelegate,
                                           BottomHeadViewDelegate>

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
    self.title = self.musicName ;
    self.navigationController.navigationBar.translucent = YES ;
    self.navigationController.navigationBar.barTintColor = Bar_Tint_Color ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLastPage) name:DISCOVER_NET_BAD object:nil];
    // 0. 请求数据
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
    
    // 初始化媒体播放器
    [self initMoviePlayerControllerWithURL:self.musicUrl];

    [self customUI] ;
    [self customBottomUI] ;
    self.playCountBlock();
    
    // 设置分享信息
    self.shareTitle = self.musicName;
//    self.shareContent = GlobalObj.userInfo.nickName;
    
}
- (void)goToLastPage
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
/**
 *  播放完毕,当调用[self.mediaPlayer stop] 时也会触发该方法
 */
- (void)mediaDidFinish:(NSNotification *)notification{
    // 重新播放当前歌曲（默认）
    [self.playerView removeLink] ;
    [self.playControlView.playPauseBtn setImage:[UIImage imageNamed:@"mine_play_btn"] forState:UIControlStateNormal];//mine_play_btn

    
    //?????
    if (self.navigationController.viewControllers.count != 1) {
        [self initMoviePlayerControllerWithURL:self.musicUrl] ;
    }
}

#pragma mark - 自定义UI
- (void)customUI
{
    // 0. 设置背景图片
    UIImageView *bgImageView = [[UIImageView alloc] init] ; // WithFrame:CGRectMake(0, TRANSFER_SIZE(64), SCREENWIDTH, SCREENHEIGHT)] ;
    UIImage *image = [UIImage imageNamed:@"player_bg_1"] ;
    bgImageView.image = image ;
    [self.view addSubview:bgImageView] ;
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgImageView.superview) ;
    }] ;
    self.bgImageView = bgImageView ;
}

- (void)customBottomUI
{
    // 1. 创建底部头像view
    CGFloat bottomViewH = TRANSFER_SIZE(52) ;
    CGFloat bottomHeadViewY = SCREENHEIGHT - bottomViewH ;
    CSBottomHeadView *bottomHeadView = [[CSBottomHeadView alloc] initWithFrame:CGRectMake(0, bottomHeadViewY, SCREENWIDTH, bottomViewH)] ;
    bottomHeadView.delegate = self ;
    [self.view addSubview:bottomHeadView] ;
    self.bottomHeadView = bottomHeadView ;
    
    self.bottomHeadView.praiseBlock =^(NSNumber * count){
        self.praiseBlock(count);
    };
    // 2. 创建用户信息view
    CGFloat descViewH = bottomViewH ;
    CGFloat desvViewY = bottomHeadViewY - bottomViewH - 1 ;
    CSUserDescView *descView = [[CSUserDescView alloc] initWithFrame:CGRectMake(0, desvViewY , SCREENWIDTH, descViewH)] ;
    descView.delegate = self ;
    [self.view addSubview:descView ] ;
    self.descView = descView ;
    
    // 3. 创建播放控件view
    CGFloat playControlViewH = TRANSFER_SIZE(55) ;
    CGFloat playControlViewY = desvViewY - playControlViewH ;
    CSPlayControlView *playControlView = [[CSPlayControlView alloc] initWithFrame:CGRectMake(0, playControlViewY, SCREENWIDTH, playControlViewH)] ;
    playControlView.delegate = self ;

    [self.view addSubview:playControlView] ;
    _playControlView = playControlView;
    
    
    // 4. 创建播放器view
    CGFloat playerViewH = SCREENHEIGHT - bottomViewH - descViewH - playControlViewH - TRANSFER_SIZE(64) ;
    CSPlayerView *playerView = [[CSPlayerView alloc] initWithFrame:CGRectMake(0, TRANSFER_SIZE(64), SCREENWIDTH, playerViewH)] ;
    [self.view addSubview:playerView] ;
    self.playerView = playerView ;
//    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(playerView.superview) ;
//        make.height.mas_equalTo(playerViewH) ;
//    }] ;
}

- (void)refreashData:(NSNotification*)nsnotificaton
{
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId];
    if (self.mediaPlayer.playableDuration>0) {//断网前已经开播
        
    }else{//断网时还没有开播
        // 初始化媒体播放器
        [self initMoviePlayerControllerWithURL:self.musicUrl] ;
    }
    self.isNetWorking = YES;
}

#pragma mark - 监听
- (void)networkReachability
{
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
    [super networkReachability];
}

#pragma mark - 数据请求
- (void)asyncGetPlayerDataByDiscoveryId:(NSString *)discoveryId{
    [[CSDataService sharedInstance] asyncGetDiscoveryPlayerDataByDiscoveryId:discoveryId handler:^(CSPlayingModel *playerData) {
        // 传递模型设置数据
        self.bottomHeadView.discoverId = self.discoveryId ;
        self.descView.playerModel = playerData ;
        self.bottomHeadView.playerModel = playerData ;
        self.shareContent = [NSString stringWithFormat:@"小伙们，赶紧来听听%@ 唱的《%@》吧，TA马上就要变成歌神啦！你还在等什么，赶快来挑战吧！", playerData.userName, playerData.songName];
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
                    NSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享微信好友成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享微信好友失败！"];
                }
            }] ;
            break ;
        case CSShareCategoryTimeLine:
            // friends
//            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
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
                    NSLog(@"分享成功！");
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
                    NSLog(@"分享成功！");
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

#pragma mark 播放 暂停滑竿动画
#pragma mark - PlayControlViewDelegate 播放器的播放和暂停事件
- (void)playControlView:(CSPlayControlView *)playControlView playStatus:(CSPlayStatus)playStatus
{
    if (playStatus == CSPlayStatusPause) {
//        [UIView animateWithDuration:.5 animations:^{
//            [self.playerView removeLink] ;
//            [self.mediaPlayer pause] ; // 暂停播放
//            self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI/6);
            
//        }];
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
//        [UIView animateWithDuration:.5 animations:^{
//            
//            self.playerView.playerNeedleView.transform = CGAffineTransformMakeRotation(M_PI/180);
//            self.playerView.playerNeedleView.layer.anchorPoint = CGPointMake(0.5, 0.) ;
//        }];
    }
}

// 改变进度
- (void)playControlView:(CSPlayControlView *)playControlView changeProgress:(CGFloat)progressValue{
    self.mediaPlayer.currentPlaybackTime = self.mediaPlayer.duration * progressValue;
    
}

#pragma mark - BottomHeadViewDelegate 处理点赞需先登录
- (void)bottomHeadView:(CSBottomHeadView *)bottomHeadView didClickLikeBtn:(UIButton *)likeBtn
{
    CSLoginViewController *loginVC = [[CSLoginViewController alloc] init] ;
    loginVC.loginBlock = ^(BOOL success)
    {
        [self.navigationController popViewControllerAnimated:YES] ;
//        NSLog(@"loginBlock....") ;
    } ;
    [self.navigationController pushViewController:loginVC animated:YES] ;
}

- (void)bottomHeadViewDidChangePraiseState:(CSBottomHeadView *)bottomHeadView {
    [self asyncGetPlayerDataByDiscoveryId:self.discoveryId] ;
}

#pragma mark - 点击导航栏返回按钮
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    // 回复导航栏尺寸
    //    self.navigationController.navigationBar.frame = CGRectMake(0, TRANSFER_SIZE(20), SCREENWIDTH, TRANSFER_SIZE(44)) ;
    
    //    self.mediaPlayer.initialPlaybackTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"playTime"] doubleValue];
    self.navigationController.navigationBar.translucent = YES ;
    self.navigationController.navigationBar.alpha = 1 ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreashData:) name:NET_WORK_REACHABILITY object:nil];
}

- (void)dealloc
{
    CSLog(@"CSMusicPlayerViewController....dealloc...") ;
    [self deleteNotification] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 停止当前播放项
    [self.playerView removeLink];
    [self.mediaPlayer stop] ;
    [self.mediaPlayer setContentURL:nil];


}

/**
 *  删除通知
 */
- (void)deleteNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:self.mediaPlayer] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.mediaPlayer] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_REACHABILITY object:nil];
}


////////////////////////////////////////////////

- (void)resetStates {
    [self.playerView removeLink];
    [self.playControlView setPlayTime:0];
    [self.playControlView setDuration:0];
    [self.playControlView setProgress:0];
}

- (void)initMoviePlayerControllerWithURL:(NSString *)url {
    if (!self.mediaPlayer) {
        self.mediaPlayer = [[MPMoviePlayerController alloc] init];
        
        // 设置音频会话
        AVAudioSession *audioSession = [AVAudioSession sharedInstance] ;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil] ;
        
        // 设置一些属性
        self.mediaPlayer.view.backgroundColor = [UIColor clearColor] ;
        self.mediaPlayer.backgroundView.backgroundColor = [UIColor clearColor] ;
        self.mediaPlayer.controlStyle = MPMovieControlStyleNone ;
        self.mediaPlayer.view.frame = CGRectZero ;
        [self.view addSubview:self.mediaPlayer.view];
    }
    [self.mediaPlayer setContentURL:[NSURL URLWithString:url]] ;
    [self.mediaPlayer prepareToPlay];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDurationAvailableNotification)
                                                 name:MPMovieDurationAvailableNotification
                                               object:self.mediaPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:self.mediaPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.mediaPlayer];
}

- (BOOL)isPlaying {
    return self.mediaPlayer.playbackState == MPMoviePlaybackStatePlaying
    || self.mediaPlayer.playbackState == MPMoviePlaybackStateSeekingBackward
    || self.mediaPlayer.playbackState == MPMoviePlaybackStateSeekingForward;
}

- (void) monitorPlaybackTime {
    [self.playControlView setProgress:self.mediaPlayer.currentPlaybackTime / self.mediaPlayer.duration];
    [self.playControlView setDuration:self.mediaPlayer.duration];
    [self.playControlView setPlayTime:self.mediaPlayer.currentPlaybackTime];
    
    // 播放完当前视频
    if (self.mediaPlayer.duration != 0 && self.mediaPlayer.currentPlaybackTime >= self.mediaPlayer.duration - 1) {
        [self.mediaPlayer stop];
        [self resetStates];
        [self initMoviePlayerControllerWithURL:self.musicUrl];
    }
    else {
        if ([self isPlaying])
            [self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:1];
    }
}

#pragma mark - Player Notifications

- (void) handleDurationAvailableNotification {
    [self.playControlView.playPauseBtn setImage:[UIImage imageNamed:@"player_pause_icon"] forState:UIControlStateNormal];
    [self.playControlView setDuration:self.mediaPlayer.duration];
}

- (void)moviePlayerLoadStateChanged:(NSNotification*)notification {
    // Unless state is unknown, start playback
    if ([self.mediaPlayer loadState] != MPMovieLoadStateUnknown) {
        // Remove observer
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        [self.playerView addLink];
        [self.mediaPlayer play];
        [self monitorPlaybackTime];
    }
    else {
        [self.playerView removeLink];
        [self.mediaPlayer stop];
    }
}

- (void)musicPlayerPlaybackStateChanged:(NSNotification *)notification {
    if ([self.mediaPlayer playbackState] == MPMoviePlaybackStatePlaying
        || self.mediaPlayer.playbackState == MPMoviePlaybackStateSeekingBackward
        || self.mediaPlayer.playbackState == MPMoviePlaybackStateSeekingForward) {
        [self monitorPlaybackTime];
    }
    else if ([self.mediaPlayer playbackState] == MPMoviePlaybackStatePaused) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(monitorPlaybackTime) object:nil];
    }
}

@end
