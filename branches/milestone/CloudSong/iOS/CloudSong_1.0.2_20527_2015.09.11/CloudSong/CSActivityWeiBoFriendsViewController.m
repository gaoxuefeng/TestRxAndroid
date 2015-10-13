//
//  CSActivityWeiBoFriendsViewController.m
//  CloudSong
//
//  Created by 汪辉 on 15/8/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSActivityWeiBoFriendsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UMSocial.h>
#import "SVProgressHUD.h"

@interface CSActivityWeiBoFriendsViewController ()
{
    NSMutableArray * _friends;
    NSMutableArray * _searchFriends;
    NSArray * _searchResults;
    NSArray * _titles;
}
@end

@implementation CSActivityWeiBoFriendsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"schedule_search_bg_2"]
                                     forState:UIControlStateNormal];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [HEX_COLOR(0xffffff)colorWithAlphaComponent:.5];

    [SVProgressHUD show];
    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        CSLog(@"SnsFriends is %@",response.data);
        if (response.data) {
            
            NSMutableSet * set = [NSMutableSet set];
            NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
            _searchFriends = [NSMutableArray array];
            for (id obj in response.data) {
                NSString *hanziText = [[response.data objectForKey:obj] objectForKey:@"link_name"];
                [_searchFriends addObject:hanziText];
                
                if ([hanziText length]) {
                    NSString * firstLetter = nil;
                    NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    }
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                        CSLog(@"pinyin: %@", [[ms uppercaseString] substringToIndex:1]);
                        firstLetter = [[ms uppercaseString] substringToIndex:1];
                        [set addObject:firstLetter];
                    }
                    if ([nameDic objectForKey:firstLetter]) {
                        [[nameDic objectForKey:firstLetter] addObject:hanziText];
                    }else{
                        NSMutableArray * array = [NSMutableArray arrayWithObject:hanziText];
                        [nameDic setObject:array forKey:firstLetter];
                    }
                    
                }
                
            }
            
            NSMutableArray * titles = [NSMutableArray array];
            for (id obj in set) {
                [titles addObject:obj];
            }
            _titles = [titles sortedArrayUsingSelector:@selector(compare:)];
            _friends =[NSMutableArray array];
            for (id obj in _titles) {
                [_friends addObject:[nameDic objectForKey:obj]];
            }
            
            
            [SVProgressHUD dismiss];
            
            if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
                _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
                _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
                _tableView.sectionIndexColor =HEX_COLOR(0xee29a7);
            }
            
            [self.tableView reloadData];
            
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"获取好友列表失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if ([tableView isEqual:_tableView]) {
        return _friends.count;
    }else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([tableView isEqual:_tableView]) {
        return [_friends[section] count];
    }else
        return _searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:.5];
    if ([tableView isEqual:_tableView]) {
        cell.textLabel.text =_friends[indexPath.section][indexPath.row] ;
    }else
        cell.textLabel.text =_searchResults[indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([tableView isEqual:_tableView]) {
        return _titles;
    }else
        return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = WhiteColor_Alpha_4;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    title.textColor = [HEX_COLOR(0x9799a1) colorWithAlphaComponent:.8];
    title.text = _titles[section];
    
    [header addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(TRANSFER_SIZE(12));
        make.right.equalTo(header);
        make.top.equalTo(header);
        make.bottom.equalTo(header);
    }];
    
    if (section > 0) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"song_line_durn"];
        [header addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header);
            make.right.equalTo(header);
            make.bottom.equalTo(header);
            make.height.mas_equalTo(TRANSFER_SIZE(1));
        }];
    }
    if ([tableView isEqual:_tableView]) {

        return header;
    }else
        return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if ([tableView isEqual:_tableView]) {
        return 20;
    }else
        return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableView]) {
        self.atBlock(_friends[indexPath.section][indexPath.row]);
    }else
        self.atBlock(_searchResults[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
// 搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    CSLog(@"searchText = %@", searchText) ;
    
    if (searchText.length) {
        NSPredicate *result = [ NSPredicate predicateWithFormat : @"SELF CONTAINS[cd] %@" ,searchText];
        
        _searchResults = [_searchFriends filteredArrayUsingPredicate :result];
        [_searchTableView reloadData];
        _searchTableView.hidden=NO;
        _tableView.hidden=YES;
    }else{
    
        _searchTableView.hidden=YES;
        _tableView.hidden=NO;

    }
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
