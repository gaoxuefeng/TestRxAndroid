//
//  YSAutoShowView.m
//  YSAutoShowView
//
//  Created by Sen on 15/3/23.
//  Copyright (c) 2015年 Sen. All rights reserved.
//

#import "YSAutoShowView.h"
#import "YSCollectionView.h"
#import "YSCollectionViewCell.h"
#define YS_COLLECTION_VIEW_CELL @"YSCollectionViewCell"
#define CHANGE_DURATION 5.0f
#define TOTAL_SELECTION_COUNT 50
@interface YSAutoShowView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) YSCollectionView *collectionView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation YSAutoShowView

- (void)setItems:(NSArray *)items
{
    _items = items;
    if (items.count == 0) return;
    [self setupCollectionView];
    
    [self setupPageControl];
    
    [self addTimer];
    
}



- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

/**
 *  创建collectionView
 */
- (void)setupCollectionView
{
    // 创建collectionView
    YSCollectionView *collectionView = [[YSCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self collectionViewFlowLayout]];
    collectionView.autoresizesSubviews = NO;
    collectionView.autoresizingMask = UIViewAutoresizingNone;
    // 注册collectionViewCell
    [collectionView registerClass:[YSCollectionViewCell class] forCellWithReuseIdentifier:YS_COLLECTION_VIEW_CELL];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    
    _collectionView = collectionView;
}

/**
 *  创建pageControl
 */
- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.items.count;
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
}

/**
 *  创建定时器
 */
- (void)addTimer
{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:CHANGE_DURATION target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    // 创建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每个item对象宽高
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    // 设置item行与行的间距
    layout.minimumLineSpacing = 0;
    // 设置item列与列的间距
    layout.minimumInteritemSpacing = 0;
    // 设置整个layout相对上左下右的距离
    layout.sectionInset = UIEdgeInsetsZero;
    // 设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (void)nextPage
{
    // 获取当前正在显示的cell的indexpath
    NSIndexPath *currentIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
    // 创建一个新的cell的indexPath
    NSIndexPath *resetCurrentIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:TOTAL_SELECTION_COUNT * 0.5];
    
    // 滚动到指定索引的cell
    [_collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    

    
    // 判断索引+1后是否会越界,如果越界 则置0
    NSInteger newItem = resetCurrentIndexPath.item + 1;
    NSInteger newSection = resetCurrentIndexPath.section;
    if (newItem == _items.count) {
        newItem = 0;
        newSection += 1;
    }
    
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:newItem inSection:newSection];
    // 滚动到指定索引的cell
    [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(_collectionView.contentOffset.x / _collectionView.bounds.size.width + 0.5) % _items.count;
    _pageControl.currentPage = page;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return TOTAL_SELECTION_COUNT;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YS_COLLECTION_VIEW_CELL forIndexPath:indexPath];
    cell.imageUrlStr = _items[indexPath.row];
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat pageControlW = _pageControl.bounds.size.width;
    CGFloat pageControlH = _pageControl.bounds.size.height;
    CGFloat pageControlX = (self.bounds.size.width - pageControlW) * 0.5;
    CGFloat pageControlY = self.bounds.size.height - pageControlH - 10;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
}

@end
