//
//  CSRecordPlayView.m
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRecordPlayView.h"
#import <Masonry.h>

@interface CSRecordPlayView ()

#define TIME_LABEL_FONT [UIFont systemFontOfSize:11]
#define Left_Track_Color [UIColor colorWithRed:194/255.0 green:34/255.0 blue:125/255.0 alpha:1]

/** 播放暂停按钮 */
@property (nonatomic, weak) UIButton *playPauseBtn ;
/** 播放进度 */
@property (nonatomic, weak) UISlider *progressView ;
/** 当前播放时间 */
@property (nonatomic, weak) UILabel *currentTimeLabel ;
/** 总共播放时间 */
@property (nonatomic, weak) UILabel *totalTimeLabel ;
/** 秒定时器 */
@property (nonatomic, strong) NSTimer *timerSecond ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;

@property (nonatomic, assign) CGFloat nextSecond ;

@end

@implementation CSRecordPlayView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 播放暂停按钮
        UIButton *playPauseBtn = [[UIButton alloc] init] ;
        [playPauseBtn setImage:[UIImage imageNamed:@"mine_pause_btn"] forState:UIControlStateNormal] ;
        playPauseBtn.enabled = NO ;
        [playPauseBtn addTarget:self action:@selector(playPauseBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:playPauseBtn] ;
        self.playPauseBtn = playPauseBtn ;

        // 2. 当前播放时间
        UILabel *currentTimeLabel = [[UILabel alloc] init] ;
        currentTimeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4] ;
        currentTimeLabel.textAlignment = NSTextAlignmentCenter ;
        currentTimeLabel.text = @"00:00" ;
        currentTimeLabel.font = TIME_LABEL_FONT ;
        [self addSubview:currentTimeLabel] ;
        self.currentTimeLabel = currentTimeLabel ;
        
        // 3. 总共播放时间
        UILabel *totalTimeLabel = [[UILabel alloc] init] ;
        totalTimeLabel.font = TIME_LABEL_FONT ;
        totalTimeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4] ;
        totalTimeLabel.textAlignment = NSTextAlignmentCenter ;
        totalTimeLabel.text = @"00:00" ;
        [self addSubview:totalTimeLabel] ;
        self.totalTimeLabel = totalTimeLabel ;
        
        UISlider *progressView = [[UISlider alloc] init] ;
        // 右边轨迹颜色
        [progressView setMaximumTrackTintColor: [UIColor lightGrayColor]] ;
        // 左边轨迹颜色
        [progressView setMinimumTrackTintColor:Left_Track_Color] ;
        [progressView addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged] ;
        progressView.value = 0.0 ;
        progressView.enabled = NO ;
        [progressView setThumbImage:[UIImage imageNamed:@"mine_progress_icon"] forState:UIControlStateNormal] ;
        [self addSubview:progressView] ;
        self.progressView = progressView ;
        
        [self updateConstraintsIfNeeded] ;
    }
    return self ;
}

- (void)updateConstraints{
    if (![self isSetupConstaint]) {
        WS(ws) ;
        
        // 播放暂停按钮布局
        [_playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(TRANSFER_SIZE(23)) ;
            make.centerY.mas_equalTo(ws.centerY) ;
//            make.centerY.equalTo(ws) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(25), TRANSFER_SIZE(25))) ;
        }] ;
        
        // 当前时间布局
        [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_playPauseBtn.mas_right).offset(TRANSFER_SIZE(20)) ;
//            make.centerY.equalTo(ws) ;
            make.centerY.mas_equalTo(ws.mas_centerY) ;
//            make.size.mas_equalTo(CGSizeMake(labelSize.width + 1, labelSize.height)) ;

        }] ;
        // 总共时间布局
        [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws).offset(-TRANSFER_SIZE(20)) ;
//            make.centerY.equalTo(ws) ;
            make.centerY.mas_equalTo(ws.mas_centerY) ;
        }] ;
        
        // 进度条布局
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_currentTimeLabel.mas_right).offset(TRANSFER_SIZE(5)) ;
            make.centerY.equalTo(ws) ;
            make.right.equalTo(_totalTimeLabel.mas_left).offset(-TRANSFER_SIZE(8)) ;
        }] ;
        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
}

// 格式化返回时长
- (NSString *)formatTime:(CGFloat)time{
    NSString *formatTime = [NSString stringWithFormat:@"%02d:%02d", (int)time / 60,(int)time % 60] ;
    return formatTime ;
}

// 重写setter方法
- (void)setDuration:(double)duration{
    _duration = duration ;
    [self.progressView setMaximumValue:duration] ;
    self.totalTimeLabel.text = [self formatTime:duration] ;
}

- (void)playPauseBtnClick{
    
    static int next = 0 ;
    NSArray *imageNameArray = @[@"mine_play_btn", @"mine_pause_btn"] ;
    next = next % imageNameArray.count ;
    CSLog(@"next = %d", next) ;
    if (next == 0){  // 暂停
//        [self removeTimer] ;
        
        [_timerSecond setFireDate:[NSDate distantFuture]] ;

        // 告诉控制器暂停唱片的滚动
        if ([self.delegate respondsToSelector:@selector(recordPlayView:playStatus:)]) {
            [self.delegate recordPlayView:self playStatus:CSPlayStatusPause] ;
        }
    }else{
//        [self addTimer] ;
        [_timerSecond setFireDate:[NSDate distantPast]] ;
        if ([self.delegate respondsToSelector:@selector(recordPlayView:playStatus:)]) {
            [self.delegate recordPlayView:self playStatus:CSPlayStatusPlaying] ;
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
        button.transform = CGAffineTransformMakeScale(1.25, 1.25) ;
        [button setImage:image forState:UIControlStateNormal] ;
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformIdentity ;
    }] ;
}

- (void)changeProgress:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(recordPlayView:changeProgress:)]) {
        [self.delegate recordPlayView:self changeProgress:slider.value] ;
        self.nextSecond = slider.value ;
    }
}

#pragma mark - 添加计时器
- (void)addTimer
{
    if (_timerSecond == nil) {
        _timerSecond = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES] ;
        
        // 拿到当前消息循环对象使其优先处理
//        [ [NSRunLoop currentRunLoop] addTimer:self.timerSecond forMode:NSRunLoopCommonModes] ;
        self.playPauseBtn.enabled = YES ;
        self.progressView.enabled = YES ;
    }
}

#pragma mark - 移除计时器
- (void)removeTimer
{
    self.nextSecond = 0.0 ;
    [self.progressView setValue:0.0 animated:YES] ;
    self.currentTimeLabel.text = [self formatTime:self.nextSecond] ;
    
    [self.timerSecond invalidate] ;
    self.timerSecond = nil ;
}

- (void)updateProgress{
    [self.progressView setValue:self.nextSecond animated:YES] ;
    self.nextSecond++ ;
    self.currentTimeLabel.text = [self formatTime:self.nextSecond] ;
}

- (void)dealloc{
    CSLog(@"CSRecordPlayView........dealloc") ;
}
@end
