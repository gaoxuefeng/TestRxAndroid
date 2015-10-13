//
//  CSLaunchWindow.m
//  CloudSong
//
//  Created by sen on 8/18/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSLaunchWindow.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSGuidePageViewController.h"

@interface CSLaunchWindow ()
@property(weak, nonatomic) UIImageView *launchImageView;
@property(weak, nonatomic) UIImageView *launchLogoView;

@end


@implementation CSLaunchWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = NO;
        self.windowLevel = UIWindowLevelNormal + 1;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSString *imageName = nil;
        CGFloat offsetY = 0;
        CGFloat offsetX = 0;
        if (iPhone4) {
            imageName = @"start_window_4";
            offsetY = -30;
            offsetX = 5;
        }else if (iPhone5)
        {
            imageName = @"start_window_5";
            offsetY = -39;
            offsetX = 2;
        }else if (iPhone6)
        {
            imageName = @"start_window_6";
            offsetY = -67.5;
            offsetX = 9;
        }else if (iPhone6Plus)
        {
            imageName = @"start_window_6p";
            offsetY = -63;
            offsetX = 6.5;
        }
        UIImageView *launchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        [self addSubview:launchImageView];
        
        UIImageView *launchLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_logo"]];
        [self addSubview:launchLogoView];
        
        [launchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(launchImageView.superview);
        }];
        
        
        [launchLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(launchLogoView.superview).offset(offsetX);
            make.centerY.equalTo(launchLogoView.superview).offset(offsetY);
        }];
        
        
        _launchImageView = launchImageView;
        _launchLogoView = launchLogoView;
        
        [self setupAnimation];
    }
    return self;
}


- (void)setupAnimation
{
    
    
    CABasicAnimation *launchSacleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    launchSacleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    launchSacleAnimation.toValue = [NSNumber numberWithFloat:1.6];
    CABasicAnimation *launchAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    launchSacleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    launchAlphaAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[launchSacleAnimation,launchAlphaAnimation];
    groupAnima.delegate = self;
    groupAnima.repeatCount = 1;
    groupAnima.duration = 2.0f ;
    [groupAnima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    groupAnima.removedOnCompletion = NO;
    groupAnima.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *logoAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    logoAlphaAnimation.repeatCount = 1;
    logoAlphaAnimation.duration = 2.0f ;
    logoAlphaAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [logoAlphaAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    logoAlphaAnimation.removedOnCompletion = NO;
    logoAlphaAnimation.fillMode = kCAFillModeForwards;
    
    [_launchLogoView.layer addAnimation:logoAlphaAnimation forKey:nil];
    
    [_launchImageView.layer addAnimation:groupAnima forKey: nil];
}

- (void)animationDidStart:(CAAnimation *)anim{
    // 进入引导页
    [self isShowGuidancePage] ;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    [_launchImageView.layer removeAllAnimations];
//    [self removeFromSuperview];
    [_launchImageView.layer removeAllAnimations];
    [_launchLogoView.layer removeAllAnimations];
//    [self isShowGuidancePage] ;
    self.finishBlock(YES);

}


#pragma mark - 显示引导页
- (void)isShowGuidancePage{
    NSFileManager *manager = [NSFileManager defaultManager] ;
    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] ;

    BOOL isExistFile = [manager fileExistsAtPath:[path stringByAppendingPathComponent:@"CSCacheFile.txt"]] ;
    
    if (isExistFile){
//        UITabBarController *tabBarVC =  GlobalObj.tabBarController ;
//        window.rootViewController = tabBarVC ;

    }else{ // 进入引导页面
        window.rootViewController = [[CSGuidePageViewController alloc] init] ;
        // 第一次启动程序
        [manager createFileAtPath:[path stringByAppendingPathComponent:@"CSCacheFile.txt"] contents:nil attributes:nil] ;
    }
}


@end
