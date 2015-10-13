//
//  CSPlayerView.m
//  CloudSong
//
//  Created by EThank on 15/6/14.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSPlayerView.h"
#import "CSDefine.h"
#import "PublicMethod.h"

@interface CSPlayerView  () <UIScrollViewDelegate>



/** 滚动view */
@property (nonatomic, weak) UIScrollView *scrollView ;

/** 唱片view */
@property (nonatomic, weak) UIImageView *recordView ;

/** 背景图片 */
@property (nonatomic, weak) UIImageView *backgroundView ;

/** Lyric View 后续版本用到 */
//@property (nonatomic, weak) UIImageView *lyricView ;

@property (nonatomic, strong) CADisplayLink *link ;

@end

@implementation CSPlayerView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI] ;
        [self configSubviewsFrame] ;
        NSLog(@"screenW = %f, screenH = %f", SCREENWIDTH, SCREENHEIGHT) ;
    }
    return self ;
}

#pragma mark - 创建相关子视图
- (void)createUI
{
    // 0. 创建一个背景图片
    UIImageView *backgroundView = [[UIImageView alloc] init] ;
    backgroundView.image = [UIImage imageNamed:@"player_record_1-1"] ;
    [self addSubview:backgroundView] ;
    self.backgroundView = backgroundView ;
    
    // 1. 滚动view
    UIScrollView *scrollView = [[UIScrollView alloc] init] ;
    scrollView.delegate = self ;
    scrollView.showsHorizontalScrollIndicator = NO ;
    scrollView.pagingEnabled = YES ;
    scrollView.backgroundColor = [UIColor clearColor] ;
    [self addSubview:scrollView] ;
    self.scrollView = scrollView ;
    
    // 2. 唱片view
    UIImageView *recordView = [[UIImageView alloc] init] ; 
    recordView.image = [UIImage imageNamed:@"player_record_2"] ;
    // 加到滚动view上
    [self.scrollView addSubview:recordView] ;
    self.recordView = recordView ;
    
    // 3. 歌词view
//    UIImageView *lyricView = [[UIImageView alloc] init] ;
//    lyricView.image = [UIImage imageNamed:@"player_needle"] ;
//    // 加到滚动view上
//    [self.scrollView addSubview:lyricView] ;
//    self.lyricView = lyricView ;
    
    // 4. 创建顶部播放杆view
    UIImageView *playerNeedleView = [[UIImageView alloc] init] ;
    playerNeedleView.image = [UIImage imageNamed:@"player_needle"] ;
    [self addSubview:playerNeedleView] ;
    self.playerNeedleView = playerNeedleView ;
    
    // 启动CADisplayLink
//    [self addLink] ;
    
}

#pragma mark - 设置子视图frame
- (void)configSubviewsFrame
{
    // 0. 背景视图frame
    CGFloat bgViewX = TRANSFER_SIZE(33) ;
    CGFloat bgViewY = TRANSFER_SIZE(51) ;
    if ([self isIphone4]) {
         bgViewX = TRANSFER_SIZE(65) ;
    }
    CGFloat bgViewWH = SCREENWIDTH - 2 * bgViewX ;
    self.backgroundView.frame = CGRectMake(bgViewX, bgViewY, bgViewWH, bgViewWH) ;
    
//     1. 滚动frame
    CGFloat scrollX = 0 ;
    CGFloat scrollY = 0 ;
    CGFloat scrollW = SCREENWIDTH ;
    CGFloat scrollH = CGRectGetMaxY(self.backgroundView.frame) ;
    self.scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH) ;
    // 该版本无需显示歌词，scrollView的无需滚动
//    self.scrollView.contentSize = CGSizeMake(1 * SCREENWIDTH, 300) ;
    
    // 2. 唱片frame
    CGFloat recordX = 0 ;
    CGFloat recordY = 0 ;
    CGFloat recordWH = bgViewWH - 10 ;
    self.recordView.frame = CGRectMake(recordX, recordY, recordWH, recordWH) ;
    self.recordView.center = self.backgroundView.center ;
    
    // 3. 歌词frame
//    CGFloat lyricY = self.recordView.frame.origin.y ;
//    CGFloat lyricWH = recordWH ;
//    self.lyricView.center = self.backgroundView.center ;
//    self.lyricView.frame = CGRectMake(SCREENWIDTH, lyricY, lyricWH, lyricWH) ;
    
    // 4. 播放杆frame
    CGFloat needleX = self.frame.size.width / 2 - 45 ;
    CGFloat needleY = -70 ;
    CGFloat needleW = TRANSFER_SIZE(87) ;
    CGFloat needleH = TRANSFER_SIZE(133) ;
    if ([self isIphone4]) {
        needleW = TRANSFER_SIZE(70) ;
        needleH = TRANSFER_SIZE(125) ;
    }
    
    self.playerNeedleView.frame = CGRectMake(needleX, needleY, needleW, needleH) ;
    
    // 设置锚点(设置锚点会改变坐标系)
    self.playerNeedleView.layer.anchorPoint = CGPointMake(0.276, 0.17) ;
}
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [UIView animateWithDuration:1.5 animations:^{
//        self.playerNeedleView.transform = CGAffineTransformMakeRotation(-M_PI_4) ;
//    }] ;
//    
//    // scrollView开始滚动时暂停
//    [self.link setPaused:YES] ;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [UIView animateWithDuration:1.0 animations:^{
//        self.playerNeedleView.transform = CGAffineTransformIdentity ;
//    }] ;
//    
//    // scrollView滚动结束时再开始
//    [self.link setPaused:NO] ;
//}

/**
 *  8秒转一圈, 45°/s
 */
- (void)update
{
    // 1/60秒 * 45
    // 规定时间内转动的角度 == 时间 * 速度
    CGFloat angle = self.link.duration * M_PI_4;
    
    self.recordView.transform = CGAffineTransformRotate(self.recordView.transform, angle) ;
    
}

- (void)removeLink
{
    [self.link invalidate] ;
    self.link = nil ;
}

- (void)addLink
{
    if (self.link == nil) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)] ;
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode] ;
    }
}

// 适配iPhone4\4s
- (BOOL)isIphone4
{
    return (SCREENWIDTH == 320.0 && SCREENHEIGHT == 480.0) ? YES : NO ;
}

- (void)dealloc
{
    CSLog(@"CSPlayerView ... Dealloc...") ;
    [self.link invalidate] ;
}


@end
