//
//  CSCartList.m
//  CloudSong
//
//  Created by sen on 5/26/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSCartList.h"
#import "CSDefine.h"
#import <Masonry.h>
#import "CSDishCartTool.h"
#import "CSCartDishTableViewCell.h"
#import "UIImage+Extension.h"
@interface CSCartList ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UIImageView *headerView;
@property(nonatomic, weak) UITableView *cartTableView;
@property(nonatomic, weak) UILabel *menuLabel;
@property(nonatomic, weak) UIButton *cleanCartButton;
@end

@implementation CSCartList

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupSubViews];
        [self setupNotification];
    }
    return self;
}

- (void)setupSubViews
{
    [self setupHeaderView];
    [self setupCartTableView];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cartContentChanged) name:CART_CONTENT_CHANGED object:nil];
}

- (void)setupHeaderView
{
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"wine_list_title"] resizedImage]];
    _headerView = headerView;
    headerView.userInteractionEnabled = YES;
    [self addSubview:headerView];
    
    UILabel *menuLabel = [[UILabel alloc] init];
    _menuLabel = menuLabel;
    menuLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    menuLabel.textColor = HEX_COLOR(0x4d4e54);
    menuLabel.text = @"已选菜单";
    [headerView addSubview:menuLabel];
    
    UIButton *cleanCartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cleanCartButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    cleanCartButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    cleanCartButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [cleanCartButton addTarget:self action:@selector(cleanCartBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    _cleanCartButton = cleanCartButton;
    [cleanCartButton setTitle:@"清空购物车" forState:UIControlStateNormal];
    [cleanCartButton setImage:[[UIImage imageNamed:@"wine_bin_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cleanCartButton setTitleColor:HEX_COLOR(0x59595f) forState:UIControlStateNormal];
    [headerView addSubview:cleanCartButton];
}

- (void)setupCartTableView
{
    UITableView *cartTableView = [[UITableView alloc] init];
    cartTableView.backgroundColor = HEX_COLOR(0x1d1c21);
    cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cartTableView = cartTableView;
    cartTableView.delegate = self;
    cartTableView.dataSource = self;
    cartTableView.rowHeight = CART_LIST_CELL_HEIGHT;
    [self addSubview:cartTableView];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(CART_LIST_HEADER_HEIGHT);
            make.width.equalTo(self);
        }];
        
        [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView).offset(TRANSFER_SIZE(5.0));
            make.left.equalTo(self.headerView).offset(TRANSFER_SIZE(16.0));
        }];
        
        [self.cleanCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-TRANSFER_SIZE(14.0));
            make.centerY.equalTo(self.headerView).offset(TRANSFER_SIZE(5.0));
        }];
        
        [self.cartTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        self.didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CSDishCartTool dishes].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSCartDishTableViewCell *cell = [CSCartDishTableViewCell cellWithTableView:tableView];
 
    cell.item = [CSDishCartTool dishes][indexPath.row];
    return cell;
}


#pragma mark - Touch Events
- (void)cleanCartBtnOnClick
{
    [CSDishCartTool emptyCart];
//    [self.cartTableView reloadData];
}

#pragma mark - Notification Events
- (void)cartContentChanged
{
    [self.cartTableView reloadData];
}


@end
