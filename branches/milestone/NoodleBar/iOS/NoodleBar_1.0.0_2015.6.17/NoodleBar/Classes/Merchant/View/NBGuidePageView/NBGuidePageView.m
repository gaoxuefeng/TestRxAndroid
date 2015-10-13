//
//  NBGuidePageView.m
//  NoodleBar
//
//  Created by sen on 15/5/5.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBGuidePageView.h"
#import "NBCommon.h"

#define PAGE_COUNT 3

@interface NBGuidePageView() <UIScrollViewDelegate>
@property(nonatomic, weak) UIPageControl *pageControl;

@end

@implementation NBGuidePageView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UICOLOR_FROM_HEX(0xf6f6f6);
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
        scrollView.backgroundColor = HEX_COLOR(0xf6f6f6);
        [self addSubview:scrollView];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * PAGE_COUNT, SCREEN_HEIGHT);
        scrollView.pagingEnabled = YES;
        
        // 图片
        for (int i = 0; i < PAGE_COUNT; i++) {
            UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [scrollView addSubview:pageView];
            
            // 中心图片
            NSString *iconName = [NSString stringWithFormat:@"guide_%d",i+1];
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
            [pageView addSubview:iconView];
            
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(pageView);
                make.top.equalTo(pageView).offset(iPhone4?120.0:AUTOLENGTH(180.0));
            }];
//            [iconView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//            if (iPhone4) {
//                [iconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:120];
//            }else
//            {
//                [iconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:AUTOLENGTH(180)];
//            }
            
            
            UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_bg"]];
            [pageView addSubview:bgView];
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(pageView);
            }];
            
//            [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            
            // 文字
            NSString *titleName = [NSString stringWithFormat:@"guide_title_%d",i+1];
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:titleName]];
            [pageView addSubview:titleView];
            
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(pageView);
                make.top.equalTo(pageView).offset(iPhone4?20.0:AUTOLENGTH(50.0));
            }];
//            [titleView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//            if (iPhone4) {
//                [titleView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
//            }else
//            {
//                [titleView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:AUTOLENGTH(50.f)];
//            }
            
            
            if (PAGE_COUNT - 1 == i) { // 最后一页
                UIButton *exitButton = [[UIButton alloc] init];
                [exitButton setBackgroundImage:[UIImage imageNamed:@"guide_exit_btn_h"] forState:UIControlStateNormal];
                [exitButton setBackgroundImage:[UIImage imageNamed:@"guide_exit_btn"] forState:UIControlStateHighlighted];
                [pageView addSubview:exitButton];
                
                [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(pageView);
                    make.top.equalTo(iconView.mas_bottom).offset(iPhone4?30.0:AUTOLENGTH(60.));
                }];
                
//                [exitButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
//                if (iPhone4) {
//                    [exitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconView withOffset:30];
//
//                }else
//                {
//                    [exitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconView withOffset:AUTOLENGTH(60.f)];

//                }
                [exitButton addTarget:self action:@selector(exitBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        // 指示器
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = HEX_COLOR(0xbdbdbd);
        pageControl.currentPageIndicatorTintColor = HEX_COLOR(0x848484);
        _pageControl = pageControl;
        [self addSubview:pageControl];
        pageControl.numberOfPages = PAGE_COUNT;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    NBLog(@"%@",self.subviews);
    _pageControl.x = (SCREEN_WIDTH - _pageControl.width) * 0.5;
    _pageControl.y = (SCREEN_HEIGHT - _pageControl.height) - AUTOLENGTH(20);
}

- (void)exitBtnOnClick:(UIButton *)button
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:.5f animations:^{
        self.transform = CGAffineTransformMakeScale(2, 2);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(guidePageView:exitBtnDidClick:)]) {
            [self.delegate guidePageView:self exitBtnDidClick:button];
            
            // 存储这次使用的软件版本
            NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
            // 获得当前打开软件的版本号
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:VERSION_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5f);
    _pageControl.currentPage = currentPage;
}



@end
