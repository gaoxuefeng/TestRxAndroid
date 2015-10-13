//
//  CSPlayControlView.m
//  CloudSong
//
//  Created by EThank on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSPlayControlView.h"
#import "PublicMethod.h" 
#import "CSDefine.h"
#import "SVProgressHUD.h"

#define MAX_TRACK_COLOR [UIColor colorWithRed:18.0 / 255.0 green:14.0 / 255.0 blue:40.0 / 255.0 alpha:1]
#define MIN_TRACK_COLOR [UIColor colorWithRed:166.0 / 255.0 green:168.0 / 255.0 blue:178.0 / 255.0 alpha:1]

@interface CSPlayControlView ()

/** 播放模式按钮 */
@property (nonatomic, weak) UIButton *playModeBtn ;
/** 播放暂停按钮 */
//@property (nonatomic, weak) UIButton *playPauseBtn ;
/** 播放进度 */
@property (nonatomic, weak) UISlider *progressView ;
/** 当前播放时间 */
@property (nonatomic, weak) UILabel *currentTimeLabel ;
/** 总共播放时间 */
@property (nonatomic, weak) UILabel *totalTimeLabel ;
@end

@implementation CSPlayControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3] ;
        
        // 1. 播放模式按钮
        UIButton *playModeBtn = [[UIButton alloc] init] ;
        UIImage * image = nil;
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"playModeChoose"]) {
            image = [UIImage imageNamed:[userDefaults objectForKey:@"playModeChoose"]];
        }else{
            image = [UIImage imageNamed:@"player_cycle_icon"];
        }
        [playModeBtn setImage:image forState:UIControlStateNormal] ;
        [playModeBtn addTarget:self action:@selector(playModeBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:playModeBtn] ;
        self.playModeBtn = playModeBtn ;
        
        // 2. 播放暂停按钮
        UIButton *playPauseBtn = [[UIButton alloc] init] ;
        [playPauseBtn setImage:[UIImage imageNamed:@"player_pause_icon"] forState:UIControlStateNormal] ;
        [playPauseBtn addTarget:self action:@selector(playPauseBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:playPauseBtn] ;
        self.playPauseBtn = playPauseBtn ;
        
        // 3. 播放进度view
        UISlider *progressView = [[UISlider alloc] init] ;
        // 右边轨迹颜色
        [progressView setMaximumTrackTintColor:MAX_TRACK_COLOR] ;
        // 左边轨迹颜色
        [progressView setMinimumTrackTintColor:MIN_TRACK_COLOR];
        [progressView addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged] ;
        progressView.value = 0.0 ;
        
        [progressView setThumbImage:[UIImage imageNamed:@"player_progress_circle_btn"] forState:UIControlStateNormal] ;
        [self addSubview:progressView] ;
        self.progressView = progressView ;
        
        // 4. 当前播放时间
        UILabel *currentTimeLabel = [[UILabel alloc] init] ;
        currentTimeLabel.textColor = [UIColor whiteColor] ;
        currentTimeLabel.text = @"00:00" ;
        currentTimeLabel.font = [UIFont systemFontOfSize:11] ;
        [self addSubview:currentTimeLabel] ;
        self.currentTimeLabel = currentTimeLabel ;
        
        // 5. 总共播放时间
        UILabel *totalTimeLabel = [[UILabel alloc] init] ;
        totalTimeLabel.font = [UIFont systemFontOfSize:11] ;
        totalTimeLabel.textColor = [UIColor grayColor] ;
        totalTimeLabel.text = @"/ 00:00" ;
        [self addSubview:totalTimeLabel] ;
        self.totalTimeLabel = totalTimeLabel ;
    }
    return self ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 播放模式按钮frame
    CGFloat playModeBtnX = TRANSFER_SIZE(13) ;
    CGFloat playModeBtnY = TRANSFER_SIZE(30) ;
    CGFloat playModeBtnW = TRANSFER_SIZE(20) ;
    CGFloat playModeBtnH = TRANSFER_SIZE(17) ;
    self.playModeBtn.frame = CGRectMake(playModeBtnX, playModeBtnY, playModeBtnW, playModeBtnH) ;
    
    // 2. 播放暂停按钮frame
    CGFloat playPauseBtnW = TRANSFER_SIZE(25) ;
    CGFloat playPauseBtnH = TRANSFER_SIZE(25) ;
    CGFloat playPauseBtnX = SCREENWIDTH - TRANSFER_SIZE(13) - playPauseBtnW ;
    CGFloat playPauseBtnY = playModeBtnY - 5 ;
    self.playPauseBtn.frame = CGRectMake(playPauseBtnX, playPauseBtnY, playPauseBtnW, playPauseBtnH) ;
    
    // 3. 播放进度view frame
    CGFloat progressViewX = CGRectGetMaxX(self.playModeBtn.frame) + 10 ;
    CGFloat progressViewY = TRANSFER_SIZE(33);
    CGFloat progressViewW =  CGRectGetMinX(self.playPauseBtn.frame) - progressViewX - TRANSFER_SIZE(2)  ;
    CGFloat progressViewH = TRANSFER_SIZE(12) ;
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH) ;

    // 4. 当前播放时间frame
    CGFloat currentTimeW = TRANSFER_SIZE(30) ;
    CGFloat currentTimeH = TRANSFER_SIZE(15) ;
    CGFloat currentTimeX = SCREENWIDTH / 2 - currentTimeW ;
    CGFloat currentTimeY = TRANSFER_SIZE(10) ;
   
    self.currentTimeLabel.frame = CGRectMake(currentTimeX, currentTimeY, currentTimeW, currentTimeH) ;
    
    // 5. 总共播放时间frame
    CGFloat totalTimeX = CGRectGetMaxX(self.currentTimeLabel.frame) + 2 ;
    CGFloat totalTimeY = currentTimeY ;
    CGFloat totalTimeW = TRANSFER_SIZE(80) ;
    CGFloat totalTimeH = TRANSFER_SIZE(15) ;
    self.totalTimeLabel.frame = CGRectMake(totalTimeX, totalTimeY, totalTimeW, totalTimeH) ;
}

#pragma mark - 响应进度条滑动
- (void)changeProgress:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(playControlView:changeProgress:)]) {
        [self.delegate playControlView:self changeProgress:slider.value] ;
    }
}

#pragma mark - 改变播放模式（随机\循环）
- (void)playModeBtnClick
{
    static int next = 0 ;
    NSArray *imageNameArray = @[@"player_cycle_icon", @"player_cycle_one_icon", @"player_random_icon"] ;
    NSArray *hudTitle = @[@"随机播放", @"单曲循环", @"顺序播放"] ;
    // 动画切换btn图片
    next++;
    if (next == 3) {
        next = 0;
    }
    [SVProgressHUD showSuccessWithStatus:hudTitle[next]] ;
    UIImage *image = [UIImage imageNamed:imageNameArray[next]] ;
    

    [self animateChangeImageForView:self.playModeBtn withImage:image] ;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:imageNameArray[next] forKey:@"playModeChoose"];
    [userDefaults synchronize];
}

#pragma mark - 点击播放/暂停
- (void)playPauseBtnClick
{
    static int next = 0 ;
    NSArray *imageNameArray = @[@"player_play_icon", @"player_pause_icon"] ;
    next = next % imageNameArray.count ;
    if (next == 0){  // 暂停
        // 告诉控制器暂停唱片的滚动
        if ([self.delegate respondsToSelector:@selector(playControlView:playStatus:)]) {
            [self.delegate playControlView:self playStatus:CSPlayStatusPause] ;
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(playControlView:playStatus:)]) {
            [self.delegate playControlView:self playStatus:CSPlayStatusPlaying] ;
        }
    }
    
    // 动画切换btn图片
    UIImage *image = [UIImage imageNamed:imageNameArray[next++]] ;
    [self animateChangeImageForView:self.playPauseBtn withImage:image] ;
}

#pragma mark - 动态切换button图片
- (void)animateChangeImageForView:(UIButton *)button withImage:(UIImage *)image
{
    [UIView animateWithDuration:0.5 animations:^{
        button.transform = CGAffineTransformMakeScale(1.35, 1.35) ;
        [button setImage:image forState:UIControlStateNormal] ;
        
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformIdentity ;
    }] ;
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration ;
    
    // 设置播放条长度
    self.totalTimeLabel.text = [NSString stringWithFormat:@"/ %02d:%02d", (int)duration / 60, (int)duration % 60, nil];
}

- (void)setPlayTime:(NSTimeInterval)playTime {
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)playTime / 60, (int)playTime % 60, nil];
}

- (void)setProgress:(float)progress {
    [self.progressView setValue:progress];
}

@end
