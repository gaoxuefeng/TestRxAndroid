//
//  CSOrderDishPayDishListCell.m
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderDishPayDishListCell.h"
#import "CSDefine.h"
#import "CSOrderDishPayDishCell.h"
#import <Masonry.h>
#import "CSOrderPayCellHeaderView.h"

@interface CSOrderDishPayDishListCell ()
@property(nonatomic, weak) CSOrderPayCellHeaderView *headerView;
@property(nonatomic, strong) NSMutableArray *dishCells;
@property(nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation CSOrderDishPayDishListCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x222126);
        [self setupSubViews];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)setupSubViews
{
    CSOrderPayCellHeaderView *headerView = [[CSOrderPayCellHeaderView alloc] init];
    headerView.hiddenDivider = YES;
    headerView.title = @"订单信息";
    _headerView = headerView;
    [self addSubview:headerView];
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    _headerView.subTitle = [NSString stringWithFormat:@"共%d件",[[_items valueForKeyPath:@"@sum.amount"] intValue]];
    int itemCount = (int)items.count;
    _dishCells = [NSMutableArray arrayWithCapacity:itemCount];
    for (int i = 0; i < itemCount; i++) {
        CSOrderDishPayDishCell *dishCell = [[CSOrderDishPayDishCell alloc] initWithItem:_items[i]];
        [self addSubview:dishCell];
        [_dishCells addObject:dishCell];
    }
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(TRANSFER_SIZE(38.0));
        }];
        
        CSOrderDishPayDishCell *lastCell = nil;
        for (int i = 0; i < self.dishCells.count; i++) {
            CSOrderDishPayDishCell *cell = self.dishCells[i];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TRANSFER_SIZE(71.0));
                make.left.right.equalTo(self);
                make.top.equalTo(lastCell == nil?self.headerView.mas_bottom:lastCell.mas_bottom);
            }];
            
            if (self.dishCells.count - 1 == i) { // 最后一个
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self);
                }];
            }
            lastCell = cell;
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}
@end
