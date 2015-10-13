//
//  CSInRoomDetailViewController.m
//  CloudSong
//
//  Created by sen on 15/7/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInRoomDetailViewController.h"
#import <Masonry.h>
#import "CSInRoomDetailCell.h"
#import "CSUserIconContainer.h"
#import "UIImage+Extension.h"
#import "CSCancelRoomViewController.h"
#import "CSRoomHttpTool.h"
#import "CSMyInfoHttpTool.h"
#import "SVProgressHUD.h"
@interface CSInRoomDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, copy) NSString *reserveBoxId;
/** 参与人数Label */
@property(nonatomic, weak) UILabel *actorNumLabel;

@property(nonatomic, weak) UIView *navBackgroundView;

@property(nonatomic, weak) UIButton *backButton;
/** 头像容器 */
@property(nonatomic, weak) CSUserIconContainer *iconContainer;
/** 地址 */
@property(nonatomic, weak) CSInRoomDetailCell *addressCell;
/** 门店名称 */
@property(nonatomic, weak) CSInRoomDetailCell *roomNameCell;
/** 包厢类型 */
@property(nonatomic, weak) CSInRoomDetailCell *roomTypeCell;
/** 预定时间 */
@property(nonatomic, weak) CSInRoomDetailCell *orderTimeCell;
/** 预订人 */
@property(nonatomic, weak) CSInRoomDetailCell *orderManCell;
/** 取消活动按钮 */
@property(nonatomic, weak) UIButton *cancelButton;

@property(nonatomic, weak) UILabel *navTitleLabel;

@property(nonatomic, weak) UILabel *topicLabel;

@property(nonatomic, weak) UILabel *countDownLabel;
/** 定时器 */
@property (strong, nonatomic) NSTimer *timer;

@property(nonatomic, strong) CSRoomInfoModel *roomInfo;
@end

@implementation CSInRoomDetailViewController

- (instancetype)initWithReserveBoxId:(NSString *)reserveBoxId
{
    _reserveBoxId = reserveBoxId;
    return [self init];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view bringSubviewToFront:_backButton];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self removeTimer];
    [super viewWillDisappear:animated];
}

#pragma mark - Setup
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview);
        make.width.mas_equalTo(container.superview);
    }];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"mine_box_detail_bg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [container addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(backgroundImageView.superview);
    }];
    
    UIImage *countDownBg = [[UIImage imageNamed:@"mine_box_details_title_bg"] resizedImage];
    
    UIImageView *countdownView = [[UIImageView alloc] init];
    countdownView.image = countDownBg;
    [container addSubview:countdownView];
    [countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countdownView.superview.mas_top).offset(24.0 + 64.0);
        make.left.equalTo(countdownView.superview.mas_left).offset(18.0);
        make.right.equalTo(countdownView.superview.mas_right).offset(-18.0);
        make.height.mas_equalTo(countDownBg.size.height);
    }];
    
    UILabel *countDownLabel = [[UILabel alloc] init];
    countDownLabel.textColor = HEX_COLOR(0xad190f);
    countDownLabel.font = [UIFont systemFontOfSize:14.0];
    _countDownLabel = countDownLabel;
    
    [countdownView addSubview:countDownLabel];
    [countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(countDownLabel.superview);
        make.centerY.equalTo(countDownLabel.superview).offset(-5.0);
    }];

    
    UIImageView *topicView = [[UIImageView alloc] init];
    topicView.image = [UIImage imageNamed: iPhone6?@"mine_box_detail_img_6":@"mine_box_detail_img"];
    [container addSubview:topicView];
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(topicView.image.size);
        make.centerX.equalTo(topicView.superview);
        make.top.equalTo(countdownView.mas_bottom).offset(23.0);
    }];
    
    UILabel *topicLabel = [[UILabel alloc] init];
//    topicLabel.text = @"哈哈哈哈哈哈哈哈哈";
    topicLabel.font = [UIFont systemFontOfSize:14.0];
    topicLabel.textColor = HEX_COLOR(0xe3dde3);
    [container addSubview:topicLabel];
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topicLabel.superview);
        make.bottom.equalTo(topicView.mas_bottom).offset(iPhone6?-20.0: -TRANSFER_SIZE(12.0));
    }];
    _topicLabel = topicLabel;
    
    CGFloat cellPadding = 13.0;
    CSInRoomDetailCell *orderManCell = [[CSInRoomDetailCell alloc] initWithTitle:@"预订人   :" icon:[UIImage imageNamed:@"mine_box_details_tri_1"]];
//    orderManCell.content = @"哈哈哈哈哈哈哈";
    [container addSubview:orderManCell];
    [orderManCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderManCell.superview).offset(30.0);
        make.right.equalTo(orderManCell.superview).offset(-30.0);
        make.top.equalTo(topicView.mas_bottom).offset(24.0);
    }];
    _orderManCell = orderManCell;
    
    CSInRoomDetailCell *orderTimeCell = [[CSInRoomDetailCell alloc] initWithTitle:@"预订时间:" icon:[UIImage imageNamed:@"mine_box_details_tri_2"]];
//    orderTimeCell.content = @"7月5日 星期一 9:00-12:00";
    [container addSubview:orderTimeCell];
    [orderTimeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderManCell.superview).offset(30.0);
        make.right.equalTo(orderManCell.superview).offset(-30.0);
        make.top.equalTo(orderManCell.mas_bottom).offset(cellPadding);
    }];
    _orderTimeCell = orderTimeCell;
    
    CSInRoomDetailCell *roomTypeCell = [[CSInRoomDetailCell alloc] initWithTitle:@"房间型号:" icon:[UIImage imageNamed:@"mine_box_details_tri_3"]];
//    roomTypeCell.content = @"豪华小包";
    [container addSubview:roomTypeCell];
    [roomTypeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomTypeCell.superview).offset(30.0);
        make.right.equalTo(roomTypeCell.superview).offset(-30.0);
        make.top.equalTo(orderTimeCell.mas_bottom).offset(cellPadding);
    }];
    _roomTypeCell = roomTypeCell;
    
    CSInRoomDetailCell *roomNameCell = [[CSInRoomDetailCell alloc] initWithTitle:@"门店名称:" icon:[UIImage imageNamed:@"mine_box_details_tri_4"]];
//    roomNameCell.content = @"十棵松牛逼店";
    [container addSubview:roomNameCell];
    [roomNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomNameCell.superview).offset(30.0);
        make.right.equalTo(roomNameCell.superview).offset(-30.0);
        make.top.equalTo(roomTypeCell.mas_bottom).offset(cellPadding);
    }];
    _roomNameCell = roomNameCell;
    
    CSInRoomDetailCell *addressCell = [[CSInRoomDetailCell alloc] initWithTitle:@"门店地址:" icon:[UIImage imageNamed:@"mine_box_details_tri_5"]];
//    addressCell.content = @"中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈中南海哈哈哈哈";
    [container addSubview:addressCell];
    [addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressCell.superview).offset(30.0);
        make.right.equalTo(addressCell.superview).offset(-30.0);
        make.top.equalTo(roomNameCell.mas_bottom).offset(cellPadding);
    }];
    _addressCell = addressCell;
    
    // 参与人数
    UILabel *actorNumLabel = [[UILabel alloc] init];
    actorNumLabel.textColor = HEX_COLOR(0x5e5250);
    actorNumLabel.font = [UIFont systemFontOfSize:11.0];
//    actorNumLabel.text = @"已加入6人";
    [container addSubview:actorNumLabel];
    [actorNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(actorNumLabel.superview);
        make.top.equalTo(addressCell.mas_bottom).offset(28.0);
    }];
    _actorNumLabel = actorNumLabel;
    
    UIView *actorNumLeftLine = [[UIView alloc] init];
    actorNumLeftLine.backgroundColor = HEX_COLOR(0x483a35);
    [container addSubview:actorNumLeftLine];
    [actorNumLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(actorNumLabel);
        make.height.mas_equalTo(1.0);
        make.left.equalTo(actorNumLeftLine.superview).offset(50.0);
        make.right.equalTo(actorNumLabel.mas_left).offset(-11.0);
    }];
    
    UIView *actorNumRightLine = [[UIView alloc] init];
    actorNumRightLine.backgroundColor = HEX_COLOR(0x483a35);
    [container addSubview:actorNumRightLine];
    [actorNumRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(actorNumLabel);
        make.height.mas_equalTo(1.0);
        make.right.equalTo(actorNumRightLine.superview).offset(-50.0);
        make.left.equalTo(actorNumLabel.mas_right).offset(11.0);
    }];
    
    
    // 头像显示区域
    CSUserIconContainer *iconContainer = [[CSUserIconContainer alloc] init];
    [container addSubview:iconContainer];
    [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(actorNumLabel.mas_bottom).offset(16.0);
        make.centerX.equalTo(iconContainer.superview);
//        make.width.mas_equalTo(SCREENWIDTH - 60.0);
    }];
    _iconContainer = iconContainer;
   
    // 取消活动按钮
    CGFloat cancelButtonRadius = 19.5;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消活动" forState:UIControlStateNormal];
    [cancelButton setTitleColor:HEX_COLOR(0x9f9ca0) forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[[[UIImage imageNamed:@"mine_box_details_cancel_bg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] resizedImage] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancelButton.layer.cornerRadius = cancelButtonRadius;
    cancelButton.layer.masksToBounds = YES;

    [container addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconContainer.mas_bottom).offset(32.0);
        make.left.equalTo(cancelButton.superview).offset(60.0);
        make.right.equalTo(cancelButton.superview).offset(-60.0);
        make.height.mas_equalTo(19.5 * 2);
        make.bottom.equalTo(cancelButton.superview).offset(-27.0);
    }];
    cancelButton.hidden = YES;
    _cancelButton = cancelButton;
    
    [self setupCustomNav];
    

}

/** 设置导航栏 */
- (void)setupCustomNav
{
    UIView *navBackgroundView = [[UIView alloc] init];
    navBackgroundView.backgroundColor = HEX_COLOR(0x1d1c21);
    [self.view addSubview:navBackgroundView];
    [navBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(navBackgroundView.superview);
        make.height.mas_equalTo(64.0);
    }];
    navBackgroundView.alpha = 0.0;
    _navBackgroundView = navBackgroundView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = [NSString stringWithFormat:@"%@详情",_roomNum];
    self.title = titleLabel.text;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel.superview);
        make.top.equalTo(titleLabel.superview).offset(31.0);
    }];
    _navTitleLabel = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[[UIImage imageNamed:@"room_detail_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.0, 80.0));
        make.left.top.equalTo(backButton.superview);
    }];
    _backButton = backButton;
}


#pragma mark - Load Data
- (void)loadData
{
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _reserveBoxId;
    
    [SVProgressHUD show];
    [CSRoomHttpTool getRoomInfoWithParam:param success:^(CSRoomInfoResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            _roomInfo = result.data;
            _iconContainer.items = result.data.avatarUrls;
            _actorNumLabel.text = [NSString stringWithFormat:@"已加入%ld人",result.data.avatarUrls.count];
            _addressCell.content = result.data.address;
            _roomNameCell.content = result.data.ktvName;
            _roomTypeCell.content = result.data.roomName;
            _orderManCell.content = result.data.reservationName;
            _navTitleLabel.text = [NSString stringWithFormat:@"%@详情",result.data.roomName];
            _topicLabel.text = [NSString stringWithFormat:@"%@的活动",result.data.ktvName];
            _orderTimeCell.content = result.data.time;
            _countDownLabel.text = result.data.countDownStr;
#warning 屏蔽取消按钮
//            _cancelButton.hidden = ![GlobalObj.userInfo.phoneNum isEqualToString:result.data.phoneNum];
//            _cancelButton.hidden = (result.data.serverTimeStamp.doubleValue - result.data.rbStartTime.doubleValue) > 0;
            [self changeDateToTimeInterval:result.data.rbStartTime];
            [self addTimer];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}
- (void)changeDateToTimeInterval:(NSString*)startTime
{
    NSDate * newDate = [NSDate date];
    NSInteger timeInterval = (long)[newDate timeIntervalSince1970];
    NSInteger between = startTime.integerValue - timeInterval;
    if (between >0 && between < 3600) {
        [_cancelButton setTitle:@"即将开始" forState:UIControlStateDisabled];
        _cancelButton.enabled = NO;
    }else if (between > 3600){
        [_cancelButton setTitle:@"取消活动" forState:UIControlStateNormal];
        _cancelButton.enabled = YES;
    }
}

#pragma mark - Action
- (void)backBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnPressed:(UIButton *)button
{
    UIAlertView *cancelAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"包厢已预留，真的要取消该订单么？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [cancelAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _reserveBoxId;
    [CSMyInfoHttpTool cancelOrderWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            CSCancelRoomViewController *cancelRoomVc = [[CSCancelRoomViewController alloc] initWithPrice:[_roomInfo.price floatValue]];
            [self.navigationController pushViewController:cancelRoomVc animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _navBackgroundView.alpha = scrollView.contentOffset.y / 100;
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    if (!_timer) {
        CGFloat duration = 1.0f;
        _timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)countDown
{
    _countDownLabel.text = _roomInfo.countDownStr;
}

- (void)networkReachability
{
    [super networkReachability];
    [self loadData];
}


@end
