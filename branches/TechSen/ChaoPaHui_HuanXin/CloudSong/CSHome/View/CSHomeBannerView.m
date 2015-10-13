//
//  CSHomeBannerView.m
//  CloudSong
//
//  Created by EThank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeBannerView.h"
#import "CSPageControl.h"
#import "CSDefine.h"
#import <UIImageView+WebCache.h>
#import "CSHomeAdBannerModel.h"

#define kAnimationinterval          2

@interface CSHomeBannerView () <UIScrollViewDelegate>
{
    UIScrollView    *_scrollView;
    UIPageControl   *_pageControl ;
    NSTimer         *_timer;
}
@end

@implementation CSHomeBannerView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blueColor] ;
        [self setupSubviews];
        self.userInteractionEnabled = YES;
        
        // 添加定时器
        [self addTimer] ;
    }
    return self;
}

#pragma mark - Public Methods

- (void)setImageURLs:(NSArray *)imageURLs{
    _imageURLs = imageURLs ;
    
    if (imageURLs.count == 0) {
        return;
    }
    // 只有一张图片时，不轮播
    else if (imageURLs.count == 1) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:imgView];
        imgView.userInteractionEnabled = YES ;
        // 添加轻触手势
        UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)] ;
        [imgView addGestureRecognizer:tapGestrue] ;
        
        // imageURLs是CSHomeAdBannerModel数组，
        // 取出模型设置数据
        CSHomeAdBannerModel *bannerModel = imageURLs[0] ;
        [imgView sd_setImageWithURL:[NSURL URLWithString:bannerModel.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
        _scrollView.scrollEnabled = NO;

    }
    // 多张图片时轮播
    else {
        // 最后一张图片放在最前面
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        // 取出模型设置数据
        CSHomeAdBannerModel *bannerModel = [imageURLs objectAtIndex:imageURLs.count - 1] ;

        [imgView sd_setImageWithURL:[NSURL URLWithString:bannerModel.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
        [_scrollView addSubview:imgView];
        
        int i = 1;
        // 循环取出模型
        for (CSHomeAdBannerModel *bannerModel in imageURLs) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * i, 0, self.width, self.height)];
            imgView.userInteractionEnabled = YES ;
            // 添加轻触手势
            UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)] ;
            [imgView addGestureRecognizer:tapGestrue] ;
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:bannerModel.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
            [_scrollView addSubview:imgView];
            ++ i;
        }
        
        // 第一张图片放在最后面
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * (imageURLs.count + 1), 0, self.width, self.height)];
        bannerModel= imageURLs[0] ;
        [imgView sd_setImageWithURL:[NSURL URLWithString:bannerModel.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
        [_scrollView addSubview:imgView];
        
        _scrollView.contentSize = CGSizeMake(self.width * (imageURLs.count + 2), self.height);
        [_scrollView scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:NO];
        
        _pageControl.numberOfPages = imageURLs.count ;
        [_pageControl setCurrentPage:0];
    }

}

- (void)nextImage {
    _pageControl.currentPage = (_pageControl.currentPage + 1) % _imageURLs.count;
    
    [self turnPage] ;
}

- (void)turnPage
{
    CGSize pageSize = _scrollView.frame.size;
    NSInteger page = _pageControl.currentPage; // 获取当前的page
    if (page == 0)
    {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, pageSize.width, pageSize.height) animated:NO];
        page = 0;
    }
    [_scrollView scrollRectToVisible:CGRectMake(pageSize.width * (page + 1) ,0 , pageSize.width, pageSize.height) animated:YES];
}


// action method
- (void)tapImageView{
    
//    CSLog(@"currentClickAdvertisement = %d, totalPages = %d", _pageControl.currentPage, _pageControl.numberOfPages) ;
    NSInteger index = _pageControl.currentPage ;
    if ([self.delegate respondsToSelector:@selector(homeBannerView:didSelectedAtIndex:)]) {
        [self.delegate homeBannerView:self didSelectedAtIndex:index] ;
    }
}

// 添加计时器
- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:kAnimationinterval target:self selector:@selector(nextImage) userInfo:nil repeats:YES] ;
    [ [NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes] ;
}
// 移除计时器
- (void)removeTimer{
    [_timer invalidate] ;
    _timer = nil ;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    // scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    // 初始化 pagecontrol
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, TRANSFER_SIZE(100), self.width, 1)] ;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor] ;
    [self addSubview:_pageControl];
}

#pragma mark - UIScrollViewDelegate
// TODO
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pagewidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pagewidth / (_imageURLs.count + 2)) / pagewidth) + 1;
    page --;  // 默认从第二页开始
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGSize pageSize = _scrollView.frame.size;
    // floor向下取整
    int currentPage = floor((_scrollView.contentOffset.x - pageSize.width / (_imageURLs.count + 2)) / pageSize.width) + 1;
    if (currentPage == 0)
        [_scrollView scrollRectToVisible:CGRectMake(pageSize.width * _imageURLs.count, 0, pageSize.width, pageSize.height) animated:NO];
    else if (currentPage == _imageURLs.count + 1)
        [_scrollView scrollRectToVisible:CGRectMake(pageSize.width, 0, pageSize.width, pageSize.height) animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 一旦定时器停止了，就不能再次使用
    [self removeTimer] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer] ;
}

@end
