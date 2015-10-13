//
//  CSBookingRoomViewController.m
//  CloudSong
//
//  Created by youmingtaizi on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSBookingRoomViewController.h"
#import "CSDataService.h"
#import "CSKTVBookingOrder.h"
#import "CSKTVPayViewController.h"
#import "CSKTVRoomItem.h"
#import "NSDate+Extension.h"
#import "CSKTVModel.h"
#import "CSBookingRoomButton.h"
#import "CSAvailableRoomsCell.h"
#import "CSUtil.h"
#import "CSCostDetailViewController.h"
#import "SVProgressHUD.h"

#define kMaxLength 16

@interface CSBookingRoomViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    // 主题
    UITextField*            _themeTextField;
    
    // 预约时间相关
    CSBookingRoomButton*    _buttonTimeButton;
    UIView*                 _datePikerContainer;
    MASConstraint*          _dateOffsetY;
    UIPickerView*           _datePicker;
    
    // 包厢类型相关
    CSBookingRoomButton*    _roomTypeButton;
    UIView*                 _roomTypeTableViewContainer;
    UITableView*            _roomTypeTableView;
    NSArray*                _roomTypes;
    NSInteger               _selectedRoomIndex;
    MASConstraint*          _roomTypeOffsetY;
    UIButton*               _roomTypeConfirmButton;
    
    // 当前价格
    CSBookingRoomButton*    _priceLabel;

    NSArray*                _dates;
    NSArray*                _times;
    NSArray*                _durations;
    NSInteger               _showingViewFlag; // 0:没有picker显示 1:_datePicker 在显示 2:_rootTypePicker 在显示

    int                     _nearestHourRow ;
    
    NSArray *               _tempTimesArray ; // 用于临时数据源(pickerView中间内容)
}
@end

@implementation CSBookingRoomViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedRoomIndex = -1 ; // 默认是-1，表示没有选中
    
    self.title = @"包厢预订";
    [self configRightBarButtonItem];
    [self setupSubviews];
    [self setupDatePicker];
    [self setupAvailableRoomsViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (void)rightBarBtnPressed {
    CSCostDetailViewController *vc = [[CSCostDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dateBtnPressed:(id)sender {
    [_themeTextField resignFirstResponder];
    
    // 可用包厢在显示的话，将他关闭
    if (_showingViewFlag & 2)
        [self showAvailableRoomsContainer:NO animated:YES];

    if (!(_showingViewFlag & 1)) {
        [self getAvailableDates];
        [_datePicker reloadAllComponents];
        [self showDatePickerContainer:YES animated:YES];
    }
}

// 包厢类型pickView上的确定按钮
- (void)roomTypeBtnPressed:(id)sender {
    [_themeTextField resignFirstResponder];
    // 日期选择在显示的话，将他关闭
    if (_showingViewFlag & 1)
        [self showDatePickerContainer:NO animated:YES];

    // 先判断有无选择预约时间
    if (_buttonTimeButton.title.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"预约时间不能为空"] ;
        
    }else if (!(_showingViewFlag & 2))
        [self showAvailableRoomsContainer:YES animated:YES];
}
// pickView上的确定按钮
- (void)cancelBtnPressed:(id)sender {
    if (_showingViewFlag & 1)
        [self showDatePickerContainer:NO animated:YES];
    else if (_showingViewFlag & 2)
        [self showAvailableRoomsContainer:NO animated:YES];
}

// 预定时间pickView上的确定按钮
- (void)confirmBtnPressed:(id)sender {
    if (_showingViewFlag & 1) {
        // 根据用户的选择构造起始日期
        NSInteger dateIndex = [_datePicker selectedRowInComponent:0];
        CSDateModel *date = _dates[dateIndex];
        NSMutableString *title = [NSMutableString string];
        [title appendFormat:@"%02ld-%02ld", (long)date.month, (long)date.day];
        if (date.weekday == 0)
            [title appendString:@"周日"];
        else if (date.weekday == 1)
            [title appendString:@"周一"];
        else if (date.weekday == 2)
            [title appendString:@"周二"];
        else if (date.weekday == 3)
            [title appendString:@"周三"];
        else if (date.weekday == 4)
            [title appendString:@"周四"];
        else if (date.weekday == 5)
            [title appendString:@"周五"];
        else if (date.weekday == 6)
            [title appendString:@"周六"];

        // 构造起始时间
        NSInteger timeIndex = [_datePicker selectedRowInComponent:1];
        [title appendFormat:@" %@", _times[timeIndex]];
        
        // 构造起始时长
        NSInteger durationIndex = [_datePicker selectedRowInComponent:2];
        [title appendFormat:@" %ld小时", (long)[_durations[durationIndex] integerValue]];

        [_buttonTimeButton setTitle:title];
//        [[CSDataService sharedInstance] asyncGetKTVPriceWithBLDID:self.ktvItem.BLDKTVId
//                                                              day:[NSString stringWithFormat:@"%02ld-%02ld", (long)date.month, (long)date.day]
//                                                            time:_times[timeIndex]
//                                                        duration:[_durations[durationIndex] integerValue]
//                                                         handler:^(NSArray *rooms) {
//                                                             _roomTypes = rooms;
//                                                             [_roomTypeTableView reloadData];
//                                                         }];
    }
    else {
        CSKTVRoomItem *item = _roomTypes[_selectedRoomIndex];
        [_roomTypeButton setTitle:item.boxTypeName];
        [_priceLabel setTitle:item.price];
    }
    [self cancelBtnPressed:sender];
}

- (void)bookingBtnPressed:(id)sender {
    // 没输入主题的话，需要输入主题
    if (_themeTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入主题"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSInteger dateIndex = [_datePicker selectedRowInComponent:0];
        CSDateModel *date = _dates[dateIndex];
        NSString *dateStr = [NSString stringWithFormat:@"%02ld-%02ld", (long)date.month, (long)date.day];
        
        if (_roomTypeButton.title.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"包厢类型不能为空"] ;
        }else{
            CSKTVRoomItem *item = _roomTypes[_selectedRoomIndex];
            [[CSDataService sharedInstance] asyncBookKTVWithBLDKTVId:self.ktvItem.BLDKTVId
                                                           boxTypeId:item.boxTypeId
                                                         boxTypeName:item.boxTypeName
                                                                 day:dateStr
                                                            duration:_durations[[_datePicker selectedRowInComponent:2]]
                                                                hour:_times[[_datePicker selectedRowInComponent:1]]
                                                               theme:_themeTextField.text
                                                             handler:^(CSKTVBookingOrder *order) {
                                                                 CSKTVPayViewController *vc = [[CSKTVPayViewController alloc] init];
                                                                 vc.order = order;
                                                                 [self.navigationController pushViewController:vc animated:YES];
                                                             }];
            }

        }
    }

#pragma mark - Private Methods

- (void)configRightBarButtonItem {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(14)];
    [backButton setTitleColor:HEX_COLOR(0xcd418f) forState:UIControlStateNormal];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [backButton setTitle:@"计费详情" forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(rightBarBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupSubviews {
    self.view.backgroundColor = HEX_COLOR(0x1d1c21);
    
    // 活动主题 Label
    UILabel *themeLabel = [[UILabel alloc] init];
    [self.view addSubview:themeLabel];
    themeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    themeLabel.textColor = [HEX_COLOR(0x9898a2) colorWithAlphaComponent:.5];
    themeLabel.text = @"活动主题";
    [themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(themeLabel.superview).offset(TRANSFER_SIZE(22));
        make.right.equalTo(themeLabel.superview);
        make.top.equalTo(themeLabel.superview).offset(TRANSFER_SIZE(17));
        make.height.mas_equalTo(TRANSFER_SIZE(15));
    }];

    // 活动主题 UITextField
    _themeTextField = [[UITextField alloc] init];
    NSString *placeHolder = [NSString stringWithFormat:@"最长%d个汉字", kMaxLength] ;
    [self.view addSubview:_themeTextField];
    _themeTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    _themeTextField.textColor = [HEX_COLOR(0x9898a2) colorWithAlphaComponent:.3];
    _themeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: placeHolder
                                                                           attributes:@{NSForegroundColorAttributeName:[HEX_COLOR(0x9898a2) colorWithAlphaComponent:.3]}];
    _themeTextField.returnKeyType = UIReturnKeyDone;
    _themeTextField.textAlignment = NSTextAlignmentCenter;
    _themeTextField.delegate = self;
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFiledEditChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_themeTextField] ;
    
    [_themeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_themeTextField.superview);
        make.top.equalTo(_themeTextField.superview).offset(TRANSFER_SIZE(48));
        make.height.mas_equalTo(TRANSFER_SIZE(15));
    }];
    
    // 粉色分割线 UIImageView
    UIImageView *sep = [[UIImageView alloc] init];
    [self.view addSubview:sep];
    sep.image = [UIImage imageNamed:@"schedule_line"];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sep.superview).offset(TRANSFER_SIZE(10));
        make.right.equalTo(sep.superview).offset(TRANSFER_SIZE(-10));
        make.top.equalTo(_themeTextField.mas_bottom).offset(TRANSFER_SIZE(7));
        make.height.mas_equalTo(TRANSFER_SIZE(4));
    }];

    // 预约时间 Label
    UILabel *bookingTimeLabel = [[UILabel alloc] init];
    [self.view addSubview:bookingTimeLabel];
    bookingTimeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    bookingTimeLabel.textColor = [HEX_COLOR(0x9898a2) colorWithAlphaComponent:.5];
    bookingTimeLabel.text = @"预约时间";
    [bookingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookingTimeLabel.superview).offset(TRANSFER_SIZE(22));
        make.right.equalTo(bookingTimeLabel.superview);
        make.top.equalTo(sep.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(44));
    }];

    // 预约时间 Button
    _buttonTimeButton = [CSBookingRoomButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_buttonTimeButton];
    [_buttonTimeButton addTarget:self action:@selector(dateBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonTimeButton.superview).offset(TRANSFER_SIZE(8));
        make.right.equalTo(_buttonTimeButton.superview).offset(TRANSFER_SIZE(-8));
        make.top.equalTo(bookingTimeLabel.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(39));
    }];
    
    // 包厢类型 Label
    UILabel *roomTypeLabel = [[UILabel alloc] init];
    [self.view addSubview:roomTypeLabel];
    roomTypeLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    roomTypeLabel.textColor = [HEX_COLOR(0x9898a2) colorWithAlphaComponent:.5];
    roomTypeLabel.text = @"包厢类型";
    [roomTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomTypeLabel.superview).offset(TRANSFER_SIZE(22));
        make.right.equalTo(roomTypeLabel.superview);
        make.top.equalTo(_buttonTimeButton.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(44));
    }];

    // 包厢类型 Button
    _roomTypeButton = [CSBookingRoomButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_roomTypeButton];
    [_roomTypeButton addTarget:self action:@selector(roomTypeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_roomTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_roomTypeButton.superview).offset(TRANSFER_SIZE(8));
        make.right.equalTo(_roomTypeButton.superview).offset(TRANSFER_SIZE(-8));
        make.top.equalTo(roomTypeLabel.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(39));
    }];

    // 当前价格 Label
    UILabel *priceLabel = [[UILabel alloc] init];
    [self.view addSubview:priceLabel];
    priceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15)];
    priceLabel.textColor = [HEX_COLOR(0x9898a2) colorWithAlphaComponent:.5];
    priceLabel.text = @"当前价格";
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.superview).offset(TRANSFER_SIZE(22));
        make.right.equalTo(priceLabel.superview);
        make.top.equalTo(_roomTypeButton.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(44));
    }];

    // 当前价格 Button
    _priceLabel = [CSBookingRoomButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLabel.superview).offset(TRANSFER_SIZE(8));
        make.right.equalTo(_priceLabel.superview).offset(TRANSFER_SIZE(-8));
        make.top.equalTo(priceLabel.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(39));
    }];

    // 价格说明 Label
    UILabel *priceDetailLabel = [[UILabel alloc] init];
    [self.view addSubview:priceDetailLabel];
    priceDetailLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13)];
    priceDetailLabel.textColor = [HEX_COLOR(0x9898a2) colorWithAlphaComponent:.3];
    priceDetailLabel.text = @"点击查看价格说明";
    [priceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceDetailLabel.superview).offset(TRANSFER_SIZE(17));
        make.right.equalTo(priceDetailLabel.superview);
        make.top.equalTo(_priceLabel.mas_bottom).offset(TRANSFER_SIZE(14));
        make.height.mas_equalTo(TRANSFER_SIZE(13));
    }];
    
    // 预定 Button
    UIButton *bookingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bookingButton];
    [bookingButton setTitle:@"预订" forState:UIControlStateNormal];
    [bookingButton setBackgroundImage:[UIImage imageNamed:@"schedule_btn_bg"]
                             forState:UIControlStateNormal];
    bookingButton.titleLabel.textColor = [UIColor whiteColor];
    bookingButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16)];
    [bookingButton addTarget:self action:@selector(bookingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bookingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookingButton.superview).offset(TRANSFER_SIZE(10));
        make.right.equalTo(bookingButton.superview).offset(TRANSFER_SIZE(-10));
        make.top.equalTo(priceDetailLabel).offset(TRANSFER_SIZE(34));
        make.height.mas_equalTo(TRANSFER_SIZE(39));
    }];
}

- (void)setupDatePicker {
    // 容器
    _datePikerContainer = [[UIView alloc] init];
    [self.view addSubview:_datePikerContainer];
    _datePikerContainer.backgroundColor = HEX_COLOR(0x1b1b1b);
    [_datePikerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_datePikerContainer.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(225));
        _dateOffsetY = make.top.equalTo(_datePikerContainer.superview.mas_bottom);
    }];
    
    // 取消 Button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_datePikerContainer addSubview:cancelButton];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(17)];
    [cancelButton setTitleColor:HEX_COLOR(0x666666) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cancelButton.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(80), TRANSFER_SIZE(44)));
    }];

    // 确定 Button
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_datePikerContainer addSubview:confirmButton];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(17)];
    [confirmButton setTitleColor:HEX_COLOR(0xff41ab) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(confirmButton.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(80), TRANSFER_SIZE(44)));
    }];
    
    // DatePicker
    _datePicker = [[UIPickerView alloc] init];
    [_datePikerContainer addSubview:_datePicker];
    _datePicker.delegate = self;
    _datePicker.dataSource = self;
    _datePicker.backgroundColor = HEX_COLOR(0x1f1f1f);
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_datePicker.superview);
        make.top.equalTo(confirmButton.mas_bottom);
        make.bottom.equalTo(_datePicker.superview);
    }];
    
}

#pragma mark - 设置包厢类型视图
- (void)setupAvailableRoomsViews {
    // 容器
    _roomTypeTableViewContainer = [[UIView alloc] init];
    [self.view addSubview:_roomTypeTableViewContainer];
    _roomTypeTableViewContainer.backgroundColor = HEX_COLOR(0x1b1b1b);
    [_roomTypeTableViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_roomTypeTableViewContainer.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(225));
        _roomTypeOffsetY = make.top.equalTo(_roomTypeTableViewContainer.superview.mas_bottom);
    }];
    
    // 取消 Button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_roomTypeTableViewContainer addSubview:cancelButton];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(17)];
    [cancelButton setTitleColor:HEX_COLOR(0x666666) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cancelButton.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(80), TRANSFER_SIZE(44)));
    }];
    
    // 确定 Button
    _roomTypeConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_roomTypeTableViewContainer addSubview:_roomTypeConfirmButton];
    _roomTypeConfirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(17)];
    [_roomTypeConfirmButton setTitleColor:HEX_COLOR(0xff41ab) forState:UIControlStateNormal];
    [_roomTypeConfirmButton setTitleColor:[HEX_COLOR(0xff41ab) colorWithAlphaComponent:.3] forState:UIControlStateDisabled];
    [_roomTypeConfirmButton addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_roomTypeConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_roomTypeConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_roomTypeConfirmButton.superview);
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(80), TRANSFER_SIZE(44)));
    }];
    
    // 生成 Tableview
    _roomTypeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_roomTypeTableViewContainer addSubview:_roomTypeTableView];
    _roomTypeTableView.dataSource = self;
    _roomTypeTableView.delegate = self;
    _roomTypeTableView.separatorInset = UIEdgeInsetsZero;
    _roomTypeTableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    [_roomTypeTableView registerClass:[CSAvailableRoomsCell class] forCellReuseIdentifier:@"CSAvailableRoomsCell"];
    _roomTypeTableView.backgroundColor = HEX_COLOR(0x1f1f1f);
    [CSUtil hideEmptySeparatorForTableView:_roomTypeTableView];
    [_roomTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_roomTypeTableView.superview);
        make.top.equalTo(_roomTypeConfirmButton.mas_bottom);
        make.bottom.equalTo(_roomTypeTableView.superview);
    }];
}

- (void)getAvailableDates {
    
    // 设置左边日期
    _dates = [NSDate datesSinceNow:30];
    
    // 设置中间钟点
    _times = @[@"08:00", @"08:30",
               @"09:00", @"09:30",
               @"10:00", @"10:30",
               @"11:00", @"11:30",
               @"12:00", @"12:30",
               @"13:00", @"13:30",
               @"14:00", @"14:30",
               @"15:00", @"15:30",
               @"16:00", @"16:30",
               @"17:00", @"17:30",
               @"18:00", @"18:30",
               @"19:00", @"19:30",
               @"20:00", @"20:30"];
    
    _tempTimesArray = [NSArray arrayWithArray:_times] ;
    
    // 设置小时数
    _durations = @[@1, @2, @3, @4, @5, @6, @7, @8];
}

// 是否动画显示DatePickerView
- (void)showDatePickerContainer:(BOOL)show animated:(BOOL)animated {
    _showingViewFlag = show ? 1 : 0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animated ? .5 : 0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _dateOffsetY.offset = show ? (0 - _datePikerContainer.height) : 0;
                         
                         // 设置PickerView默认显示离当前最近的时间
                         // 默认显示对应component的某一行
                         
                         _nearestHourRow = [self getNearestHourRow] ;
                         _times = [_times subarrayWithRange:NSMakeRange(_nearestHourRow, _times.count - _nearestHourRow)] ;
//                         [_datePicker selectRow:_nearestHourRow inComponent:1 animated:YES] ;
                         [_datePicker reloadComponent:1] ;
                         
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

#pragma mark - 获取离当前最近的小时
- (int)getNearestHourRow
{
//    double nearest = MAXFLOAT ;
    int index = 0 ; // 记录最近小时的下标
    
    for (int i = 0; i < _times.count; i++) {
        NSDate *tempDate = [NSDate dateWithHourMinute:_times[i]] ;
        double delta = [tempDate deltaTimeFromNow] ;
        CSLog(@"deltaTime = %f", delta) ;
        
        // 找到第一个大于 0 的差值(比当前时间靠后一点的)
        if (delta  > 0.0) {
            index = i ;
            break ;
        }
    }
    return index ;
}

// 是否动画显示包厢类型View
- (void)showAvailableRoomsContainer:(BOOL)show animated:(BOOL)animated {
    _showingViewFlag = show ? 2 : 0;
    if (show && _selectedRoomIndex == -1) 
        _roomTypeConfirmButton.enabled = NO;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animated ? .5 : 0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _roomTypeOffsetY.offset = show ? (0 - _roomTypeTableViewContainer.height) : 0;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return _dates.count;
    else if (component == 1)
    {
        return _times.count ;
    }
    else
        return _durations.count;
}

#pragma mark - UIPickerViewDelegate

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (component == 0) {
        CSDateModel *date = _dates[row];
        NSString *week;
        if (date.weekday == 0)
            week = @"周日";
        else if (date.weekday == 1)
            week = @"周一";
        else if (date.weekday == 2)
            week = @"周二";
        else if (date.weekday == 3)
            week = @"周三";
        else if (date.weekday == 4)
            week = @"周四";
        else if (date.weekday == 5)
            week = @"周五";
        else if (date.weekday == 6)
            week = @"周六";

        title = [NSString stringWithFormat:@"%02ld-%02ld%@", (long)date.month, (long)date.day, week];
    }
    else if (component == 1){
        
        title = _times[row];
    }
    
    else
        title = [NSString stringWithFormat:@"%ld小时", (long)[_durations[row] integerValue]];
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat result;
    if (component == 0)
        result = SCREENWIDTH * .45;
    else if (component == 1)
        result = SCREENWIDTH * .25;
    else
        result = SCREENWIDTH * .25;
    return result;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *title = [[UILabel alloc] init];
    title.textColor = HEX_COLOR(0x606060);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *revArray = [NSArray arrayWithArray:_tempTimesArray] ;
    
    if (component == 0 && row != 0) {
        _times = _tempTimesArray ;
        [pickerView reloadComponent:1] ;
    }
    else if(component == 0 && row == 0){
        _times = [revArray subarrayWithRange:NSMakeRange(_nearestHourRow, revArray.count - _nearestHourRow)] ;
        [pickerView reloadComponent:1] ;
        [pickerView selectRow:0 inComponent:1 animated:YES] ;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _roomTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"CSAvailableRoomsCell";
    CSAvailableRoomsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    CSKTVRoomItem *item = _roomTypes[indexPath.row];
//    [cell setRoomType:item.boxTypeName];
//    [cell setPrice:[NSString stringWithFormat:@"￥%@", item.price]];
//    [cell setAvailable:item.boxTypeState];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANSFER_SIZE(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSKTVRoomItem *item = _roomTypes[indexPath.row];
    if (item.boxTypeState) {
        _selectedRoomIndex = indexPath.row;
        _roomTypeConfirmButton.enabled = YES;
    }
    else
        _roomTypeConfirmButton.enabled = NO;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextField 通知（限制_themeTextField的字数）
- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object ;
    NSString *toBeString = textField.text;
    
    NSString *language = [[textField textInputMode] primaryLanguage] ;
    
    if ([language isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:_themeTextField] ;
}

@end
