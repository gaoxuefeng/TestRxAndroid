//
//  CSShopDetailViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/19/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSShopDetailViewController.h"
#import "CSCycleScrollView.h"
#import "CSKTVModel.h"
#import "CSUtil.h"
#import "CSKTVDetailAddressCell.h"
#import "CSKTVDetailBookingTimeCell.h"
#import "CSDataService.h"
#import "CSBookingTimeSelectedAlert.h"
#import "CSQueryKTVPriceItem.h"
#import "CSAvailableRoomsCell.h"
#import "CSKTVRoomItem.h"
#import "CSKTVPayViewController.h"
#import "CSKTVDetailTuangouLabelCell.h"
#import "CSKTVDetailTuangouCell.h"
#import "CSTuanGouViewController.h"
#import "CSTuanGouItem.h"
#import "CSLoginViewController.h"
#import "SVProgressHUD.h"
#import "CSKTVMapViewController.h"

#define kBackgroundHeight 164
static NSString * const addressIdentifier = @"addressIdentifier";
static NSString * const bookingTimeIdentifier = @"bookingTimeIdentifier";
static NSString * const roomTypeIdentifier = @"roomTypeIdentifier";
static NSString * const tuangouTitleIdentifier = @"tuangouTitleIdentifier";
static NSString * const tuangouIdentifier = @"tuangouIdentifier";

@interface CSShopDetailViewController () <CSBookingTimeSelectedAlertDelegte, CSAvailableRoomsCellDelegate, CSKTVDetailAddressCellDelegate, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate> {
    CSCycleScrollView*  _pagaControl;
    UITableView*        _tableView;
    NSMutableArray*     _availableRooms;
    NSMutableArray*     _tuangouShops;
    NSInteger           _duration;
    NSDate*             _startDateFromServer;
    NSDate*             _selectedDate;
}
@property(nonatomic, strong) CSKTVRoomItem *currentKTVRoomItem;

@end

@implementation CSShopDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KTV详情";
    _availableRooms = [NSMutableArray array];
    _tuangouShops = [NSMutableArray array];
    _duration = 1;
    _startDateFromServer = _selectedDate = [NSDate distantPast];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_availableRooms.count == 0) {
        [self getAvalibleRoomPrice] ;
    }
//    // 获取团购信息
//    if (_tuangouShops.count == 0) {
//        [[CSDataService sharedInstance] asyncGetTuanGouWithBLDKTVId:self.ktvItem.BLDKTVId
//                                                            handler:^(NSArray *items) {
//                                                                [_tuangouShops addObjectsFromArray:items];
//                                                                [_tableView reloadData];
//                                                            }];
//    }
}

- (void)getAvalibleRoomPrice{
    
    //  获取可用包厢的价格
    [[CSDataService sharedInstance] asyncGetKTVPriceWithBLDID:self.ktvItem.BLDKTVId
                                                          day:nil
                                                         time:nil
                                                     duration:0
                                                      handler:^(CSQueryKTVPriceItem *item) {
                                                          NSString *dateString = [NSString stringWithFormat:@"%@ %@", item.day, item.hour];
                                                          NSDate *date = [[CSUtil defaultFullDateFormattor] dateFromString:dateString];
                                                          // 如果时间差超过30min，数据才会变化，此时才进行更新
                                                          if ([date timeIntervalSinceDate:_startDateFromServer] >= 30 * 60) {
                                                              _startDateFromServer = _selectedDate = date;
                                                              [_availableRooms removeAllObjects];
                                                              [_availableRooms addObjectsFromArray:item.roomQueryList];
                                                              [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                                                          }
                                                          // 数据请求后
                                                          [self setupSubviews] ;
                                                      }];
}
#pragma mark - Private Methods

- (void)setupSubviews {
    // 生成TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[CSKTVDetailAddressCell class] forCellReuseIdentifier:addressIdentifier];
    [_tableView registerClass:[CSKTVDetailBookingTimeCell class] forCellReuseIdentifier:bookingTimeIdentifier];
    [_tableView registerClass:[CSAvailableRoomsCell class] forCellReuseIdentifier:roomTypeIdentifier];
    [_tableView registerClass:[CSKTVDetailTuangouLabelCell class] forCellReuseIdentifier:tuangouTitleIdentifier];
    [_tableView registerClass:[CSKTVDetailTuangouCell class] forCellReuseIdentifier:tuangouIdentifier];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = WhiteColor_Alpha_6;
    _tableView.sectionFooterHeight = 0;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    
    // 生成TableView Header
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, TRANSFER_SIZE(126))];
//    tableHeaderView.backgroundColor = [UIColor yellowColor];
    _tableView.tableHeaderView = tableHeaderView;
    
    CSCycleScrollView *pagaControl = [[CSCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, TRANSFER_SIZE(126))];
    [tableHeaderView addSubview:pagaControl];
    [pagaControl setImagesWithURLs:self.ktvItem.imageUrlList];
}

#pragma mark - CSBookingTimeSelectedAlertDelegte
// 根据弹出alertView的时间选择器，用户主动选择时间后发出的请求
- (void)bookingTimeSelectedAlert:(CSBookingTimeSelectedAlert *)alert didSelectDate:(NSDate *)date duration:(NSInteger)duration {
    _selectedDate = date;
    _duration = duration;
    [[CSDataService sharedInstance] asyncGetKTVPriceWithBLDID:self.ktvItem.BLDKTVId
                                                          day:[[CSUtil defaultDateFormattor] stringFromDate:_selectedDate]
                                                         time:[[CSUtil defaultTimeFormattor] stringFromDate:_selectedDate]
                                                     duration:duration
                                                      handler:^(CSQueryKTVPriceItem *item) {
                                                          [_availableRooms removeAllObjects];
                                                          [_availableRooms addObjectsFromArray:item.roomQueryList];
                                                          [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                                                      }];
}
//点击预订按钮
#pragma mark - CSAvailableRoomsCellDelegate

- (void)availableRoomsCell:(CSAvailableRoomsCell *)cell didBookingRoomItem:(CSKTVRoomItem *)item {
    if (!GlobalObj.isLogin) {
        _currentKTVRoomItem = item;
        CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
        loginVc.loginBlock = ^(BOOL success) {
            
            [self.navigationController popViewControllerAnimated:NO] ;
            
            if (success) {
                /*[[CSDataService sharedInstance] asyncBookKTVWithBLDKTVId:self.ktvItem.BLDKTVId
                                                               boxTypeId:item.boxTypeId
                                                             boxTypeName:item.boxTypeName
                                                                     day:[[CSUtil defaultDateFormattor] stringFromDate:_selectedDate]
                                                                duration:_duration == 7 ? [NSNumber numberWithFloat:5.0/60] : [NSNumber numberWithInteger:_duration] // TODO
                                                                    hour:[[CSUtil defaultTimeFormattor] stringFromDate:_selectedDate]
                                                                   theme:nil
                                                                 handler:^(CSKTVBookingOrder *order) {
                                                                     [SVProgressHUD dismiss];
                                                                     CSKTVPayViewController *vc = [[CSKTVPayViewController alloc] init];
                                                                     vc.order = order;
                                                                     [self.navigationController pushViewController:vc animated:YES];
                                                                     
                                                                 }];*/
                if (GlobalObj.myRooms.count == 0) { //动态登陆,没有房间才走预订的方法
                    [self pushToOrderVc];
                }
                
            }
            else
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
        };
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    else {
        _currentKTVRoomItem = item;
        [self pushToOrderVc];
    }
}


- (void)makeSureOrder
{
    NSString *alertTitle = [NSString stringWithFormat:@"时间:%@  %@点开始\n时长:%ld小时",[[CSUtil defaultDateWithUnitFormattor] stringFromDate:_selectedDate],[[CSUtil defaultTimeFormattor] stringFromDate:_selectedDate],_duration];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertTitle delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}


#pragma mark - CSKTVDetailAddressCellDelegate

- (void)KTVDetailAddressCellDidPressLocateBtn:(CSKTVDetailAddressCell *)cell {
    CSKTVMapViewController *vc = [[CSKTVMapViewController alloc] initWithKTVName:self.ktvItem.KTVName
                                                                         address:self.ktvItem.address
                                                                       longitude:[self.ktvItem.lng floatValue]
                                                                        latitude:[self.ktvItem.lat floatValue]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tuangouShops.count > 0 ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else if (section == 1)
        return 1 + _availableRooms.count;
    else
        return 1 + _tuangouShops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CSKTVDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
        [cell setAddress:self.ktvItem.address phoneNum:self.ktvItem.phoneNum];
        cell.delegate = self;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREENWIDTH, 0, 0);
//        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CSKTVDetailBookingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:bookingTimeIdentifier];
            if (![_selectedDate isEqualToDate:[NSDate distantPast]]) {
                NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                                                                   fromDate:_selectedDate];
                
                [cell setDate:[NSString stringWithFormat:@"%02ld月%02ld日", [dateComponents month], [dateComponents day]]
                    startTime:[NSString stringWithFormat:@"%02ld:%02ld起", [dateComponents hour], [dateComponents minute]]
                     duration:[NSString stringWithFormat:@"唱%ld小时", _duration]];
            }
//            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
        else {
            CSAvailableRoomsCell *cell = [tableView dequeueReusableCellWithIdentifier:roomTypeIdentifier];
            cell.delegate = self;
            [cell setDataWithRoomItem:_availableRooms[indexPath.row - 1]];
//            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
    }
    else {
        if (indexPath.row == 0) {
            CSKTVDetailTuangouLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:tuangouTitleIdentifier];
            [cell setNumberOfTuangou:_tuangouShops.count];
//            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
        else {
            CSKTVDetailTuangouCell *cell = [tableView dequeueReusableCellWithIdentifier:tuangouIdentifier];
            [cell setDataWithTuanGouItem:_tuangouShops[indexPath.row - 1]];
//            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 54;
    else if (indexPath.section == 1)
        return 50;
    else {
        return indexPath.row == 0 ? 32 : 74;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CSBookingTimeSelectedAlert *alert = [[CSBookingTimeSelectedAlert alloc] initWithDate:_startDateFromServer
                                                                                        openTime:[[CSUtil defaultTimeFormattor] dateFromString:self.ktvItem.businessHoursStart]
                                                                                       closeTime:[[CSUtil defaultTimeFormattor] dateFromString:self.ktvItem.businessHoursEnd]];
            alert.delegate = self;
            [alert show];
        }
    }
    else if (indexPath.section == 2) {
        CSTuanGouViewController *webView = [[CSTuanGouViewController alloc] init];
        CSTuanGouItem *item = _tuangouShops[indexPath.row];
        webView.url = item.H5Url;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return TRANSFER_SIZE(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [SVProgressHUD show];
    // 调至订单支付页
    [[CSDataService sharedInstance] asyncBookKTVWithBLDKTVId:self.ktvItem.BLDKTVId
                                                   boxTypeId:_currentKTVRoomItem.boxTypeId
                                                 boxTypeName:_currentKTVRoomItem.boxTypeName
                                                         day:[[CSUtil defaultDateFormattor] stringFromDate:_selectedDate]
                                                    duration:[NSNumber numberWithInteger:_duration]
                                                        hour:[[CSUtil defaultTimeFormattor] stringFromDate:_selectedDate]
                                                       theme:nil
                                                     handler:^(CSKTVBookingOrder *order) {
                                                         [SVProgressHUD dismiss];
                                                         CSKTVPayViewController *vc = [[CSKTVPayViewController alloc] init];
                                                         vc.order = order;
                                                         [self.navigationController pushViewController:vc animated:YES];
                                                     }];
    
}

- (void)pushToOrderVc
{
    [SVProgressHUD show];
    // 调至订单支付页
    [[CSDataService sharedInstance] asyncBookKTVWithBLDKTVId:self.ktvItem.BLDKTVId
                                                   boxTypeId:_currentKTVRoomItem.boxTypeId
                                                 boxTypeName:_currentKTVRoomItem.boxTypeName
                                                         day:[[CSUtil defaultDateFormattor] stringFromDate:_selectedDate]
                                                    duration:[NSNumber numberWithInteger:_duration]
                                                        hour:[[CSUtil defaultTimeFormattor] stringFromDate:_selectedDate]
                                                       theme:nil
                                                     handler:^(CSKTVBookingOrder *order) {
                                                         CSLog(@"%@", self.navigationController.viewControllers);
                                                         [SVProgressHUD dismiss];
                                                         CSKTVPayViewController *vc = [[CSKTVPayViewController alloc] init];
                                                         vc.order = order;
                                                         [self.navigationController pushViewController:vc animated:YES];
                                                     }];
}

- (void)networkReachability{
    [super networkReachability] ;
    [self getAvalibleRoomPrice] ;
}
@end
