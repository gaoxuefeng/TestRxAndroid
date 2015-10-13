//
//  CSSearchViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 7/13/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSearchViewController.h"
#import "CSSearchButton.h"
#import "CSUtil.h"
#import <Masonry.h>
#import "CSSongCell.h"
#import "CSLoginViewController.h"
#import "CSQRCodeReadViewController.h"
#import "CSDataService.h"
#import "CSSingerCell.h"
#import "CSSongListTableViewController.h"
#import "SVProgressHUD.h"
#import "CSSinger.h"
#import "APService.h"
#import <MJRefresh.h>
#import "CSSong.h"
#import "CSVODAllSingingCell.h"
#import <MobClick.h>

static NSString * const kSongCellIdentifier = @"CSSongCell";
static NSString * const kSingerCellIdentifier = @"CSSingerCell";

@interface CSSearchViewController () <CSSongCellDelegate, CSQRCodeReadViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    // UI
    UISearchBar*    _searchBar;
    CSSearchButton* _songButton;
    CSSearchButton* _singerButton;
    UITableView*    _songTableView;
    UITableView*    _singerTableView;

    NSMutableArray*     _songs;
    NSMutableArray*     _singers;
    int                 _startIndexSong; // 歌曲请求标记页
    int                 _startIndexSinger ; // 歌星请求标记页
    NSInteger                 _responseCountSong ;
    NSInteger                 _responseCountSinger ;
    
    int                 _selectedIndex; // 为0：歌曲按钮被选中 ； 为1：歌星按钮被选中
    
    BOOL                _hasSearchSingers;
//    NSString*   _lastSearchKeywordSong;
//    NSString*   _lastSearchKeywordSinger;
    NSString *          _searchKeywords ; // 记录搜索栏内容（歌星、歌曲）
//    BOOL                _songRefresh;
//    BOOL                _singerRefresh;
}
@end

@implementation CSSearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarBGHidden];
    _songs = [NSMutableArray array];
    _singers = [NSMutableArray array];
    [self setupSubviews];
    
//    // 集成刷新控件
    [self setupRefreshViewForTableView:_songTableView] ;
    [self setupRefreshViewForTableView:_singerTableView] ;
    _songTableView.footer.hidden=YES;
    _singerTableView.footer.hidden=YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 集成刷新控件
- (void)setupRefreshViewForTableView:(UITableView *)tableView
{
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (tableView == _songTableView) {

            _startIndexSong += _responseCountSong ;
            [self asyncGetSongsWithKeyword:_searchBar.text startIndex:_startIndexSong] ;
        }else{
            _startIndexSinger += _responseCountSinger ;
            [self asyncGetSingersWithKeyword:_searchBar.text startIndex:_startIndexSinger] ;
        }
        
        [tableView.footer endRefreshing] ;
    }] ;
}

#pragma mark - Private Methods

- (void)setupSubviews {
//    self.view.backgroundColor = HEX_COLOR(0x1c1c20);
    
    // search bar
    _searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:_searchBar];
    _searchBar.placeholder = @"搜索";
    _searchBar.backgroundImage = [UIImage imageNamed:@"schedule_search_bg_1"];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [HEX_COLOR(0xffffff)colorWithAlphaComponent:.5];
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"schedule_search_bg_2"]
                                     forState:UIControlStateNormal];
    _searchBar.delegate = self;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchBar.superview);
        make.top.equalTo(_searchBar.superview).offset(20);
        make.right.equalTo(_searchBar.superview).offset(TRANSFER_SIZE(-56));
        make.height.mas_equalTo(TRANSFER_SIZE(44));
    }];
    
    // cancel button
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    [cancelBtn setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cancelBtn.superview);
        make.top.equalTo(cancelBtn.superview).offset(20);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(56), TRANSFER_SIZE(44)));
    }];
    
    // 歌曲 button
    _songButton = [CSSearchButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_songButton];

    [_songButton setTitle:@"歌曲"];
    [_songButton addTarget:self action:@selector(songBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_songButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_songButton.superview);
        make.top.equalTo(_searchBar.mas_bottom);
        make.width.equalTo(_songButton.superview).multipliedBy(.5);
        make.height.mas_equalTo(36);
    }];
    
    // 竖向分割线
    UIImageView *vsep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_line"]];
    [self.view addSubview:vsep];
    [vsep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_songButton.mas_right);
        make.centerY.equalTo(_songButton);
        make.size.mas_equalTo(CGSizeMake(1, TRANSFER_SIZE(24)));
    }];
    
    // 歌星 button
    _singerButton = [CSSearchButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_singerButton];

    [_singerButton setTitle:@"歌星"];
    [_singerButton addTarget:self action:@selector(singerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_singerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_songButton.mas_right);
        make.top.equalTo(_searchBar.mas_bottom);
        make.width.equalTo(_singerButton.superview).multipliedBy(.5);
        make.height.mas_equalTo(36);
    }];
    
    // 横向分隔线
    UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_durn"]];
    [self.view addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sep.superview);
        make.top.equalTo(_songButton.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    // 歌曲 TableView
    _songTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_songTableView];
    _songTableView.dataSource = self;
    _songTableView.delegate = self;
    [_songTableView registerClass:[CSSongCell class] forCellReuseIdentifier:kSongCellIdentifier];
    _songTableView.separatorColor = WhiteColor_Alpha_6;
    _songTableView.separatorInset = UIEdgeInsetsZero;
    [CSUtil hideEmptySeparatorForTableView:_songTableView];
    _songTableView.backgroundColor = [UIColor clearColor];
    [_songTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_songTableView.superview);
        make.top.equalTo(sep.mas_bottom);
    }];
    
    // 歌星 TableView
    _singerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_singerTableView];
    _singerTableView.dataSource = self;
    _singerTableView.delegate = self;
    _singerTableView.hidden = YES;
    [_singerTableView registerClass:[CSSingerCell class] forCellReuseIdentifier:kSingerCellIdentifier];
    _singerTableView.separatorColor = WhiteColor_Alpha_6;
    _singerTableView.separatorInset = UIEdgeInsetsZero;
    [CSUtil hideEmptySeparatorForTableView:_singerTableView];
    _singerTableView.backgroundColor = [UIColor clearColor];
    [_singerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_singerTableView.superview);
        make.top.equalTo(sep.mas_bottom);
    }];
    
    
    if (_isSong) {
        _selectedIndex=0;
        [_searchBar resignFirstResponder];
        [_singerButton setSelectedState:NO];
        [_songButton setSelectedState:YES];
        // 改变tableView的状态
        _songTableView.hidden = NO;
        _singerTableView.hidden = YES;
    }else{
        _selectedIndex = 1;
        [_searchBar resignFirstResponder];
        // 改变button状态
        [_songButton setSelectedState:NO];
        [_singerButton setSelectedState:YES];
        // 改变tableView的状态
        _songTableView.hidden = YES;
        _singerTableView.hidden = NO;
    }
    
}

- (void)asyncGetSongsWithKeyword:(NSString *)keyword startIndex:(int)startIndex {
    [[CSDataService sharedInstance] asyncSearchSongsWithKeyword:keyword
                                                     startIndex:startIndex
                                                        handler:^(NSArray *songs) {
                                                            _responseCountSong = songs.count ;
                                                            CSLog(@"responseDataCount = %ld, keyword = %@", (long)_responseCountSong, keyword) ;
                                                            _songTableView.footer.hidden= _responseCountSong ? NO : YES;
                                                            if (_responseCountSong < 30) {
                                                                
                                                                [_songTableView.footer noticeNoMoreData];
                                                            }else{
                                                                [_songTableView.footer resetNoMoreData];

                                                            }
                                                            [_songs addObjectsFromArray:songs];
                                                            [_songTableView reloadData];
                                                        }];
}

- (void)asyncGetSingersWithKeyword:(NSString *)keyword startIndex:(int)startIndex {
    [[CSDataService sharedInstance] asyncSearchSingersWithKeyword:keyword
                                                       startIndex:startIndex
                                                          handler:^(NSArray *songs) {
                                                              _hasSearchSingers = YES;
                                                              _responseCountSinger = songs.count ;
                                                              CSLog(@"responseDataCount = %ld, keeword = %@", (long)_responseCountSinger, keyword) ;
                                                              _singerTableView.footer.hidden= _responseCountSinger ? NO : YES;
                                                              if (_responseCountSinger < 30) {
                                                                  [_singerTableView.footer noticeNoMoreData];
                                                              }else{
                                                                  [_singerTableView.footer resetNoMoreData];

                                                              }
                                                              [_singers addObjectsFromArray:songs];
                                                              [_singerTableView reloadData];
                                                          }];
}

#pragma mark - Action Methods

- (void)cancelBtnPressed:(id)sender {
    [_searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)songBtnPressed:(id)sender {
    if (_selectedIndex != 0) {
        _selectedIndex = 0;
        [_searchBar becomeFirstResponder];
        // 改变button状态
        [_singerButton setSelectedState:NO];
        [_songButton setSelectedState:YES];
        // 改变tableView的状态
        _songTableView.hidden = NO;
        _singerTableView.hidden = YES;

        _songTableView.delegate=self;
        _songTableView.dataSource=self;
        [_songTableView reloadData];
        _singerTableView.delegate=nil;
        _singerTableView.delegate=nil;
        // 如果keyword有变化，而且长度大于0，需要查询数据
        if (![_searchKeywords isEqualToString:_searchBar.text]) {
            _searchKeywords = _searchBar.text;
            if (_searchKeywords.length > 0) {
                [_songs removeAllObjects];
                _startIndexSong = 0;
                [self asyncGetSongsWithKeyword:_searchKeywords startIndex:_startIndexSong];
            }
        }
    }
}

- (void)singerBtnPressed:(id)sender {
    if (_selectedIndex != 1) {
        _selectedIndex = 1;
        [_searchBar becomeFirstResponder];
        // 改变button状态
        [_songButton setSelectedState:NO];
        [_singerButton setSelectedState:YES];
        // 改变tableView的状态
        _songTableView.hidden = YES;
        _singerTableView.hidden = NO;
        
        _songTableView.delegate=nil;
        _songTableView.dataSource=nil;
        _singerTableView.delegate=self;
        _singerTableView.delegate=self;
        [_singerTableView reloadData];

        // 如果keyword有变化，而且长度大于0，需要查询数据
        if (![_searchKeywords isEqualToString:_searchBar.text]) {
            _searchKeywords = _searchBar.text;
            if (_searchKeywords.length > 0) {
                [_singers removeAllObjects];
                _startIndexSinger = 0;
                [self asyncGetSingersWithKeyword:_searchKeywords startIndex:_startIndexSinger];
            }
        }
    }
}

#pragma mark - CSSongCellDelegate

- (void)songCell:(CSSongCell *)cell didSelectSong:(CSSong *)song {
//    // 如果没登录，先登录
//    if (![[GlobalVar sharedSingleton] isLogin]) {
//        CSLoginViewController *vc = [[CSLoginViewController alloc] init];
//        vc.loginBlock = ^(BOOL loginSuccess){
//            [self.navigationController popViewControllerAnimated:YES];
//            if (loginSuccess) {
//                // 登陆成功，如果此时没绑定的话，自动跳到帮定界面
//                if (![[GlobalVar sharedSingleton] isBinding]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                    message:@"暂未绑定包厢,是否扫描绑定"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"否"
//                                                          otherButtonTitles:@"是", nil];
//                    [alert show];
//                }
//            }
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    // 如果没绑定包厢，先绑定包厢
//    else if (![[GlobalVar sharedSingleton] isBinding]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"暂未绑定包厢,是否扫描绑定"
//                                                       delegate:self
//                                              cancelButtonTitle:@"否"
//                                              otherButtonTitles:@"是", nil];
//        [alert show];
//    }
//    else
    
    NSIndexPath *indexPath = [_songTableView indexPathForCell:cell];
    
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
    if (![array containsObject:song.songId]) {
        
        [[CSDataService sharedInstance] asyncSelectSong:song forcely:@"false" handler:^(BOOL success) {
            UIButton * button = nil;
            CSSongCell *cell = (CSSongCell*)[_songTableView cellForRowAtIndexPath:indexPath];
            for (id obj in cell.contentView.subviews) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    button = obj;
                }
            }
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"点歌成功"];
                NSMutableArray * identArray = [NSMutableArray arrayWithArray:array];
                [identArray addObject:song.songId];
                NSMutableDictionary * identDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [identDic setObject:identArray forKey:roomInfo.reserveBoxId];
                NSData * identData =[NSKeyedArchiver archivedDataWithRootObject:identDic];
                [[NSUserDefaults standardUserDefaults]setObject:identData forKey:@"songIdentifier"];
                button.enabled=YES;
                button.selected=YES;
            }else{
                button.selected=NO;
                button.enabled=YES;
                [SVProgressHUD showErrorWithStatus:@"点歌失败"];

            }
        }];
    }

}

#pragma mark - CSQRCodeReadViewControllerDelegate

- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum {
    GlobalObj.centerIp = serverIP;
    CSRequest *param = [[CSRequest alloc] init];
    param.registrationId = [APService registrationID];
    param.code = code;
    param.roomNum = roomNum;
    
    // 发送请求绑定包厢
    [CSQRCodeReadHttpTool bindingRoomWithParam:param success:^(CSBindingRoomResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            GlobalObj.roomNum = roomNum;
            GlobalObj.boxIp = result.data.boxIP;
        }
        else
            [SVProgressHUD showErrorWithStatus:result.message];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [MobClick event:@"RsSearch"];
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar.text.length!=0) {
        [_searchBar resignFirstResponder];
        if (_selectedIndex == 0) { // 选中了歌曲button
            // 如果keyword有变化才进行查询
            if (![_searchKeywords isEqualToString:searchBar.text]) {
                _searchKeywords = searchBar.text;
                //            [_songs removeAllObjects];
                _startIndexSong = 0;
                [self asyncGetSongsWithKeyword:_searchBar.text startIndex:_startIndexSong];
            }
        }else { // 选中了歌星button
            // 如果keyword有变化才进行查询
            if (![_searchKeywords isEqualToString:searchBar.text]) {
                _searchKeywords = searchBar.text;
                //            [_singers removeAllObjects];
                _startIndexSinger = 0;
                [self asyncGetSingersWithKeyword:_searchBar.text startIndex:_startIndexSinger];
            }
        }
    }
}

//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    CSLog(@"replacementTextLength = %d", text.length) ;
//    if (text.length == 0) {
//        [searchBar resignFirstResponder];
//    }
//    return YES;
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if (searchBar.text.length != 0) {
        if (_selectedIndex == 0) { // 选中了歌曲button
            // 如果keyword有变化才进行查询
            //            if (!_songRefresh) {
            // 集成刷新控件
//            [self setupRefreshViewForTableView:_songTableView] ;
            //                _songRefresh=YES;
            //            }
            [_songs removeAllObjects];
            _startIndexSong = 0;
            [self asyncGetSongsWithKeyword:searchText startIndex:_startIndexSong];
//            _songTableView.footer.hidden=NO;
        }else { // 选中了歌星button
        // 如果keyword有变化才进行查询
            //            if (!_singerRefresh) {
            // 集成刷新控件
//            [self setupRefreshViewForTableView:_singerTableView] ;
            //                _singerRefresh=YES;
            //            }
            
//            _singerTableView.footer.hidden=NO ;
            
            [_singers removeAllObjects];
            _startIndexSinger = 0;
            [self asyncGetSingersWithKeyword:searchText startIndex:_startIndexSinger];
        }
    }else{
            [_singers removeAllObjects];
            [_singerTableView reloadData];
            [_songs removeAllObjects];
            [_songTableView reloadData];
    }
    _singerTableView.footer.hidden=YES;
    _songTableView.footer.hidden=YES;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_searchBar isFirstResponder])
        [_searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectedIndex == 0 && tableView == _songTableView)
        return _songs.count;
    else if (_selectedIndex == 1 && tableView == _singerTableView)
        return _singers.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndex == 0 && tableView == _songTableView) {
        CSSongCell *cell = [tableView dequeueReusableCellWithIdentifier:kSongCellIdentifier];
        if (_songs.count) {
            [cell setDataWithSong:_songs[indexPath.row]];
            cell.delegate = self;
            UILabel * numLabel = [cell.contentView.subviews objectAtIndex:0];
            NSString * numText = [NSString string];
            numText = [NSString stringWithFormat:@"%02ld",indexPath.row+1];
            numLabel.text = numText;
            NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
            NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
            UIButton * button = nil;
            for (id obj in cell.contentView.subviews) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    button = obj;
                }
            }
            if ([array containsObject:[_songs [indexPath.row] songId]]) {
                button.selected=YES;
            }else{
                button.selected=NO;
            }
        }
        cell.backgroundColor =[UIColor clearColor];
        return cell;
    }
    else if (_selectedIndex == 1 && tableView == _singerTableView) {
        CSSingerCell *cell = [tableView dequeueReusableCellWithIdentifier:kSingerCellIdentifier];
        if (_singers.count) {
            [cell setDataWithSinger:_singers[indexPath.row]];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleDefault;
        cell.backgroundColor =[UIColor clearColor];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndex==1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
        vc.isSeach=YES;
        CSSinger *singer = _singers[indexPath.row];
        vc.title = singer.singerName;
        vc.type = CSSongListTableViewControllerTypeSinger;
        vc.singerID = singer.singerId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        CSQRCodeReadViewController *codeReadVc = [[CSQRCodeReadViewController alloc] init];
        codeReadVc.delegate = self;
        [self presentViewController:codeReadVc animated:YES completion:nil];
    }
}

@end
