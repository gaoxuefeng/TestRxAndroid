//
//  CSSongListTableViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSongListTableViewController.h"
#import "CSDataService.h"
#import <UIImageView+WebCache.h>
#import "CSSong.h"
#import "CSSinger.h"
#import "CSRecommendedAlbum.h"
#import "CSUtil.h"
#import "CSSongCell.h"
#import "Header.h"
#import "CSLoginViewController.h"
#import "CSQRCodeReadViewController.h"
#import <APService.h>
#import <MJRefresh.h>
#import "CSSearchViewController.h"
#import "CSNavigationController.h"
#import "CSVODAllSingingCell.h"
#import "CSSong.h"

#define ORIGINAL_INDEX  0 

@interface CSSongListTableViewController () <CSSongCellDelegate, CSQRCodeReadViewControllerDelegate, UIAlertViewDelegate> {
    NSMutableArray* _songs;
    NSInteger       _startIndex ;
    NSInteger       _responseDataCount ;
}
@end

@implementation CSSongListTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_isSeach) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(0, 0, 40, 64);
        rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [rightBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }

    [CSUtil hideEmptySeparatorForTableView:self.tableView] ;
    [self.tableView registerClass:[CSSongCell class] forCellReuseIdentifier:@"CSSongCell"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    self.tableView.backgroundColor = HEX_COLOR(0x1c1c20);
    
    _songs = [NSMutableArray array];
    if (self.title.length == 0) {
        if (self.type == CSSongListTableViewControllerTypeLanguage)
            self.title = @"语种";
        else if (self.type == CSSongListTableViewControllerTypeNewSong)
            self.title = @"新歌";
        else if (self.type == CSSongListTableViewControllerTypeHotList)
            self.title = @"热榜";
        else if (self.type == CSSongListTableViewControllerTypeAllSingingMore)
            self.title = @"大家都在唱";
        else if (self.type == CSSongListTableViewControllerTypeRecommendedAlbum)
            self.title = @"推荐专辑";
    }
    // 集成刷新控件
    [self setupRefreshView] ;
    [self.tableView.header beginRefreshing] ;
}
#pragma mark - Action Methods

- (void)searchBtnPressed {
    CSSearchViewController *vc = [[CSSearchViewController alloc] init];
    vc.isSong=YES;
    CSNavigationController *nav = [[CSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    // 根据页面类型返回数据
    [self getDataByControllerType] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    __weak UITableView *tableView = self.tableView ;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        _startIndex = ORIGINAL_INDEX ;
//        
//        [self getDataByControllerType] ;
//        // 结束刷新状态
//        [tableView.header endRefreshing] ;
//    }] ;
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _startIndex += _responseDataCount ;
        // 根据页面类型返回数据
        [self getDataByControllerType] ;
        // 结束刷新状态
        [tableView.footer endRefreshing] ;
    }] ;
}

#pragma mark - 根据页面类型返回数据
- (void)getDataByControllerType
{
    if (self.type == CSSongListTableViewControllerTypeCategory)
        [self asyncGetSongsByCategory];
    else if (self.type == CSSongListTableViewControllerTypeLanguage)
        [self asyncGetSongs];
    else if (self.type == CSSongListTableViewControllerTypeNewSong)
        [self asyncGetNewSongs];
    else if (self.type == CSSongListTableViewControllerTypeHotList)
        [self asyncGetHotLists];
    else if (self.type == CSSongListTableViewControllerTypeAllSingingMore)
        [self asyncGetAllSingingSongs];
    else if (self.type == CSSongListTableViewControllerTypeRecommendedAlbum)
        [self asyncGetRecommendedAlbumSongs];
    else if (self.type == CSSongListTableViewControllerTypeSinger)
        [self asyncGetSongsBySingerID:self.singerID];

}

#pragma mark - Private Methods
/** 点击分类详情页面的某一个分类(中国风、好声音、流行歌曲) */
- (void)asyncGetSongsByCategory {
    [[CSDataService sharedInstance] asyncGetSongsWithCategoryType:self.categoryType
                                   startIndex:_startIndex
                                      handler:^(NSArray *songs) {
                                          // 刷新tableView歌曲
                                          [self refreshTableViewSongs:songs] ;
                                      }];
}
/** 点击语言详情页面的某一个语言(华语、英语、粤语) */
- (void)asyncGetSongs {
    [[CSDataService sharedInstance] asyncGetSongsWithLanguageType:self.languageType
                                   startIndex:_startIndex
                                      handler:^(NSArray *songs) {
                                          // 刷新tableView歌曲
                                          [self refreshTableViewSongs:songs] ;
                                      }];
}

/** 获取新歌页面数据 */
- (void)asyncGetNewSongs {
    [[CSDataService sharedInstance] asyncGetSongsWithType:1 startIndex:_startIndex handler:^(NSArray *songs) {
        
        // 刷新tableView歌曲
        [self refreshTableViewSongs:songs] ;
    }];
}

/** 获取热榜页面数据 */
- (void)asyncGetHotLists {
    [[CSDataService sharedInstance] asyncGetSongsWithType:2 startIndex:_startIndex handler:^(NSArray *songs) {

        CSLog(@"asyncGetHotLists songsongsongs songssongs = %@", songs) ;
        // 刷新tableView歌曲
        [self refreshTableViewSongs:songs] ;
    }];
}

/** 获取大家都在唱(点击更多按钮)页面数据 */
- (void)asyncGetAllSingingSongs {
    [[CSDataService sharedInstance] asyncGetVODAllSingSongsType:CSDataServiceAllSingSongsTypeMore startIndex:_startIndex refreshHandler:^(NSArray *songs) {
        // 刷新tableView歌曲
        [self refreshTableViewSongs:songs] ;
    }];
}

/** 获取推荐专辑页面数据 */
- (void)asyncGetRecommendedAlbumSongs {
    [[CSDataService sharedInstance] asyncGetRecommendedAlbumSongsWithID:self.album.identifier startIndex:_startIndex handler:^(NSArray *songs) {
        // 刷新tableView歌曲
        [self refreshTableViewSongs:songs] ;
    }];
}

/** 点击某个歌星时获取该歌星唱的歌 */
- (void)asyncGetSongsBySingerID:(NSString *)singID {
    [[CSDataService sharedInstance] asyncGetSongsBySingerID:singID startIndex:_startIndex handler:^(NSArray *songs) {
        // 刷新tableView歌曲
        [self refreshTableViewSongs:songs] ;
    }];
}

#pragma mark - 刷新tableView歌曲
- (void)refreshTableViewSongs:(NSArray *)songs
{
    __weak UITableView *tableView = self.tableView ;
//    if (_startIndex == ORIGINAL_INDEX) {
//        [_songs removeAllObjects] ;
//        [_songs addObjectsFromArray:songs] ;
//        [tableView.footer resetNoMoreData] ;
//    }else{
    _responseDataCount = songs.count ;
    if (_responseDataCount < 30) {
        [tableView.footer noticeNoMoreData] ;
    }
    [_songs addObjectsFromArray:songs] ;
    
//    }
    [tableView reloadData];
}
#pragma mark - CSSongCellDelegate

- (void)songCell:(CSSongCell *)cell didSelectSong:(CSSong *)song {
    // 如果没登录，先登录
//    if (![[GlobalVar sharedSingleton] isLogin]) {
//        CSLoginViewController *vc = [[CSLoginViewController alloc] init];
//        __weak typeof(self) weakSelf = self;
//        vc.loginBlock = ^(BOOL loginSuccess){
//            [weakSelf.navigationController popViewControllerAnimated:YES];
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
//        [[CSDataService sharedInstance] asyncSelectSong:song forcely:NO handler:^(BOOL success) {
//            [SVProgressHUD showSuccessWithStatus:@"点歌成功"];
//        }];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
    if (![array containsObject:song.songId]) {
        
        [[CSDataService sharedInstance] asyncSelectSong:song forcely:NO handler:^(BOOL success) {
            UIButton * button = nil;
            CSSongCell *cell = (CSSongCell*)[self.tableView cellForRowAtIndexPath:indexPath];
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

- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum
{
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
//        CSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CSSongCell";
    CSSongCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    [cell setDataWithSong:_songs[indexPath.row]];
    UILabel * numLabel = [cell.contentView.subviews objectAtIndex:0];
    NSString * numText = [NSString string];
    numText = [NSString stringWithFormat:@"%02ld",indexPath.row+1];
    numLabel.text = numText;
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
    if ([array containsObject:[_songs [indexPath.row] songId]]) {
        for (id obj in cell.contentView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button = obj;
                button.selected=YES;
            }
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
