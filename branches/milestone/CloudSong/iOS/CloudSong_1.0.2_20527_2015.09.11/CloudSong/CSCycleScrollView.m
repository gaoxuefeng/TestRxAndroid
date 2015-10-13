//
//  CSCycleScrollView.m
//  CloudSong
//
//  Created by youmingtaizi on 7/21/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCycleScrollView.h"
//#import <Masonry.h>
#import "CSDefine.h"
#import "CSPageControl.h"
#import <UIImageView+WebCache.h>

#define kYTNumberOfBannerItems      5
#define kAnimationinterval          2

@interface CSCycleScrollView () <UIScrollViewDelegate> {
    UIScrollView*   _scrollView;
    CSPageControl*  _pageControl;
    NSArray*        _imageURLs;
    NSTimer*        _timer;
}
@end

@implementation CSCycleScrollView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self setupSubviews];
        self.userInteractionEnabled = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:kAnimationinterval target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setImagesWithURLs:(NSArray *)imageURLs {
    _imageURLs = imageURLs;
    if (imageURLs.count == 0) {
        return;
    }
    // 只有一张图片时，不轮播
    else if (imageURLs.count == 1) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:imgView];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageURLs[0]] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
        _scrollView.scrollEnabled = NO;
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_scrollView);
//        }];
    }
    // 多张图片时轮播
    else {
        // 最后一张图片放在最前面
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageURLs[imageURLs.count - 1]] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
        [_scrollView addSubview:imgView];
        
        int i = 1;
        for (NSString *imageURL in imageURLs) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * i, 0, self.width, self.height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
            [_scrollView addSubview:imgView];
            ++ i;
        }
        
        // 第一张图片放在最后面
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * (imageURLs.count + 1), 0, self.width, self.height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageURLs[0]] placeholderImage:[UIImage imageNamed:@"schedule_scroll_default_img"]];
        [_scrollView addSubview:imgView];
        
        _scrollView.contentSize = CGSizeMake(self.width * (imageURLs.count + 2), self.height);
        [_scrollView scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:NO];
        
        _pageControl.numOfPages = imageURLs.count;
        [_pageControl setCurrentPage:0];
    }
}

- (void)runTimePage {
    _pageControl.currentPage = (_pageControl.currentPage + 1) % _imageURLs.count;
    [self turnPage];
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
    _pageControl = [[CSPageControl alloc] initWithFrame:CGRectMake(0, 110, self.width, 1)];
    [self addSubview:_pageControl];
//    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(_pageControl.superview);
//        make.bottom.equalTo(_pageControl.superview).offset(-5);
//        make.size.mas_equalTo(CGSizeMake(40, 1));
//    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
}

// TODO
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pagewidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pagewidth / (_imageURLs.count + 2)) / pagewidth) + 1;
    page --;  // 默认从第二页开始
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_timer isValid])
        [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
    CGSize pageSize = _scrollView.frame.size;
    int currentPage = floor((_scrollView.contentOffset.x - pageSize.width / (_imageURLs.count + 2)) / pageSize.width) + 1;
    if (currentPage == 0)
        [_scrollView scrollRectToVisible:CGRectMake(pageSize.width * _imageURLs.count, 0, pageSize.width, pageSize.height) animated:NO];
    else if (currentPage == _imageURLs.count + 1)
        [_scrollView scrollRectToVisible:CGRectMake(pageSize.width, 0, pageSize.width, pageSize.height) animated:NO];
}

@end
