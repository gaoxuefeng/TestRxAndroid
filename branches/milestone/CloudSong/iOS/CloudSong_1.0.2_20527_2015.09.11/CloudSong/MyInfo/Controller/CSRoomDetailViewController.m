//
//  CSRoomDetailViewController.m
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomDetailViewController.h"
#import <Masonry.h>
#import "CSRoomDetailCell.h"
#import "UIImage+Extension.h"
#import "SVProgressHUD.h"
#import "CSCancelRoomViewController.h"
#import "CSMyInfoHttpTool.h"
#import "CSPayTool.h"
#import "CSKTVPayViewController.h"
#import "CSKTVBookingOrder.h"
#import "CSLoginHttpTool.h"
#import "CSRoomUpdateTool.h"
#import "CSAlterTabBarTool.h"
@interface CSRoomDetailViewController ()<UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, weak) UIButton *paiedButton;
@property(nonatomic, weak) UIButton *cancelButton;
@property(nonatomic, weak) CSRoomDetailCell *orderIdCell;
@property(nonatomic, weak) CSRoomDetailCell *orderManCell;
@property(nonatomic, weak) CSRoomDetailCell *phoneNumCell;
//@property(nonatomic, weak) CSRoomDetailCell *topicCell;
@property(nonatomic, weak) CSRoomDetailCell *dateCell;
@property(nonatomic, weak) CSRoomDetailCell *boxCell;
@property(nonatomic, weak) CSRoomDetailCell *priceCell;
@property(nonatomic, weak) CSRoomDetailCell *shopCell;
@property(nonatomic, weak) CSRoomDetailCell *addressCell;
@property(nonatomic, weak) UILabel *statusLabel;
@property(nonatomic, weak) UIView *cancelOrPayView;
@property(nonatomic, strong) CSRoomDetailModel *data;
@end

@implementation CSRoomDetailViewController

- (instancetype)initWithOrderId:(NSString *)orderId
{
    _orderId = orderId;
    return [self init];
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Setup
- (void)setupSubViews
{
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"mine_consumption_bg"];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundImageView.superview);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"消费详情";
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(18.0)];
    titleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel.superview);
        make.top.equalTo(titleLabel.superview).offset(31.0);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[[UIImage imageNamed:@"room_detail_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.0, 80.0));
        make.left.top.equalTo(backButton.superview);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.superview).offset(64.0);
        make.left.right.bottom.equalTo(_scrollView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.mas_equalTo(container.superview);
    }];
    
    UIImageView *containerBgView = [[UIImageView alloc] init];
    NSString *imageName = nil;
    if (iPhone6) {
        imageName = @"mine_consumption_details_lay_bg_6";
    }else if (iPhone6Plus)
    {
        imageName = @"mine_consumption_details_lay_bg_6p";
    }else
    {
        imageName = @"mine_consumption_details_lay_bg";
    }
    containerBgView.image = [[UIImage imageNamed:imageName] resizedImage];
    [container addSubview:containerBgView];
    
    
    CGFloat padding = TRANSFER_SIZE(20.0);
    CGFloat topPadding = TRANSFER_SIZE(15.0);
    
    // 订单编号
    CSRoomDetailCell *orderIdCell = [[CSRoomDetailCell alloc] initWithTitle:@"订单号"];
    orderIdCell.titleColor = HEX_COLOR(0xccb6bf);
    orderIdCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:orderIdCell];
    [orderIdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderIdCell.superview).offset(TRANSFER_SIZE(40.0));
        make.left.equalTo(orderIdCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
    }];
    _orderIdCell = orderIdCell;
    
    // 预约人
    CSRoomDetailCell *orderManCell = [[CSRoomDetailCell alloc] initWithTitle:@"预约人"];
    orderManCell.titleColor = HEX_COLOR(0xccb6bf);
    orderManCell.contentColor = HEX_COLOR(0xccb6bf);
    orderManCell.contentLabel.numberOfLines = 1;
//    orderManCell.contentLabel.numberOfLines = 1;
    [container addSubview:orderManCell];
    [orderManCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderIdCell.mas_bottom).offset(topPadding);
        make.left.equalTo(orderIdCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
        make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(130.0));
        
//        make.width.mas_lessThanOrEqualTo(AUTOLENGTH(140.0));
    }];
    _orderManCell = orderManCell;
    
    // 联系电话
    CSRoomDetailCell *phoneNumCell = [[CSRoomDetailCell alloc] initWithTitle:@"联系电话"];
    phoneNumCell.titleColor = HEX_COLOR(0xc1b652);
    phoneNumCell.contentColor = HEX_COLOR(0xc1b652);
    [container addSubview:phoneNumCell];
    [phoneNumCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderIdCell.mas_bottom).offset(topPadding);
        make.left.greaterThanOrEqualTo(orderManCell.mas_right);
        make.left.greaterThanOrEqualTo(phoneNumCell.superview).offset(AUTOLENGTH(150.0) + padding);
    }];
    _phoneNumCell = phoneNumCell;
    
//    //  主题
//    CSRoomDetailCell *topicCell = [[CSRoomDetailCell alloc] initWithTitle:@"主题"];
//    topicCell.titleColor = HEX_COLOR(0xccb6bf);
//    topicCell.contentColor = HEX_COLOR(0xccb6bf);
//    [container addSubview:topicCell];
//    [topicCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(orderManCell.mas_bottom).offset(topPadding);
//        make.left.equalTo(topicCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
//    }];
//    _topicCell = topicCell;
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = HEX_COLOR(0x692642);
    [container addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumCell.mas_bottom).offset(TRANSFER_SIZE(13.0));
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        make.left.equalTo(divider.superview).offset(padding + TRANSFER_SIZE(10.0));
        make.right.equalTo(divider.superview).offset(-padding - TRANSFER_SIZE(10.0));
    }];
    
    // 时间
    CSRoomDetailCell *dateCell = [[CSRoomDetailCell alloc] initWithTitle:@"时间"];
    dateCell.titleColor = HEX_COLOR(0xc1b652);
    dateCell.contentColor = HEX_COLOR(0xc1b652);
    [container addSubview:dateCell];
    [dateCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumCell.mas_bottom).offset(TRANSFER_SIZE(30.0));
        make.left.equalTo(dateCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
    }];
    _dateCell = dateCell;
    
    // 包厢
    CSRoomDetailCell *boxCell = [[CSRoomDetailCell alloc] initWithTitle:@"房间"];
    boxCell.titleColor = HEX_COLOR(0xccb6bf);
    boxCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:boxCell];
    [boxCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateCell.mas_bottom).offset(topPadding);
        make.left.equalTo(boxCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
    }];
    _boxCell = boxCell;
    
    // 价格
    CSRoomDetailCell *priceCell = [[CSRoomDetailCell alloc] initWithTitle:@"价格"];
    priceCell.titleColor = HEX_COLOR(0xc1b652);
    priceCell.contentColor = HEX_COLOR(0xc1b652);
    [container addSubview:priceCell];
    [priceCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxCell.mas_bottom).offset(topPadding);
        make.left.equalTo(priceCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
    }];
    _priceCell = priceCell;
    
    // 门店
    CSRoomDetailCell *shopCell = [[CSRoomDetailCell alloc] initWithTitle:@"门店"];
    shopCell.titleColor = HEX_COLOR(0xccb6bf);
    shopCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:shopCell];
    [shopCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceCell.mas_bottom).offset(topPadding);
        make.left.equalTo(shopCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
        make.right.equalTo(shopCell.superview).offset(-TRANSFER_SIZE(15.0) - padding);
    }];
    _shopCell = shopCell;
    
    // 地址
    CSRoomDetailCell *addressCell = [[CSRoomDetailCell alloc] initWithTitle:@"地址"];
    addressCell.titleColor = HEX_COLOR(0xccb6bf);
    addressCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:addressCell];
    [addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopCell.mas_bottom).offset(topPadding);
        make.left.equalTo(addressCell.superview).offset(TRANSFER_SIZE(15.0) + padding);
//        make.bottom.equalTo(addressCell.superview).offset(-20.0);
        make.right.equalTo(addressCell.superview).offset(-TRANSFER_SIZE(15.0) - padding);
    }];
    _addressCell = addressCell;
    
    [containerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerBgView.superview);
        make.width.mas_equalTo(containerBgView.image.size.width);
        make.top.equalTo(containerBgView.superview);
        make.bottom.equalTo(addressCell.mas_bottom).offset(TRANSFER_SIZE(20.0));
    }];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    statusLabel.textColor = HEX_COLOR(0xc7a1b4);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.transform = CGAffineTransformRotate(statusLabel.transform, M_PI_4);
    [containerBgView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(statusLabel.superview.mas_right).offset(iPhone6?-33.0:(iPhone6Plus?-26.0:-TRANSFER_SIZE(27.0)));
        make.centerY.equalTo(statusLabel.superview.mas_top).offset(iPhone6?33.0:(iPhone6Plus?26.0:TRANSFER_SIZE(27.0)));
    }];
    _statusLabel = statusLabel;
    
    // 按钮区域
    UIView *buttonContainer = [[UIView alloc] init];
    [container addSubview:buttonContainer];
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressCell.mas_bottom).offset(TRANSFER_SIZE(25.0));
        make.right.left.bottom.equalTo(buttonContainer.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(82.0));
    }];
    
    CGFloat radius = TRANSFER_SIZE(19.5);
    CGFloat cancelButtonHPadding = TRANSFER_SIZE(60.0);
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelButton setTitle:@"已取消" forState:UIControlStateDisabled];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [cancelButton setTitleColor:HEX_COLOR(0x9b8f9d) forState:UIControlStateNormal];
    cancelButton.backgroundColor = HEX_COLOR(0x391f3f);
    cancelButton.layer.cornerRadius = radius;
    cancelButton.layer.masksToBounds = YES;
    [buttonContainer addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.superview).offset(cancelButtonHPadding);
        make.right.equalTo(cancelButton.superview).offset(-cancelButtonHPadding);
        make.centerY.equalTo(cancelButton.superview);
        make.height.mas_equalTo(radius * 2);
    }];
    _paiedButton = cancelButton;
    
    
    UIView *cancelOrPayView = [[UIView alloc] init];
    cancelOrPayView.layer.cornerRadius = radius;
    cancelOrPayView.layer.masksToBounds = YES;
    cancelOrPayView.backgroundColor = HEX_COLOR(0x381e3e);
    [container addSubview:cancelOrPayView];
    [cancelOrPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelOrPayView.superview).offset(TRANSFER_SIZE(25.0));
        make.right.equalTo(cancelOrPayView.superview).offset(-TRANSFER_SIZE(25.0));
        make.height.equalTo(cancelButton.mas_height);
        make.centerY.equalTo(buttonContainer);
    }];
    
    UIView *cancelOrPayVLine = [[UIView alloc] init];
    cancelOrPayVLine.backgroundColor = HEX_COLOR(0x280e2f);
    [cancelOrPayView addSubview:cancelOrPayVLine];
    [cancelOrPayVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cancelOrPayVLine.superview);
        make.width.mas_equalTo(2 / [UIScreen mainScreen].scale);
        make.height.equalTo(cancelOrPayVLine.superview.mas_height);
    }];
    
    UIButton *inCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inCancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [inCancelButton setTitle:@"取消预订" forState:UIControlStateNormal];
    inCancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [inCancelButton setTitleColor:HEX_COLOR(0x9b8f9d) forState:UIControlStateNormal];
    [cancelOrPayView addSubview:inCancelButton];
    [inCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(inCancelButton.superview);
        make.width.equalTo(inCancelButton.superview.mas_width).multipliedBy(0.5);
    }];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton addTarget:self action:@selector(payBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [payButton setTitle:@"完成支付" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [payButton setTitleColor:HEX_COLOR(0x9b8f9d) forState:UIControlStateNormal];
    [cancelOrPayView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(payButton.superview);
        make.width.equalTo(payButton.superview.mas_width).multipliedBy(0.5);
    }];
 
    _cancelOrPayView = cancelOrPayView;
}

#pragma mark - Load data
- (void)loadData
{
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _orderId;
    
    
    [SVProgressHUD show];
    [CSMyInfoHttpTool getRoomCostDetailWithParam:param success:^(CSRoomDetailResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            _data = result.data;
            _orderIdCell.content = result.data.reserveBoxId;
            _orderManCell.content = result.data.nickName;
            _phoneNumCell.content = result.data.phoneNum;
//            _topicCell.content = result.data.theme;

            _dateCell.content = result.data.time;
            _boxCell.content = result.data.roomNum;
            _priceCell.content = [NSString stringWithFormat:@"￥ %@",[result.data.price stringValue]];
            _shopCell.content = result.data.ktvName;
            _addressCell.content = result.data.address;
            
            NSString *statusStr;
            switch (result.data.payState) {
                case CSMyCostStatusTypeNotPay:
                {
                    statusStr = @"未支付";
                    _cancelButton.hidden = YES;
                    _cancelOrPayView.hidden = NO;
                    break;
                }
                case CSMyCostStatusTypeHasPayEnableRefunding:
                {
                    statusStr = @"已支付";
                    [self changeDateToTimeInterval:result.data.rbStartTime endTimeInterval:result.data.rbEndTime];
                    _cancelButton.enabled = YES;
                    _cancelButton.hidden = NO;
                    _cancelOrPayView.hidden = YES;
                    break;
                }
                case CSMyCostStatusTypeHasPayDisableRefunding:
                {
                    statusStr = @"已支付";
                    [self changeDateToTimeInterval:result.data.rbStartTime endTimeInterval:result.data.rbEndTime];
                    _cancelButton.enabled = YES;
                    _cancelButton.hidden = NO;
                    _cancelOrPayView.hidden = YES;
                    break;
                }
                case CSMyCostStatusTypeRefunding:
                {
                    statusStr = @"退款中";
                    [_paiedButton setTitle:@"退款中" forState:UIControlStateDisabled];
                    _paiedButton.enabled = NO;
                    _cancelButton.enabled = YES;
                    _cancelButton.hidden = NO;
                    _cancelOrPayView.hidden = YES;
                    break;
                }
                case CSMyCostStatusTypeInCost:
                {
                    statusStr = @"已消费";
                    _cancelButton.enabled = NO;
                    _paiedButton.enabled = NO;
                    [_paiedButton setTitle:@"已消费" forState:UIControlStateDisabled];
                    _cancelButton.hidden = YES;
                    _cancelOrPayView.hidden = YES;
                    break;
                }
                case CSMyCostStatusTypeCanceled:
                {
                    statusStr = @"已取消";
                    _cancelButton.enabled = NO;
                    _paiedButton.enabled = NO;
                    [_paiedButton setTitle:@"已取消" forState:UIControlStateDisabled];
                    _cancelButton.hidden = YES;
                    _paiedButton.hidden = NO;
                    _cancelOrPayView.hidden = YES;
                    break;
                }
                default:
                    break;
            }
            _statusLabel.text = statusStr;
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}
- (void)changeDateToTimeInterval:(NSString*)startTime endTimeInterval:(NSString*)endTimeterval
{
    NSDate * newDate = [NSDate date];
    NSInteger timeInterval = (long)[newDate timeIntervalSince1970];
    NSInteger betweenStart = startTime.integerValue - timeInterval;
    if (betweenStart > 0 && betweenStart<3600){
        [_paiedButton setTitle:@"即将开始" forState:UIControlStateDisabled];
        _paiedButton.enabled = NO;
    }
    else if (betweenStart<0){
        [_paiedButton setTitle:@"已消费" forState:UIControlStateDisabled];
        _paiedButton.enabled = NO;
    }
    
}
#pragma mark - Action Methods
- (void)backBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnPressed:(UIButton *)button
{
    UIAlertView *cancelAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"包厢已预留，真的要取消订单么？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [cancelAlertView show];
}

- (void)payBtnPressed:(UIButton *)button
{
    if (!_data) return;
    CSKTVBookingOrder *item = [[CSKTVBookingOrder alloc] init];
    item.roomNum = _data.roomNum;
//    item.theme = _data.theme;
    item.reserveBoxId = _data.reserveBoxId;
    item.KTVName = _data.ktvName;
    item.price = _data.price;
    item.address = _data.address;
    item.rbStartTime = [NSNumber numberWithFloat:[_data.rbStartTime floatValue]];
    item.rbEndTime = [NSNumber numberWithFloat:[_data.rbEndTime floatValue]];
    item.boxTypeName = _data.roomNum;
    CSKTVPayViewController *ktvPayVc = [[CSKTVPayViewController alloc] init];
    ktvPayVc.repay = YES;
    ktvPayVc.order = item;
    [self.navigationController pushViewController:ktvPayVc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _orderId;
    
    [CSMyInfoHttpTool cancelOrderWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            self.payStatusChanged(CSMyCostStatusTypeCanceled);
            if (_data.payState == CSMyCostStatusTypeNotPay) {
                [SVProgressHUD showSuccessWithStatus:@"订单取消成功"];
                _statusLabel.text = @"已取消";
                _cancelButton.enabled = NO;
                _paiedButton.enabled = NO;
                [_paiedButton setTitle:@"已取消" forState:UIControlStateDisabled];
                _cancelButton.hidden = YES;
                _paiedButton.hidden = NO;
                _cancelOrPayView.hidden = YES;
            }else
            {
                [self updateRoomInfo];
                CSCancelRoomViewController *cancelRoomVc = [[CSCancelRoomViewController alloc] initWithPrice:[_data.price floatValue]];
                [self.navigationController pushViewController:cancelRoomVc animated:YES];
                _statusLabel.text = @"退款中";
                [_paiedButton setTitle:@"退款中" forState:UIControlStateDisabled];
                _paiedButton.enabled = NO;
                _cancelButton.enabled = YES;
                _cancelButton.hidden = NO;
                _cancelOrPayView.hidden = YES;
                
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}

- (void)updateRoomInfo
{
    CSRequest *param = [[CSRequest alloc] init];
    [CSLoginHttpTool getUserInfoWithParam:param success:^(CSUserDataWrapperModel *result) {
        if (result.code == ResponseStateSuccess) {
            GlobalObj.myRooms = result.data.myrooms;
            GlobalObj.selectedId = GlobalObj.selectedId;
            if (GlobalObj.myRooms.count > 0) {
                // 增加定时器
                [[CSRoomUpdateTool sharedSingleton] resetTimers];
                for (CSMyRoomInfoModel *roomInfo in GlobalObj.myRooms) {
                    if (roomInfo.starting) // 如果已经开始 则增加房间结束定时器
                    {
                        if (roomInfo.rbEndTime.length > 0 && roomInfo.serverTimeStamp.length > 0) {
                            NSTimeInterval seconds = roomInfo.rbEndTime.doubleValue - roomInfo.serverTimeStamp.doubleValue;
                            [[CSRoomUpdateTool sharedSingleton] addTimerAfterTimeInterval:seconds];
                        }
                    }else // 否则增加房间开始定时器
                    {
                        if (roomInfo.rbStartTime.length > 0 && roomInfo.serverTimeStamp.length > 0) {
                            NSTimeInterval seconds = roomInfo.rbStartTime.doubleValue - roomInfo.serverTimeStamp.doubleValue;
                            [[CSRoomUpdateTool sharedSingleton] addTimerAfterTimeInterval:seconds];
                        }
                    }
                }
                [CSAlterTabBarTool alterTabBarToRoomController];
            }else
            {
                [CSAlterTabBarTool alterTabBarToKtvBookingController];
            }
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}
@end
