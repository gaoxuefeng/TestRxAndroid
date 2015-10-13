//
//  CSDishDetailViewController.m
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSDishDetailViewController.h"
#import <Masonry.h>
#import "CSRoomDetailCell.h"
#import "UIImage+Extension.h"
#import "SVProgressHUD.h"
#import "CSCancelRoomViewController.h"
#import "CSMyInfoHttpTool.h"
#import "CSDishOrderDishesView.h"
#import "CSOrderDishPayViewController.h"
#import "SVProgressHUD.h"
@interface CSDishDetailViewController ()<UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
}
//@property(nonatomic, weak) UIButton *paiedBtn;
@property(nonatomic, weak) UIButton *cancelButton;
@property(weak, nonatomic) UIView *buttonContainer;
@property(weak, nonatomic) UIView *cancelOrPayView;
@property(nonatomic, weak) CSRoomDetailCell *orderIdCell;
@property(nonatomic, weak) CSRoomDetailCell *orderManCell;
@property(nonatomic, weak) CSRoomDetailCell *phoneNumCell;
@property(nonatomic, weak) CSRoomDetailCell *topicCell;
@property(nonatomic, weak) CSRoomDetailCell *dateCell;
@property(nonatomic, weak) CSRoomDetailCell *boxCell;
@property(nonatomic, weak) CSDishOrderDishesView *dishesView;
@property(nonatomic, weak) UIView *priceCell;
@property(nonatomic, weak) UILabel *priceLabel;
@property(nonatomic, weak) CSRoomDetailCell *shopCell;
@property(nonatomic, weak) CSRoomDetailCell *addressCell;
@property(nonatomic, weak) UILabel *statusLabel;
@property(nonatomic, strong) NSString *orderId;
@property(strong, nonatomic) CSRoomDetailModel *orderDetail;
@end

@implementation CSDishDetailViewController

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
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel.superview);
        make.top.equalTo(titleLabel.superview).offset(31.0);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom
                            ];
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
//    containerBgView.autoresizingMask = UIViewAutoresizingNone;
    containerBgView.translatesAutoresizingMaskIntoConstraints = NO;
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
    CGFloat hPadding = TRANSFER_SIZE(15.0);
    
    // 订单编号
    CSRoomDetailCell *orderIdCell = [[CSRoomDetailCell alloc] initWithTitle:@"订单号"];
    orderIdCell.titleColor = HEX_COLOR(0xccb6bf);
    orderIdCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:orderIdCell];
    [orderIdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderIdCell.superview).offset(40.0);
        make.left.equalTo(orderIdCell.superview).offset(hPadding + padding);
    }];
    _orderIdCell = orderIdCell;
    // 预约人
    CSRoomDetailCell *orderManCell = [[CSRoomDetailCell alloc] initWithTitle:@"预约人"];
    orderManCell.titleColor = HEX_COLOR(0xccb6bf);
    orderManCell.contentColor = HEX_COLOR(0xccb6bf);
    orderManCell.contentLabel.numberOfLines = 1;
    [container addSubview:orderManCell];
    
    [orderManCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderIdCell.mas_bottom).offset(topPadding);
        make.left.equalTo(orderIdCell.superview).offset(hPadding + padding);
        make.width.mas_lessThanOrEqualTo(TRANSFER_SIZE(130.0));
    }];
    _orderManCell = orderManCell;
    
    // 联系电话
    CSRoomDetailCell *phoneNumCell = [[CSRoomDetailCell alloc] initWithTitle:@"联系电话"];
    phoneNumCell.titleColor = HEX_COLOR(0xc1b652);
    phoneNumCell.contentColor = HEX_COLOR(0xc1b652);
    [container addSubview:phoneNumCell];
    [phoneNumCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderIdCell.mas_bottom).offset(topPadding);
//        make.left.equalTo(phoneNumCell.superview).offset(AUTOLENGTH(128.0) + padding);
        make.left.greaterThanOrEqualTo(orderManCell.mas_right).offset(-TRANSFER_SIZE(2.0));
        make.left.greaterThanOrEqualTo(phoneNumCell.superview).offset(AUTOLENGTH(150.0) + padding);
    }];
    _phoneNumCell = phoneNumCell;
    
    // 房间
    CSRoomDetailCell *boxCell = [[CSRoomDetailCell alloc] initWithTitle:@"房间"];
    boxCell.titleColor = HEX_COLOR(0xccb6bf);
    boxCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:boxCell];
    [boxCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumCell.mas_bottom).offset(topPadding);
        make.left.equalTo(boxCell.superview).offset(hPadding + padding);
    }];
    _boxCell = boxCell;
    
    // 下单时间
    CSRoomDetailCell *dateCell = [[CSRoomDetailCell alloc] initWithTitle:@"下单时间"];
    dateCell.titleColor = HEX_COLOR(0xccb6bf);
    dateCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:dateCell];
    [dateCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxCell.mas_bottom).offset(TRANSFER_SIZE(30.0));
        make.left.equalTo(dateCell.superview).offset(hPadding + padding);
    }];
    _dateCell = dateCell;
    
    // 上分割线
    UIView *upDivider = [[UIView alloc] init];
    upDivider.backgroundColor = HEX_COLOR(0x692642);
    [container addSubview:upDivider];
    CGFloat v_padding = TRANSFER_SIZE(25.0);
    [upDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateCell.mas_bottom).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(upDivider.superview).offset(v_padding);
        make.right.equalTo(upDivider.superview).offset(-v_padding);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
    
    // 菜品列表
    CSDishOrderDishesView *dishesView = [[CSDishOrderDishesView alloc] init];
    [container addSubview:dishesView];
    _dishesView = dishesView;
    [dishesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upDivider.mas_bottom).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(dishesView.superview).offset(15.0 + padding);
        make.right.equalTo(dishesView.superview).offset(-(15.0 + padding));
    }];
    
    // 下分割线
    UIView *bottomDivider = [[UIView alloc] init];
    bottomDivider.backgroundColor = HEX_COLOR(0x692642);
    [container addSubview:bottomDivider];
//    CGFloat v_padding = TRANSFER_SIZE(25.0);
    [bottomDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dishesView.mas_bottom).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(bottomDivider.superview).offset(v_padding);
        make.right.equalTo(bottomDivider.superview).offset(-v_padding);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];


    UIView *priceCell = [[UIView alloc] init];
    [container addSubview:priceCell];
        [priceCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomDivider.mas_bottom).offset(topPadding);
            make.left.equalTo(priceCell.superview).offset(hPadding + padding);
            make.right.equalTo(priceCell.superview).offset(TRANSFER_SIZE(-(hPadding + padding)));
        }];
    _priceCell = priceCell;
    UILabel *priceTitleLabel = [[UILabel alloc] init];
    priceTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16.0)];
    priceTitleLabel.textColor = HEX_COLOR(0xffffff);
    priceTitleLabel.text = @"合计金额";
    
    [priceCell addSubview:priceTitleLabel];
    [priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(priceTitleLabel.superview);
    }];

    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16.0)];
    priceLabel.textColor = HEX_COLOR(0xeeff62);
    
    [priceCell addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(priceLabel.superview);
        make.right.equalTo(priceLabel.superview).offset(-TRANSFER_SIZE(8.0));
    }];
    _priceLabel = priceLabel;
    
    // 门店
    CSRoomDetailCell *shopCell = [[CSRoomDetailCell alloc] initWithTitle:@"门店:"];
    shopCell.type = CSRoomDetailCellTypeParallel;
    shopCell.titleColor = HEX_COLOR(0xccb6bf);
    shopCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:shopCell];
    [shopCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceCell.mas_bottom).offset(topPadding);
        make.left.equalTo(shopCell.superview).offset(hPadding + padding);
        make.right.equalTo(shopCell.superview).offset(-hPadding - padding);
    }];
    _shopCell = shopCell;
    
    // 地址
    CSRoomDetailCell *addressCell = [[CSRoomDetailCell alloc] initWithTitle:@"地址:"];
    addressCell.type = CSRoomDetailCellTypeParallel;
    addressCell.titleColor = HEX_COLOR(0xccb6bf);
    addressCell.contentColor = HEX_COLOR(0xccb6bf);
    [container addSubview:addressCell];
    [addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopCell.mas_bottom).offset(topPadding);
        make.left.equalTo(addressCell.superview).offset(hPadding + padding);
        //        make.bottom.equalTo(addressCell.superview).offset(-20.0);
        make.right.equalTo(addressCell.superview).offset(-hPadding - padding);
    }];
    _addressCell = addressCell;
    
    [containerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        make.centerX.equalTo(statusLabel.superview.mas_right).offset(iPhone6?-32:(iPhone6Plus?-26.0:-TRANSFER_SIZE(27.0)));
        make.centerY.equalTo(statusLabel.superview.mas_top).offset(iPhone6?32:(iPhone6Plus?26.0:TRANSFER_SIZE(27.0)));
    }];
    _statusLabel = statusLabel;
    
    // 按钮区域
    UIView *buttonContainer = [[UIView alloc] init];
    [container addSubview:buttonContainer];
    //    buttonContainer.backgroundColor = [UIColor yellowColor];
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressCell.mas_bottom).offset(TRANSFER_SIZE(25.0));
        make.right.left.bottom.equalTo(buttonContainer.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(82.0));
    }];
    _buttonContainer = buttonContainer;
    
    CGFloat radius = TRANSFER_SIZE(19.5);
    CGFloat cancelButtonHPadding = TRANSFER_SIZE(60.0);
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消预订" forState:UIControlStateNormal];
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
    _cancelButton = cancelButton;
    
    UIView *cancelOrPayView = [[UIView alloc] init];
    _cancelOrPayView = cancelOrPayView;
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

    
}





#pragma mark - Load data
- (void)loadData
{
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveGoodsId = _orderId;
    
    [SVProgressHUD show];
    [CSMyInfoHttpTool getDishCostDetailWithParam:param success:^(CSRoomDetailResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            _orderDetail = result.data;
            _orderIdCell.content = _orderId;
            _orderManCell.content = result.data.useName;
            _phoneNumCell.content = result.data.phoneNum;
            _dateCell.content = result.data.orderTime;
            _boxCell.content = result.data.roomNum;
            _priceLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:[result.data.sumPrice floatValue]]];
            _shopCell.content = result.data.KTVName;
            _addressCell.content = result.data.address;
            _dishesView.dishes = result.data.goodsList;
            NSString *statusStr;
            switch (result.data.payState) {
                case CSMyCostDishStatusTypeNotPay:
                    statusStr = @"未支付";
                    _cancelOrPayView.hidden = NO;
                    _buttonContainer.hidden = YES;
                    break;
                case CSMyCostDishStatusTypeHasPay:
                    statusStr = @"已支付";
                    _cancelOrPayView.hidden = YES;
                    _buttonContainer.hidden = NO;
                    _cancelButton.enabled = NO;
                    [_cancelButton setTitle:@"已支付" forState:UIControlStateDisabled];
//                    [self changeDateToTimeInterval:result.data.orderTime];
                    break;
                case CSMyCostDishStatusTypeRefunding:
                    statusStr = @"退款中";
                    _cancelOrPayView.hidden = YES;
                    _buttonContainer.hidden = NO;
                    _cancelButton.enabled = NO;
                    [_cancelButton setTitle:@"退款中" forState:UIControlStateDisabled];
                    break;
                case CSMyCostDishStatusTypeDone:
                    statusStr = @"已消费";
                    _cancelOrPayView.hidden = YES;
                    _buttonContainer.hidden = NO;
                    _cancelButton.enabled = NO;
                    [_cancelButton setTitle:@"已消费" forState:UIControlStateDisabled];
                    break;
                case CSMyCostDishStatusTypeCanceled:
                    statusStr = @"已取消";
                    _cancelOrPayView.hidden = YES;
                    _buttonContainer.hidden = NO;
                    _cancelButton.enabled = NO;
                    [_cancelButton setTitle:@"已取消" forState:UIControlStateDisabled];
                    break;
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
//- (void)changeDateToTimeInterval:(NSString*)startTime
//{
////    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
////    [userDefaults setObject:result.data.rbStartTime forKey:@"roomStartTime"];
////    [userDefaults synchronize];
//    CSMyRoomInfoModel *roomModel = GlobalObj.myRooms.firstObject;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate * startDate = [formatter dateFromString:startTime];
//    NSInteger between =  roomModel.rbStartTime.integerValue - startDate.timeIntervalSince1970;
//    if (between >0 && between < 3600) {
//        [_cancelButton setTitle:@"即将开始" forState:UIControlStateDisabled];
//        _cancelButton.enabled = NO;
//    }else if (between < 0){
//        [_cancelButton setTitle:@"已消费" forState:UIControlStateDisabled];
//        _cancelButton.enabled = NO;
//    }
//}


#pragma mark - Action
- (void)backBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelBtnPressed:(UIButton *)button
{
    UIAlertView *cancelAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否取消订单" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [cancelAlertView show];
}

- (void)payBtnPressed:(UIButton *)button
{
    CSOrderDishPayViewController *dishPayVc = [[CSOrderDishPayViewController alloc] initWithType:CSDishPayViewControllerTypeRepay];
    CSKTVDishListResponseDataModel *dishListModel = [[CSKTVDishListResponseDataModel alloc] init];
    dishListModel.goodsList = _orderDetail.goodsList;
    dishListModel.sumPrice = _orderDetail.sumPrice;
    dishListModel.roomName = _orderDetail.roomNum;
    dishListModel.reserveGoodsId = _orderId;
    dishPayVc.data = dishListModel;
    
    __weak typeof(self) weakSelf = self;
    
    dishPayVc.payBlock = ^(BOOL paySuccess)
    {
        weakSelf.cancelButton.enabled = NO;
        weakSelf.buttonContainer.hidden = NO;
        weakSelf.cancelOrPayView.hidden = YES;
        [weakSelf.cancelButton setTitle:@"已支付" forState:UIControlStateDisabled];
        weakSelf.payStatusChanged(CSMyCostDishStatusTypeHasPay);
//        [weakSelf changeDateToTimeInterval:weakSelf.orderDetail.orderTime];
    };
    [self.navigationController pushViewController:dishPayVc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _orderId;
    [CSMyInfoHttpTool cancelOrderWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            self.payStatusChanged(CSMyCostDishStatusTypeCanceled);
            if (_orderDetail.payState == CSMyCostDishStatusTypeNotPay) {
                _statusLabel.text = @"已取消";
                _cancelButton.enabled = NO;
                _buttonContainer.hidden = NO;
                _cancelOrPayView.hidden = YES;
                [_cancelButton setTitle:@"已取消" forState:UIControlStateDisabled];
                [SVProgressHUD showSuccessWithStatus:@"订单取消成功"];
            }else
            {
                _statusLabel.text = @"退款中";
                [_cancelButton setTitle:@"退款中" forState:UIControlStateDisabled];
                _cancelButton.enabled = NO;
                _buttonContainer.hidden = NO;
                _cancelOrPayView.hidden = YES;
                CSCancelRoomViewController *cancelRoomVc = [[CSCancelRoomViewController alloc] initWithPrice:[_orderDetail.sumPrice floatValue]];
                [self.navigationController pushViewController:cancelRoomVc animated:YES];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}


@end
