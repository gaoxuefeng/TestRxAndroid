//
//  CoverView.m
//  TeMe
//
//  Created by dyLiu on 15/3/23.
//  Copyright (c) 2015年 dyLiu. All rights reserved.
//

#import "CoverView.h"
#import "SDWebImageManager.h"
#import "CSDefine.h"
#import "BgView.h"
#import <Masonry.h>

@interface UIImageView(BWMImage)

- (void)setImageWithURLString:(NSString *)urlString placeholderImageNamed:(NSString *)placeholderImageNamed contentMode:(UIViewContentMode)contentMode;

@end

@implementation UIImageView(BWMImage)

- (void)setImageWithURLString:(NSString *)urlString placeholderImageNamed:(NSString *)placeholderImageNamed contentMode:(UIViewContentMode)contentMode
{
    self.image = [UIImage imageNamed:placeholderImageNamed];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.image = image;
        }];
//        if (imageData.length>0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.contentMode = contentMode;
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.alpha = 0.0;
//                } completion:^(BOOL finished) {
//                    if (finished) {
//                        self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
//                        self.image = [UIImage imageWithData:imageData];
//                        [UIView animateWithDuration:0.2 animations:^{
//                            self.alpha = 1.0;
//                            self.transform = CGAffineTransformIdentity;
//                        }];
//                    }
//                }];
//            });
//        }
    });
}

@end

@interface CoverView()
{
    NSTimer *_timer;
    NSTimeInterval _second;
}

@end

@implementation CoverView

- (id)initWithModels:(NSArray *)models andFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        self.models = [NSMutableArray arrayWithArray:models];
        self.animationOption = 0 << 20;
        [self createUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageViewsContentMode = UIViewContentModeScaleToFill;
        [self createUI];
    }
    return self;
}

+ (id)coverViewWithModels:(NSArray *)models andFrame:(CGRect)frame andPlaceholderImageNamed:(NSString *)placeholderImageNamed andClickdCallBlock:(void (^)(NSInteger index))callBlock
{

    CoverView *coverView = [[CoverView alloc] initWithModels:models andFrame:frame];
    coverView.placeholderImageNamed = placeholderImageNamed;
    coverView.callBlock = callBlock;
    [coverView updateView];
    return coverView;
}

// 创建UI
- (void)createUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 9, SCREENWIDTH-16, TRANSFER_SIZE(140))];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
//    _periodLab = [[UILabel alloc] initWithFrame:CGRectMake(11, self.scrollView.frame.origin.y+9, 100, TRANSFER_SIZE(20))];
//    _periodLab.font = [UIFont systemFontOfSize:13.];
//    _periodLab.textColor = [UIColor colorWithRed:1. green:1. blue:1. alpha:1.];
//    [self addSubview:_periodLab];
    
    _bgView = [[[NSBundle mainBundle] loadNibNamed:@"BgView" owner:self options:nil] lastObject];
    _bgView.frame = CGRectMake(8, self.scrollView.frame.origin.x + self.scrollView.frame.size.height - TRANSFER_SIZE(20), SCREENWIDTH-16, TRANSFER_SIZE(21));
    if (self.models.count>0) {
//        _periodLab.text = [[self.models firstObject] period].length>0?[[self.models firstObject] period]:@"";
        _bgView.listenCountLab.text = [[self.models firstObject] listenCount].integerValue>0?[[self.models firstObject] listenCount]:@"0";
        _bgView.favourCountLab.text = [[self.models firstObject] praiseCount].integerValue>0?[[self.models firstObject] praiseCount]:@"0";
    }
    [self addSubview:_bgView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = YES;
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView.mas_centerY);
        make.right.equalTo(_pageControl.superview).offset(TRANSFER_SIZE(-12));
        make.width.mas_lessThanOrEqualTo(180);
    }];
    if (self.models.count) {
        
    }else{
        _bgView.hidden = YES;
    }
}

// 更新视图
- (void)updateView
{
    _scrollView.contentSize = CGSizeMake((_models.count+2)*_scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    // 清除所有滚动视图
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.models.count>0) {
        CSFindThemeModel *model = nil;
        for (int i = 0; i<_models.count+2; i++) {
            if (i == 0) {
                model = [_models lastObject];
            } else if(i == _models.count+1) {
                model = [_models firstObject];
            } else {
                model = [_models objectAtIndex:i-1];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(self.width), 0, SCREENWIDTH-16, TRANSFER_SIZE(140))];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.tag = i-1;
            // 默认执行SDWebImage的缓存方法
            if ([imageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [imageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:[NSURL URLWithString:model.specialImgPath] withObject:[UIImage imageNamed:_placeholderImageNamed]];
            }
            else
            {
                [imageView setImageWithURLString:model.specialImgPath placeholderImageNamed:_placeholderImageNamed contentMode:_imageViewsContentMode];
            }
            //        [imageView setImageWithURLString:model.specialImgPath placeholderImageNamed:@"menu_to_pay" contentMode:_imageViewsContentMode];
            [_scrollView addSubview:imageView];
            if (i>0 &&i<_models.count+1) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
                [imageView addGestureRecognizer:tap];
            }
        }
    }else{
        _scrollView.hidden = YES;
    }
    // 设置titleLabel和pageControl的相关内容数据
    if (_models.count>0) {
        _pageControl.numberOfPages = _models.count;
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    
    // 先执行一次这个方法
    if (_scrollViewCallBlock != nil)
    {
        _scrollViewCallBlock(1);
    }
}

// 图片轻敲手势事件
- (void)imageViewClicked:(UITapGestureRecognizer *)recognizer
{
//    NSInteger sindex = 0;
    NSInteger index = recognizer.view.tag;
//    if (index == 0) {
//        sindex = index;
//    }else{
//        sindex = index;
//    }
    if (_callBlock != nil) {
        _callBlock(index);
        
    }
}

// pageControl修改事件
- (void)pageControlClicked:(UIPageControl *)pageControl
{
    [self scrollViewScrollToPageIndex:pageControl.currentPage+1];
}

// 设置自动播放
- (void)setAutoPlayWithDelay:(NSTimeInterval)second
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    _second = second;
    [self createTimer];
}
- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_second target:self selector:@selector(scrollViewAutoScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
// 暂停或开启自动播放
- (void)stopAutoPlayWithBOOL:(BOOL)isStopAutoPlay
{
    if (_timer) {
        if (isStopAutoPlay) {
            [_timer invalidate];
        } else {
//            _timer = [NSTimer scheduledTimerWithTimeInterval:_second target:self selector:@selector(scrollViewAutoScrolling) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
            [self createTimer];
        }
    }
}

// 自动滚动
- (void)scrollViewAutoScrolling
{
    CGPoint point;
    point = _scrollView.contentOffset;
    point.x += _scrollView.frame.size.width;
    [self animationScrollWithPoint:point];
}

// 滚动到指定的页面
- (void)scrollViewScrollToPageIndex:(NSInteger)page
{
    CGPoint point;
    point = CGPointMake(_scrollView.frame.size.width*page, 0);
    
    [self animationScrollWithPoint:point];
}

// 滚动到指点的point
- (void)animationScrollWithPoint:(CGPoint)point
{
    // 判断是否是需要动画
    if (_animationOption != 0 << 20) {
        _scrollView.contentOffset = point;
        [self scrollViewDidEndDecelerating:_scrollView];
        [UIView transitionWithView:_scrollView duration:0.7 options:_animationOption animations:nil completion:nil];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = point;
        }completion:^(BOOL finished) {
            if (finished) {
                [self scrollViewDidEndDecelerating:_scrollView];
            }
        }];
    }
}


- (void)setScrollViewCallBlock:(void (^)(NSInteger index))scrollViewCallBlock
{
    _scrollViewCallBlock = [scrollViewCallBlock copy];
    _scrollViewCallBlock(0);
}

#pragma mark-
#pragma mark- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止自动播放
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 设置伪循环滚动
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*scrollView.frame.size.width, 0);
        
    } else if(scrollView.contentOffset.x >= scrollView.contentSize.width-scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    
    int currentPage = scrollView.contentOffset.x/self.frame.size.width;
    if (currentPage == 0) {
        _pageControl.currentPage = [_models count];
    }else if (currentPage == [_models count]+1){
            _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage = currentPage - 1;
    }
    
    // 设置titleLabel
    if (_models.count>0) {
        if (currentPage == -1) {
            return;
        }
    }
    
    // 恢复自动播放
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_second]];
    }
    
    if(_scrollViewCallBlock != nil)
    {
        CSFindThemeModel * themeModel = nil;
        if (self.models.count>0) {
            if (currentPage == 0) {
                themeModel = [_models lastObject];
            } else if(currentPage == _models.count+1) {
//                if (offsetX <= 0) {
////                    _pageControl.currentPage = [_models count];
//                    themeModel = [_models lastObject];
//
//                }else{
////                    _pageControl.currentPage = 0;
//                    themeModel = [_models firstObject];
//                }
                themeModel = [_models firstObject];
            } else {
                themeModel = [_models objectAtIndex:currentPage-1];
            }
//            themeModel = _models[_pageControl.currentPage];
        }
        _bgView.listenCountLab.text = themeModel.listenCount.integerValue>0?themeModel.listenCount:@"0";
        _bgView.favourCountLab.text = themeModel.praiseCount.integerValue>0?themeModel.praiseCount:@"0";
//        _periodLab.text = themeModel.period.length>0?themeModel.period:@"";
        _scrollViewCallBlock(currentPage);
    }
}



@end
