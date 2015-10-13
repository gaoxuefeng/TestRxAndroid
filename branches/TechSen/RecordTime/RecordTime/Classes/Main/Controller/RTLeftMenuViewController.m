//
//  RTLeftMenuViewController.m
//  RecordTime
//
//  Created by sen on 8/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "RTLeftMenuViewController.h"
#import <RESideMenu.h>
#import "RTNavigationController.h"
#import "RTCompanyViewController.h"
#import "RTHouseViewController.h"
#import "RTLogViewController.h"
static CGFloat const TableViewRowHeight = 65.0;

@interface RTLeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(weak, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *items;

@end

@implementation RTLeftMenuViewController

- (NSArray *)items
{
    if (!_items) {
        _items = @[@"公司",@"家",@"日志",@"配置",@"关于"];
    }
    return _items;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];

}

#pragma mark - Setup
- (void)setupSubviews
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.alwaysBounceVertical = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = TableViewRowHeight;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tableView.superview).offset(AUTOLENGTH(20.0));
        make.centerY.equalTo(tableView.superview).offset(AUTOLENGTH(-50.0));
        make.height.mas_equalTo(TableViewRowHeight * self.items.count);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"leftMenu";
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:26.0];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[RTNavigationController alloc] initWithRootViewController:[[RTCompanyViewController alloc] init]] animated:YES];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[RTNavigationController alloc] initWithRootViewController:[[RTHouseViewController alloc] init]] animated:YES];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[[RTNavigationController alloc] initWithRootViewController:[[RTLogViewController alloc] init]] animated:YES];
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    [self.sideMenuViewController hideMenuViewController];
}
@end
