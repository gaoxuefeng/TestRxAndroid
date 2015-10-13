//
//  NBCartListView.m
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCartListView.h"
#import "NBCartTool.h"
#import "NBCartListCell.h"
#import "NBCommon.h"

@interface NBCartListView () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, weak) NBCartListHeaderView *cartHeaderView;
@property(nonatomic, weak) UITableView *dishList;
@end


@implementation NBCartListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        [self setupSubViews];
        
        [self addNotification];
    }
    return self;
}

- (void)setupSubViews
{
    // 头部
    NBCartListHeaderView *cartHeaderView = [NBCartListHeaderView newAutoLayoutView];
    [self addSubview:cartHeaderView];
    [cartHeaderView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, CART_HEADER_HEIGHT)];
    [cartHeaderView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [cartHeaderView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _cartHeaderView = cartHeaderView;
    
    
    // 展开区域
    UITableView *dishList = [UITableView newAutoLayoutView];
    dishList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:dishList];
    [dishList autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CART_HEADER_HEIGHT, 0, 0, 0)];
    dishList.rowHeight = CART_LIST_CELL_HEIGHT;
    dishList.delegate = self;
    dishList.dataSource = self;
    dishList.bounces = NO;
    _dishList = dishList;
}


- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChanged) name:CART_CONTENT_CHANGED object:nil];
    
}

- (void)cartChanged
{
//    NSNumber *num = notification.userInfo[@"index"];
    [self.dishList reloadData];

//    
//    if (num) {
//        [_dishList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[num integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
//    }else
//    {
//        [_dishList reloadData];
//    }

}

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
}

/**
 *  清空全部按钮点击事件
 *
 *  @param target 目标对象
 *  @param sel    执行方法
 */
- (void)cleanAllBtnaddTarget:(id)target Action:(SEL)sel
{
    [_cartHeaderView cleanAllBtnaddTarget:target action:sel];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NBCartTool dishes].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBCartListCell *cell = [NBCartListCell cellWithTableView:tableView];
    NBDishModel *model = [NBCartTool dishes][indexPath.row];
    // 最后一个 隐藏分割线
    [cell hiddenBottomDivider:(indexPath.row == [NBCartTool dishes].count - 1)];

    cell.item = model;

    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}
@end
