//
//  CSLanguageTableViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSLanguageTableViewController.h"
#import "CSDataService.h"
#import "CSSongListTableViewController.h"
#import "CSDefine.h"
#import "CSUtil.h"
#import <MobClick.h>

@interface CSLanguageTableViewController () {
    NSInteger   _selectedIndex;
    NSArray*    _languages;
}
@end

@implementation CSLanguageTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CSUtil hideEmptySeparatorForTableView:self.tableView];
    self.tableView.rowHeight = 56 ;
    self.tableView.separatorColor = [UIColor blackColor] ;
    
    _languages = @[@"华语", @"英语", @"日语", @"韩语", @"粤语", @"闽南语", @"其他国际语言"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods 

#pragma mark = UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _languages.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CSLanguageTableViewControllerCell" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID] ;
        cell.backgroundColor =  HEX_COLOR(0x222126) ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        cell.textLabel.textColor = Color_168_168_165 ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    cell.textLabel.text = _languages[indexPath.row] ;
    return cell ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"RsCateLanguage"];//语种
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.title = _languages[indexPath.row];
    vc.type = CSSongListTableViewControllerTypeLanguage;
    vc.languageType = indexPath.row + 1;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
