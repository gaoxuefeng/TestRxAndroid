//
//  NBMenuView.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBMenuView.h"
#import "NBCommon.h"
#import "NBDishModel.h"
#import "NBMenuCategoryCell.h"
#import "NBMenuCategoryDetailCell.h"
#import "NBButton.h"
#define CATEGORY_CELL_HEIGHT 39.f
#define CATEGORY_DETAIL_CELL_HEIGHT 80.f
#define CATEGORY_LIST_WIDTH 65.f
#define CATEGORY_DETAIL_LIST_WIDTH (SCREEN_WIDTH - CATEGORY_LIST_WIDTH)
#define MOVE_OFFSET 10.f
@interface NBMenuView ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  类别列表
 */
@property(nonatomic, weak) UITableView *categoryList;
/**
 *  类别详情列表
 */
@property(nonatomic, weak) UITableView *categoryDetailList;

@property(nonatomic, strong) NSArray *categorys;

@property(nonatomic, strong) NSMutableArray *categoryDetailArray;
/**
 *  全部类别按钮
 */
@property(nonatomic, weak) UIButton *allCategoryButton;

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

/**
 *  临时数组
 */
@property(nonatomic, strong) NSMutableArray *tempDetailArray;

@property(nonatomic, assign) CGFloat beginY;

@end


@implementation NBMenuView

#pragma mark - lazyload


- (NSMutableArray *)tempDetailArray
{
    if (!_tempDetailArray) {
        _tempDetailArray = [NSMutableArray array];

    }
    return _tempDetailArray;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR(0xefefef);
        [self setupSubViews];
        [self setupNotification];
    }
    return self;
}



/**
 *  横扫手势
 *
 *  @param swipeGR
 */
- (void)swipe:(UISwipeGestureRecognizer *)swipeGR
{
 
    switch (swipeGR.direction) {
        case UISwipeGestureRecognizerDirectionUp:
        {
            if (_categoryDetailList.contentOffset.y == 0) {
                if ([self.delegate respondsToSelector:@selector(menuViewshouldMove:)]) {
                    [self.delegate menuViewshouldMove:NBMenuViewMoveTypeUp];
                }
            }
            break;
        }
        case UISwipeGestureRecognizerDirectionDown:
        {
            if (_categoryDetailList.contentOffset.y == 0){
                if ([self.delegate respondsToSelector:@selector(menuViewshouldMove:)]) {
                    [self.delegate menuViewshouldMove:NBMenuViewMoveTypeDown];
                }
            }
            break;
        }
        default:
            break;
    }
}


/**
 *  创建子控件
 */
- (void)setupSubViews
{
    // 全部按钮
    NBButton *allCategoryButton = [[NBButton alloc] init];
    
    [allCategoryButton addTarget:self action:@selector(allCategoryBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    allCategoryButton.backgroundColor = [UIColor clearColor];
    allCategoryButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [allCategoryButton setTitle:@"全部" forState:UIControlStateNormal];
    [allCategoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allCategoryButton setTitleColor:HEX_COLOR(0xeda300) forState:UIControlStateSelected];
    [allCategoryButton setBackgroundImage:[[UIImage imageNamed:@"menu_category_button_background"] resizedImage] forState:UIControlStateSelected];
    allCategoryButton.selected = YES;
    [self addSubview:allCategoryButton];
    _allCategoryButton = allCategoryButton;
    
    // 类别列表
    UITableView *categoryList = [[UITableView alloc] init];
    categoryList.showsVerticalScrollIndicator = NO;
    categoryList.backgroundColor = [UIColor clearColor];
    categoryList.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryList.rowHeight = CATEGORY_CELL_HEIGHT;
//    categoryList.bounces = NO;
    categoryList.delegate = self;
    categoryList.dataSource = self;
    [self addSubview:categoryList];
    _categoryList = categoryList;
    
    // 列表详情列表
    UITableView *categoryDetailList = [[UITableView alloc] init];
    categoryDetailList.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryDetailList.rowHeight = CATEGORY_DETAIL_CELL_HEIGHT;
    categoryDetailList.bounces = NO;
    categoryDetailList.delegate = self;
    categoryDetailList.dataSource = self;
    [self addSubview:categoryDetailList];
    _categoryDetailList = categoryDetailList;
    // 添加手势
    UISwipeGestureRecognizer *upSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    upSwipeGR.direction = UISwipeGestureRecognizerDirectionUp;
    [categoryDetailList addGestureRecognizer:upSwipeGR];
    UISwipeGestureRecognizer *downSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    downSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [categoryDetailList addGestureRecognizer:downSwipeGR];
    
    _beginY = 0;
}

- (void)setupNotification
{
    // 接收购物车操作通知,去改变列表的中菜品的数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChanged) name:CART_VIEW_OPERATE object:nil];
}

- (void)totalCategoryBtnClick
{
    [self allCategoryBtnOnClick:_allCategoryButton];
}

- (void)cartChanged
{
    [_categoryDetailList reloadData];
}

#pragma mark - Public Methods
/**
 *  全部按钮点击事件
 *
 *  @param button 全部按钮
 */
- (void)allCategoryBtnOnClick:(UIButton *)button
{
    [self.tempDetailArray removeAllObjects];
    button.selected = YES;

     [_categoryList deselectRowAtIndexPath:_selectedIndexPath animated:NO];

    // 请求全部数据
    [self.tempDetailArray addObjectsFromArray:self.categoryDetailArray];
    
    
    
    // 刷新数据
    [_categoryDetailList reloadData];
}

- (void)setDishesData:(NSMutableArray *)dishesData
{
    _dishesData = dishesData;
    // 所有分类
    _categorys = [dishesData valueForKeyPath:@"@distinctUnionOfObjects.type"];
    _categoryDetailArray = dishesData;
    [_categoryList reloadData];
    [_categoryDetailList reloadData];
    
    [self allCategoryBtnOnClick:_allCategoryButton];
}

- (void)reload
{
    [self.categoryDetailList reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat allCategoryBtnW = CATEGORY_LIST_WIDTH;
    CGFloat allCategoryBtnH = CATEGORY_CELL_HEIGHT;
    CGFloat allCategoryBtnX = 0;
    CGFloat allCategoryBtnY = 0;
    _allCategoryButton.frame = CGRectMake(allCategoryBtnX, allCategoryBtnY, allCategoryBtnW, allCategoryBtnH);
    
    CGFloat categoryListW = CATEGORY_LIST_WIDTH;
    CGFloat categoryListH = self.height - allCategoryBtnH;
    CGFloat categoryListX = 0;
    CGFloat categoryListY = allCategoryBtnH;
    _categoryList.frame = CGRectMake(categoryListX, categoryListY, categoryListW, categoryListH);
    
    CGFloat categoryDetailListW = CATEGORY_DETAIL_LIST_WIDTH;
    CGFloat categoryDetailListH = self.height;
    CGFloat categoryDetailListX = categoryListW;
    CGFloat categoryDetailListY = 0;
    _categoryDetailList.frame = CGRectMake(categoryDetailListX, categoryDetailListY, categoryDetailListW, categoryDetailListH);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _categoryList) { // 类别
        return self.categorys.count;
    }else // 类别详情
    {
        return self.tempDetailArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryList) {
        NBMenuCategoryCell *cell = [NBMenuCategoryCell cellWithTableView:tableView];
        cell.textLabel.text = self.categorys[indexPath.row];
        return cell;

    }else if(tableView == _categoryDetailList)
    {
        NBMenuCategoryDetailCell *cell = [NBMenuCategoryDetailCell cellWithTableView:tableView];
        NBDishModel *item = self.tempDetailArray[indexPath.row];
        cell.item = item;
        return cell;
    }
    return nil;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _categoryList) { // 分类列表
        _allCategoryButton.selected = NO;
        _selectedIndexPath = indexPath;
        NBMenuCategoryCell *cell = (NBMenuCategoryCell *)[tableView cellForRowAtIndexPath:indexPath];

        [self.tempDetailArray removeAllObjects];
        
        for (NBDishModel *model in self.categoryDetailArray) {
            if ([model.type isEqualToString:cell.textLabel.text]) {
                [self.tempDetailArray addObject:model];
            }
        }
        [self.categoryDetailList reloadData];
    }
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    

    // 判断是否是详情tableView
    if (scrollView != _categoryDetailList)  return;
    // 判断是否处于拉伸状态
//    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y > scrollView.contentSize.height) return;
    // 判断contentSize的height和size哪个大
    if (scrollView.contentSize.height < scrollView.size.height) return;
    CGFloat offset = MOVE_OFFSET;
    if (_beginY - scrollView.contentOffset.y < -offset) { // 导航栏需要上移
//        _beginY = scrollView.contentOffset.y;
        if ([self.delegate respondsToSelector:@selector(menuViewshouldMove:)]) {
            [self.delegate menuViewshouldMove:NBMenuViewMoveTypeUp];
        }
    } else if(_beginY - scrollView.contentOffset.y > offset) // 导航栏需要下移
    {
//        _beginY = scrollView.contentOffset.y;
        if ([self.delegate respondsToSelector:@selector(menuViewshouldMove:)]) {
            [self.delegate menuViewshouldMove:NBMenuViewMoveTypeDown];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView != _categoryDetailList)  return;
//    // 判断是否处于拉伸状态
//    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y > scrollView.contentSize.height) return;
    if (scrollView.contentSize.height < scrollView.size.height) return;
    // 如果手指离开 则重新设置起点
    _beginY = scrollView.contentOffset.y;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    NBLog(@"scrollViewWillEndDragging");
    if (scrollView != _categoryDetailList)  return;
    if (velocity.y < 0 && scrollView.contentOffset.y == 0) {
        if ([self.delegate respondsToSelector:@selector(menuViewshouldMove:)]) {
            [self.delegate menuViewshouldMove:NBMenuViewMoveTypeDown];
        }
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NBLog(@"scrollViewWillBeginDragging");
//}
//



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_VIEW_OPERATE object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}
@end
