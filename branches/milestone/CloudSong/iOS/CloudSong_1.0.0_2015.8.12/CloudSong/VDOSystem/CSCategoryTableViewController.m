//
//  CSCategoryTableViewController.m
//  CloudSong
//
//  Created by 汪辉 on 15/8/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCategoryTableViewController.h"
#import "CSCategoryTableViewCell.h"
#import "CSSongListTableViewController.h"
#import "CSSongCategoryItem.h"
#import "CSDataService.h"
#import <MJExtension.h>
#import "CSDefine.h"
#import <MobClick.h>

@interface CSCategoryTableViewController ()
{
    NSMutableArray* _category;

}
@end

@implementation CSCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = HEX_COLOR(0x1d1c21);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _category = [NSMutableArray array];
    self.title = @"分类";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self asyncGetCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)asyncGetCategory {
    [[CSDataService sharedInstance] asyncGetSongCategoriesWithHandler:^(NSArray *songs) {
        [_category removeAllObjects];
        [_category addObjectsFromArray:songs];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _category.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"CategoryCell";
    CSCategoryTableViewCell *categoryCell = (CSCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (categoryCell == nil)
    {
        categoryCell= (CSCategoryTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"CSCategoryTableViewCell" owner:self options:nil] firstObject];
    }
    categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    categoryCell.category =_category[indexPath.row];
    return categoryCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 97;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"RsCateCate"];
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.type = CSSongListTableViewControllerTypeCategory;
    vc.categoryType = indexPath.row;
    CSSongCategoryItem *item = _category[indexPath.row];
    vc.title = item.listTypeName;
    [self.navigationController pushViewController:vc animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
