//
//  CSVODViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 5/21/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSVODViewController.h"
#import "CSDefine.h"
#import "CSDataService.h"
#import "CSRecommendedAlbumCollectionCell.h"
#import "CSButtonItem.h"
#import "UIImageView+WebCache.h"
#import "CSSelectSongPlatformController.h"
#import "CSSelectedSongController.h"
#import "CSSongHistoryController.h"
#import "CSSearchViewController.h"
#import "CSSongListTableViewController.h"
#import "CSLoginViewController.h"
#import "CSQRCodeReadViewController.h"
#import "APService.h"
#import "CSCategoryTableViewController.h"
#import "SVProgressHUD.h"
#import "CSSingersTableViewController.h"
#import "CSLanguageTableViewController.h"
#import "CSSegmentControl.h"
#import <Masonry.h>
#import "CSSongSelectPlatformView.h"
#import "CSNavigationController.h"
#import "CSVODAllSingingCell.h"
#import "CSSong.h"
#import <MobClick.h>

#define kLoginAlertTag      1001
#define kBindingAlertTag    1002

@interface CSVODViewController () <CSSegmentControlDelegate, CSSelectSongPlatformControllerDelegate, CSQRCodeReadViewControllerDelegate, UIAlertViewDelegate, UIScrollViewDelegate> {
    CSSegmentControl*       _segmentControl;
    UIScrollView*           _scrollView;
    
    // 点歌台
    NSArray*                _buttonInfos;
    CSSelectSongPlatformController*    _platformController;

    // 已点歌曲
    CSSelectedSongController*   _selectedSongController;

    // 已唱歌曲
    CSSongHistoryController*    _historyController;
    
    NSTimer * _timer;
}
@end

@implementation CSVODViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 隐藏 NavigationBar
//    [self setNavigationBarBGHidden];

    [self setTitle:@"点歌"];
//    [self configCategoryButtons];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"room_nav_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    
    self.view.backgroundColor = HEX_COLOR(0x151417);
    
    // 点歌台
    _platformController = [[CSSelectSongPlatformController alloc] init];
    _platformController.delegate = self;
    
    // 已点歌曲
    _selectedSongController = [[CSSelectedSongController alloc] init];
    
    // 已唱歌曲
    _historyController = [[CSSongHistoryController alloc] init];
    [self setupSubviews];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self asyncGetButtonsDataFromServer];
    [_platformController refreshData];
    [self creatTimer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationUpdate:) name:SONGS_STATUS_CHANGED object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)notificationUpdate:(NSNotification * )notification{
    CSLog(@"%@",notification.object);
/*    NSDictionary * userInfoDic = notification.object;
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    if ([[userInfoDic objectForKey:@"reserveBoxId"]isEqualToString:roomInfo.reserveBoxId]) {
        if (userInfoDic) {
            NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
            NSMutableArray * identArray = [NSMutableArray arrayWithArray:array];
            int singingId =[[userInfoDic objectForKey:@"singingId"] intValue];
            [identArray removeObject:[NSNumber numberWithInt:singingId]];
            NSMutableDictionary * identDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [identDic setObject:identArray forKey:roomInfo.reserveBoxId];
            NSData * identData =[NSKeyedArchiver archivedDataWithRootObject:identDic];
            [[NSUserDefaults standardUserDefaults]setObject:identData forKey:@"songIdentifier"];
        }
    }*/
    [self refreshData];
}

- (void)creatTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)refreshData{
    [_selectedSongController refreshData];
    [_historyController refreshData];
    [_platformController refreshData];
}



#pragma mark - Private Methods

- (void)setupSubviews {
    [MobClick event:@"RSRS"];
    // 顶部的“点歌台”、“已点历史”、“点唱历史”
    _segmentControl = [[CSSegmentControl alloc] initWithTitles:@[@"点歌台", @"已点歌曲", @"点唱历史"]];
    _segmentControl.delegate = self;
    _segmentControl.backgroundColor = WhiteColor_Alpha_6;
//    _segmentControl.backgroundImage = [UIImage imageNamed:@"bg_1"];
    _segmentControl.titleColor = HEX_COLOR(0x9898a2);
    _segmentControl.selectedTitleColor = HEX_COLOR(0xff41ab);
    _segmentControl.blockColor = HEX_COLOR(0xff41ab);
    _segmentControl.blockHeight = 1;
    [self.view addSubview:_segmentControl];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_segmentControl.superview);
        make.top.equalTo(_segmentControl.superview).offset(TRANSFER_SIZE(0));
        make.height.mas_equalTo(35.0);
    }];
    
    // ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor =[UIColor clearColor];
    _segmentControl.scrollView = _scrollView;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_segmentControl.mas_bottom);
    }];
    
    // Container
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    // 横向分割线
    UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"song_line_on"]];
    [_scrollView addSubview:sep];
    sep.alpha = .55;
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sep.superview);
        make.top.equalTo(_segmentControl.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(1));
    }];
    
    // 点歌台界面
    [container addSubview:_platformController.platformView];
    _platformController.platformView.backgroundColor =[UIColor clearColor];
    [_platformController.platformView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(container);
        make.width.equalTo(self.view);
    }];
    
    // 已点歌曲
    [container addSubview:_selectedSongController.tableView];
    _selectedSongController.tableView.backgroundColor =[UIColor clearColor];
    [_selectedSongController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_platformController.platformView.mas_right);
        make.width.equalTo(self.view);
        make.top.bottom.equalTo(_selectedSongController.tableView.superview);
    }];
    
    // 已唱歌曲
    [container addSubview:_historyController.tableView];
    _historyController.tableView.backgroundColor =[UIColor clearColor];
    [_historyController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_historyController.tableView.superview);
        make.left.equalTo(_selectedSongController.tableView.mas_right);
        make.width.equalTo(self.view);
        make.right.equalTo(container);
    }];
}

- (void)loadLocalButtonData {
    CSDataService *svc = [CSDataService sharedInstance];
    _buttonInfos = [NSMutableArray arrayWithArray:[svc vodCategoryButtonItems]];
}

/**
 *  获取button数据的逻辑
        1、进入该页面时，显示本地数据
        2、异步获取服务端新数据
            2.1、如果服务端没有新数据，则结束
            2.2、如果服务端有新数据，则下载所有所需的数据，包括title和image。
        3、所有数据下载好之后，在主线程调用以下方法刷新界面
 */

//- (void)configCategoryButtons {
//    NSArray *buttons = @[_singerButton, _languageButton, _categoryButton, _newSongButton, _hotListButton];
//    for (int i = 0; i < buttons.count; ++i) {
//        CSSelectSongCategoryButton *button = buttons[i];
//        CSButtonItem *buttonItem = _buttonInfos[i];
//        [button setImage:buttonItem.image title:buttonItem.title];
//    }
//}
//
//- (void)asyncGetButtonsDataFromServer {
//    CSDataService *svc = [CSDataService sharedInstance];
//    // 下载按钮相关的数据
//    [[CSDataService sharedInstance] asyncGetVODButtonDataRefreshHandler:^(){
//        _buttonInfos = [NSMutableArray arrayWithArray:[svc vodCategoryButtonItems]];
//        [self configCategoryButtons];
//    }];
//}

#pragma mark - CSSegmentControlDelegate

- (void)selectedChanged:(NSInteger)selectedIndex {
//    if (selectedIndex != 0) {
//        // 如果没登录，先登录
//        if (![[GlobalVar sharedSingleton] isLogin]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"尚未登录，请先登录"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"登录", nil];
//            alert.tag = kLoginAlertTag;
//            [alert show];
//        }
//        // 如果没绑定包厢，先绑定包厢
//        else if (![[GlobalVar sharedSingleton] isBinding]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"暂未绑定包厢,是否扫描绑定"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"否"
//                                                  otherButtonTitles:@"是", nil];
//            [alert show];
//        }
//        else {
    if (selectedIndex == 1){
        [MobClick event:@"RsList"];
        [_selectedSongController refreshData];
    }
    else if (selectedIndex == 2){
        [MobClick event:@"RsHistory"];
        [_historyController refreshData];
    }else{
        [MobClick event:@"RSRS"];//点歌台
    }
//        }
//    }
}

#pragma mark - CSSelectSongPlatformControllerDelegate

- (void)selectSongPlatformControllerDidBeginSearach:(CSSelectSongPlatformController *)controller {
    CSSearchViewController *vc = [[CSSearchViewController alloc] init];
    vc.isSong=YES;
    CSNavigationController *nav = [[CSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)selectSongPlatformControllerDidPressSingerButton:(CSSelectSongPlatformController *)controller {
    [MobClick event:@"RsCate"];//歌曲分组类型之歌星
    [self.navigationController pushViewController:[[CSSingersTableViewController alloc] init] animated:YES];
}

- (void)selectSongPlatformControllerDidPressLanguageButton:(CSSelectSongPlatformController *)controller {
    [MobClick event:@"RsCate"];//歌曲分组类型之语种
    [self.navigationController pushViewController:[[CSLanguageTableViewController alloc] init] animated:YES];
}

- (void)selectSongPlatformControllerDidPressCategoryButton:(CSSelectSongPlatformController *)controller {
    [MobClick event:@"RsCate"];//歌曲分组类型之分类
    CSCategoryTableViewController *vc = [[CSCategoryTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSongPlatformControllerDidPressNewSongButton:(CSSelectSongPlatformController *)controller {
    [MobClick event:@"RsCate"];//歌曲分组类型之新歌
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.type = CSSongListTableViewControllerTypeNewSong;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSongPlatformControllerDidPressHotListButton:(CSSelectSongPlatformController *)controller {
    [MobClick event:@"RsCate"];//歌曲分组类型之热榜
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.type = CSSongListTableViewControllerTypeHotList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSongPlatformControllerDidPressMoreButton:(CSSelectSongPlatformController *)controller {
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.type = CSSongListTableViewControllerTypeAllSingingMore;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSongPlatformController:(CSSelectSongPlatformController *)controller didSelectSong:(CSSong *)song {
    // 如果没登陆，先登录
/*    if (![[GlobalVar sharedSingleton] isLogin]) {
        CSLoginViewController *vc = [[CSLoginViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        vc.loginBlock = ^(BOOL success) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"暂未绑定包厢,是否扫描绑定"
                                                        delegate:self
                                               cancelButtonTitle:@"否"
                                               otherButtonTitles:@"是", nil];
            [alert show];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 如果没绑定包厢，先绑定包厢
    else if (![[GlobalVar sharedSingleton] isBinding]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"暂未绑定包厢,是否扫描绑定"
                                                    delegate:self
                                           cancelButtonTitle:@"否"
                                           otherButtonTitles:@"是", nil];
        [alert show];
    }
    // 可以点歌了
    else*/
    
//        [[CSDataService sharedInstance] asyncSelectSong:song forcely:NO handler:^(BOOL success) {
//            [SVProgressHUD showSuccessWithStatus:@"点歌成功"];
//            CSVODAllSingingCell *cell = (CSVODAllSingingCell*)[controller.platformView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            
//            UIButton * but = [cell.contentView.subviews lastObject];
////            but.highlighted = but.highlighted ? NO :YES;
//            [but setImage:[UIImage imageNamed:@"song_selected_btn_press"] forState:UIControlStateHighlighted];
//            
//        }];
}
- (void)selectSongPlatformController:(CSSelectSongPlatformController *)controller didSelectIndexPath:(NSIndexPath *)indexPath Song:(CSSong *)song{
    [MobClick event:@"RsAllSing"];//大家都在唱
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    CSMyRoomInfoModel * roomInfo = GlobalObj.myRooms.firstObject;
    NSArray * array = [dic objectForKey:roomInfo.reserveBoxId];
    if (![array containsObject:song.songId]) {
        
        [[CSDataService sharedInstance] asyncSelectSong:song forcely:@"false" handler:^(BOOL success) {

            UIButton * button = nil;
            CSVODAllSingingCell *cell = (CSVODAllSingingCell*)[controller.platformView.tableView cellForRowAtIndexPath:indexPath];
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
//                [SVProgressHUD showErrorWithStatus:@"点歌失败"];
            }
            
        }];
    }


}
- (void)selectSongPlatformController:(CSSelectSongPlatformController *)controller didSelectAlbum:(CSRecommendedAlbum *)album {
    CSSongListTableViewController *vc = [[CSSongListTableViewController alloc] init];
    vc.type = CSSongListTableViewControllerTypeRecommendedAlbum;
    vc.album = album;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CSQRCodeReadViewControllerDelegate

- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum {
    GlobalObj.centerIp = serverIP;
    CSRequest *param = [[CSRequest alloc] init];
    param.registrationId = [APService registrationID];
    param.code = code;
    param.roomNum = roomNum;
    
    // 发送请求绑定包厢，目前总是失败
    [CSQRCodeReadHttpTool bindingRoomWithParam:param success:^(CSBindingRoomResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            GlobalObj.roomNum = roomNum;
            GlobalObj.boxIp = result.data.boxIP;

//            // 绑定包厢成功，如果此时是在“已点歌曲“界面，需要请求已点的歌曲数据
//            if (_segmentControl.currentIndex == 1)
//                [self showTableView:_selectedSongTableView];
//            // 绑定包厢成功，如果此时是在“已唱歌曲“界面，需要请求已唱的歌曲数据
//            else if (_segmentControl.currentIndex == 2)
//                [self showTableView:_songHistoryTableView];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma make - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        if (alertView.tag == kLoginAlertTag) {
            CSLoginViewController *vc = [[CSLoginViewController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.loginBlock = ^(BOOL success) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (success) {
                    if (![[GlobalVar sharedSingleton] isBinding]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"暂未绑定包厢,是否扫描绑定"
                                                                       delegate:self
                                                              cancelButtonTitle:@"否"
                                                              otherButtonTitles:@"是", nil];
                        [alert show];
                    }
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            CSQRCodeReadViewController *codeReadVc = [[CSQRCodeReadViewController alloc] init];
            codeReadVc.delegate = self;
            [self presentViewController:codeReadVc animated:YES completion:nil];
        }
    }
}
#pragma mark navigationMethods
- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

