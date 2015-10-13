//
//  CSCollectionHeaderView.m
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCollectionHeaderView.h"
#import "CSHomeActivityView.h"
#import "CSRoomBtnView.h"
#import "CSDefine.h"
#import <Masonry.h>
#import <MobClick.h>


#define BACK_IMAGE_COUNT 3

@interface CSCollectionHeaderView () <RoomBtnViewDelegate, HomeActivityViewDelegate>

/** 活动视图(分装了三个按钮) */
@property (weak, nonatomic) CSHomeActivityView *activityView ;
/** 进入房间Button */
@property (nonatomic, weak) CSRoomBtnView *roomBtnView ;
/** 背景图片 */
@property (nonatomic, weak) UIImageView *bgImage ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;
@property (nonatomic, strong) NSArray *bgImageArray ;
@property (nonatomic, strong) NSTimer *timer ;
@property (nonatomic, assign) int index ;
@end

@implementation CSCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.index = 1 ;
        [self setupSubviews] ;
    }
    
    return self ;
}

- (void)setupSubviews{
    
    // 0.背景图片
    UIImageView *bgImage = [[UIImageView alloc] init] ;
    bgImage.image = [UIImage imageNamed:@"home_img01_bg"] ;
    [self addSubview:bgImage] ;
    self.bgImage = bgImage ;
    self.bgImage.hidden = YES ;
    
    // 进入房间按钮视图
    CSRoomBtnView *roomBtnView = [[CSRoomBtnView alloc] init] ;
    roomBtnView.delegate = self ;
    [self addSubview:roomBtnView] ;
    self.roomBtnView = roomBtnView ;
    
    // 首页活动按钮视图
    CSHomeActivityView *activityView = [[CSHomeActivityView alloc] init] ;
    activityView.delegate = self ;
    [self addSubview:activityView] ;
    self.activityView = activityView ;
    
    [self addTimer] ;
    
    [self updateConstraintsIfNeeded] ;
}

- (void)updateConstraints{
    if (![self isSetupConstaint]) {
        
        WS(ws) ;
        
        [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(ws) ;
            make.top.equalTo(ws).offset(-TRANSFER_SIZE(100)) ;
        }] ;
        
        [_roomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws) ;
            make.top.equalTo(ws).offset(TRANSFER_SIZE(20)) ;
            make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, 165)) ;
        }] ;

       [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(ws) ;
           make.top.equalTo(_roomBtnView.mas_bottom);
           make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, 80)) ;
       }] ;
        
        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
    
}

- (void)setRoomBtnTitle:(NSString *)roomBtnTitle{
    _roomBtnTitle = roomBtnTitle ;
    self.roomBtnView.roomBtnTitle = roomBtnTitle ;
}
- (void)setDescInfo:(NSString *)descInfo{
    _descInfo =descInfo;
    self.roomBtnView.descInfoLabel.text =descInfo ;
}
#pragma mark - 添加计时器
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES] ;
    // 拿到当前消息循环对象使其优先处理
    [ [NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes] ;
}
#pragma mark - 移除计时器
- (void)removeTimer
{
    [self.timer invalidate] ;
    self.timer = nil ;
}

- (void)changeImage {
    if (self.index == BACK_IMAGE_COUNT) {
        self.index = 1;
    } else {
        self.index++;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"home_img0%d_bg", self.index] ;
    UIImage *image = [UIImage imageNamed:imageName] ;
    // 动画改变背景图片
    [UIView transitionWithView:_bgImage
                      duration:3.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
     
                    animations:^{
                        _bgImage.image = image;
                    }
                    completion:nil];
}

#pragma mark - RoomBtnViewDelegate
- (void)roomBtnView:(CSRoomBtnView *)roomBtnView didClickRoomBtn:(UIButton *)roomBtn{
    // 把roomBtnView传过来的roomBtn再传给CSCollectionHeaderView的代理（才是控制器）
    [MobClick event:@"HomeAddroom"];
    if ([self.delegate respondsToSelector:@selector(collectionHeaderView:didClickRoomBtn:)]) {
        [self.delegate collectionHeaderView:self didClickRoomBtn:roomBtn] ;
    }
}
#pragma mark - HomeActivityViewDelegate
- (void)homeActivityView:(CSHomeActivityView *)homeActivityView didTapViewWithType:(CSHomeActivityType)viewType{
    if ([self.delegate respondsToSelector:@selector(collectionHeaderView:didTapViewWithType:)]) {
        [self.delegate collectionHeaderView:self didTapViewWithType:viewType] ;
    }
}

// 添加动画效果
- (void)headerViewAnimateWithTimeInterval:(NSTimeInterval)interval{

    [UIView animateWithDuration:interval animations:^{
        self.bgImage.hidden = NO ;
        self.bgImage.transform = CGAffineTransformMakeTranslation(0, 100) ;
    } completion:^(BOOL finished) {
        [self.roomBtnView roomBtnViewanimateWithTimeInterval:interval] ;
    }] ;
}
@end
