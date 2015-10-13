//
//  CSMyRecordViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMyRecordViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CSRecordPlayView.h"
#import "CSDefine.h"
#import "CSMyRecordCell.h"
#import <MJRefresh.h>
#import "CSDataService.h"
#import "CSMyRecordModel.h"
#import "CSUtil.h"
#import <UMSocial.h>
#import "WXApi.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"


#define Background_Color [UIColor colorWithRed:22/255.0 green:21/255.0 blue:25/255.0 alpha:1]

@interface CSMyRecordViewController () <UITableViewDataSource ,
                                        UITableViewDelegate ,
                                        MyRecordCellDelegate ,
                                        RecordPlayViewDelegate>

@property (nonatomic, weak) CSRecordPlayView *recordPlayView ;

@property (nonatomic, weak) UITableView *tableView ;
@property (nonatomic, assign)NSInteger startIndex ;
@property (nonatomic, strong) NSMutableArray *myRecords ;

/** 媒体播放器 */
@property (nonatomic, strong) MPMoviePlayerController *mediaPlayer ;

// 一些分享的信息
@property (nonatomic, copy) NSString *shareTitle ;
@property (nonatomic, copy) NSString *shareContent ;
@property (nonatomic, weak) UIImage *shareImage ;
@end

@implementation CSMyRecordViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myRecords = [NSMutableArray array] ;
    
    self.title = @"我的录音";
    self.view.backgroundColor = Background_Color ;
    self.startIndex = 0 ;
    
    // 请求数据
    [self asyncGetMyRecordsWithStartIndex:self.startIndex] ;
    
    [self setupSubViews];
    // 集成刷新控件
    [self setupRefreshView] ;
    
    // 设置分享信息
    self.shareTitle = @"潮趴汇";
    self.shareContent = @"来来来,K歌聚起来!我在潮趴汇上预订了\"宝乐迪量贩KTV(九棵松)K歌活动-<<周四聚起来>>\",诚邀各位参与!";
    self.shareImage = [UIImage imageNamed:@"share_icon"];

}

#pragma mark - 懒加载MediaPlayViewController
- (MPMoviePlayerController *)mediaPlayer{
    if (_mediaPlayer == nil) {
        // 设置音频回话
        AVAudioSession *audioSession = [AVAudioSession sharedInstance] ;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil] ;

        _mediaPlayer = [[MPMoviePlayerController alloc] init] ;
        _mediaPlayer.view.frame = CGRectZero ;
        [self.view addSubview:_mediaPlayer.view] ;
        
        // 添加通知
        [self addNotificationForPlayer] ;
        
        // 设置一些属性
        _mediaPlayer.view.backgroundColor = [UIColor clearColor] ;
        _mediaPlayer.backgroundView.backgroundColor = [UIColor clearColor] ;
        _mediaPlayer.controlStyle = MPMovieControlStyleNone ;

    }
    return _mediaPlayer ;
}
#pragma mark - Setup
- (void)setupSubViews
{
    CSRecordPlayView *recordPlayView = [[CSRecordPlayView alloc] init] ;
    recordPlayView.backgroundColor = [UIColor blackColor] ;
    recordPlayView.delegate = self ;
    [self.view addSubview:recordPlayView] ;
    self.recordPlayView = recordPlayView ;
    
    [recordPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recordPlayView.superview) ;
        make.bottom.equalTo(_recordPlayView.superview) ;
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, TRANSFER_SIZE(50))) ;
    }];
    
    // 1. 创建tableView
    UITableView *tableView = [[UITableView alloc] init] ;
    [CSUtil hideEmptySeparatorForTableView:tableView] ;
    tableView.backgroundColor = Background_Color ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.rowHeight = 75 ;

    tableView.separatorColor = [UIColor blackColor] ;
    [self.view addSubview:tableView] ;
    self.tableView = tableView ;
    
    // 添加约束
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableView.superview) ;
        make.top.equalTo(_tableView.superview).offset(TRANSFER_SIZE(0)) ;
        make.right.equalTo(_tableView.superview) ;
        make.bottom.equalTo(_recordPlayView.mas_top) ;
    }] ;
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView{
    WS(ws)   ;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws asyncGetMyRecordsWithStartIndex:ws.startIndex] ;
        [ws.tableView.footer endRefreshing] ;
    }] ;
}

#pragma mark - 初始化媒体播放器
- (void)playRecordWithUrl:(NSString *)urlStr
{
    [self.mediaPlayer prepareToPlay] ;
    NSURL *url = [NSURL URLWithString:urlStr] ;
    [self.mediaPlayer setContentURL:url] ;
    
    [self.mediaPlayer play] ;
}

#pragma mark - RecordPlayViewDelegate
- (void)recordPlayView:(CSRecordPlayView *)recordPlayView playStatus:(CSPlayStatus)playStatus{
    if (playStatus == CSPlayStatusPause) {
        [self.mediaPlayer pause] ;
    }else{
        [self.mediaPlayer play] ;
    }
}

- (void)recordPlayView:(CSRecordPlayView *)recordPlayView changeProgress:(CGFloat)progressValue{
    [self.mediaPlayer setCurrentPlaybackTime:progressValue] ;
}
#pragma mark - 为播放器添加相关通知
- (void)addNotificationForPlayer
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(durationAvailable:)
                                                 name:MPMovieDurationAvailableNotification
                                               object:nil] ;
    
    // 做好播放准备
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaDidPrepareToPlay:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil] ;
}

/**
 *  播放器时长可用通知
 */
- (void)durationAvailable:(NSNotification *)notification{
    self.recordPlayView.duration = self.mediaPlayer.duration ;
}

/**
 *  做好播放准备
 */
- (void)mediaDidPrepareToPlay:(NSNotification *)notification{
    [self.recordPlayView addTimer] ;
}


#pragma mark - 数据请求
- (void)asyncGetMyRecordsWithStartIndex:(NSInteger)stratIndex{
    
    __weak typeof(self) weakSelf = self;
    
    [[CSDataService sharedInstance] asyncGetMyRecordDataWithStartIndex:stratIndex handler:^(NSArray *myRecords) {
        // 当前用户的token不能获取录音，因为我还没有录
        // 暂时用后台提供的token先测着
//        weakSelf.startIndex += myRecords.count ;
        if (myRecords.count) {
            _startIndex += myRecords.count ;
            [weakSelf.myRecords addObjectsFromArray:myRecords] ;
            [weakSelf.tableView reloadData] ;
        }else{
            [weakSelf.tableView.footer noticeNoMoreData] ;
        }
    }] ;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myRecords.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CSMyRecordCell *cell = [CSMyRecordCell cellWithTableView:tableView] ;
    cell.delegate = self ;
    CSMyRecordModel *record = self.myRecords[indexPath.row] ;
    cell.recordModel = record ;
    
    return cell ;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    CSMyRecordModel *record = self.myRecords[indexPath.row] ;
    self.recordPlayView.duration = [record.duration doubleValue] ;
    [self playRecordWithUrl:record.recordUrl] ;
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.recordPlayView removeTimer] ;

    [self.mediaPlayer stop] ;
}

#pragma mark - MyRecordCellDelegate 处理分享
- (void)myRecordCell:(CSMyRecordCell *)myRecordcell didSelectShareBtnIndex:(NSInteger)index{
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
            [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle ;
            [UMSocialData defaultData].extConfig.qqData.url = @"http://www.baidu.com";
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享QQ成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享微QQ失败！"];
                }
            }];
            CSLog(@"qq share") ;
        }
            // QQ
            break ;
        case CSShareCategoryWeibo:
            // sinaWeibo
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
    /*switch (index) {
        case CSShareCategoryCancel:
            // cancel
            CSLog(@"click cancel") ;
            break;
        case CSShareCategoryWechat:
            // wechat
            CSLog(@"wechat") ;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:self.shareImage location:nil urlResource:nil completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享微信好友成功") ;
                }
            }] ;
            
            break ;
        case CSShareCategoryTimeLine:
            // friends
            CSLog(@"player_friends") ;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享朋友圈成功") ;
                }
            }] ;
            break ;
        case CSShareCategoryQQ:{
            // QQ
            [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle ;
            [UMSocialData defaultData].extConfig.qqData.url = @"http://www.baidu.com";
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享QQ成功！");
                }
            }];
            CSLog(@"qq share") ;
        }
            break ;
        case CSShareCategoryWeibo:
            // sinaWeibo
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                //                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享sina微博成功！");
                }
            }];
            
            CSLog(@"player_weibo_icon") ;
            break ;
        default:
            break;
    }*/

}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.viewControllers.count == 1) {
        // 只有回到发现页面时才销毁
        // 销毁子视图中的timer
        [self.recordPlayView removeTimer];
        
        // 停止当前播放项
        [self.mediaPlayer stop] ;
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [self deleteNotification] ;
}

/**
 *  删除通知
 */
- (void)deleteNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:self.mediaPlayer] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.mediaPlayer] ;
}

@end
