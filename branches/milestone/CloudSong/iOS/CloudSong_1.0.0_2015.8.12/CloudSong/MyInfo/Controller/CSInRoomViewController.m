//
//  CSInRoomViewController.m
//  CloudSong
//
//  Created by sen on 15/6/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInRoomViewController.h"
#import "CSOrderDishViewController.h"
#import "CSSelectedSongController.h"
#import <Masonry.h>
#import "UMSocial.h"
#import <WXApi.h>
#import "UMSocialDataService.h"
#import <UMSocialQQHandler.h>
#import "CSWeiboShareEditViewController.h"
#import "CSChatToolBar.h"
#import "CSInRoomDetailViewController.h"
#import "CSVODViewController.h"
#import "CSOrderDishViewController.h"
#import "CSRemoteControlViewController.h"
#import "CSNavigationController.h"
#import "CSChatExtensionView.h"
#import "CSActionSheet.h"
#import "CSSendDoodleViewController.h"
#import "CSMusicStateView.h"
#import "CSChatMessageModel.h"
#import "CSMessageTableViewCell.h"
#import "CSRoomStateTableViewCell.h"
#import "CSMessagePictureTableViewCell.h"
#import "CSRoomHttpTool.h"
#import "CSQRImageViewController.h"
#import "CSQRCodeReadViewController.h"
#import "SVProgressHUD.h"
#import <MobClick.h>
#import "CSSendFaceViewController.h"

#define INVITE_HTML @"http://yunge.ethank.com.cn/ethank-yunge-deploy/html/market/invite-ktv.html"
typedef enum {
    CSShareTypeWeibo,
    CSShareTypeWechat,
    CSShareTypeQQ,
    CSShareTypeTimeLine
}CSShareType;
@interface CSInRoomViewController ()<UITableViewDataSource,UITableViewDelegate,CSChatToolBarDelegate,CSChatExtensionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CSActionSheetDelegate,UIAlertViewDelegate>
{
    UITableView *_chatTableView;
}
@property(nonatomic, weak) CSMusicStateView *musicStateView;

@property(nonatomic, strong) NSMutableArray *messages;

@property(nonatomic, strong) NSArray *circleColors;

@property(nonatomic, strong) NSMutableArray *shareTypes;
@property(nonatomic, copy) NSString *shareTitle;
@property(nonatomic, copy) NSString *shareContent;
@property(nonatomic, copy) UIImage *shareImage;

@property(nonatomic, weak) UIButton *cover;

@property(nonatomic, weak) UIView *shareView;

@property(nonatomic, weak) UIView *container;

@property(nonatomic, weak) MASConstraint *shareViewBottomY;

@property(nonatomic, weak) CSChatToolBar *chatToolBar;

@property(nonatomic, strong) CSChatExtensionView *extensionView;

@property(nonatomic, assign,getter=isShowToolExtension) BOOL showToolExtension;

@property(nonatomic, strong) CSMessageTableViewCell *calculateCell;

@property(nonatomic, weak) UIButton *selectSongButton;
@property(nonatomic, weak) UIButton *remoteControlButton;
@property(nonatomic, weak) UIButton *shoppingButton;
@property(nonatomic, weak) UIButton *qrButton;

@property(nonatomic, strong) CSMyRoomInfoModel *roomInfo;

@end

@implementation CSInRoomViewController


- (CSChatExtensionView *)extensionView
{
    if (!_extensionView) {
        CSChatExtensionView *extensionView = [[CSChatExtensionView alloc] init];
        extensionView.delegate = self;
        [self.view addSubview:extensionView];
        [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(extensionView.superview);
            make.top.equalTo(_container.mas_bottom);
            make.height.mas_equalTo(TRANSFER_SIZE(88.0));
        }];
        _extensionView = extensionView;
    }
    return _extensionView;
}
- (NSMutableArray *)shareTypes
{
    if (!_shareTypes) {
        NSMutableArray *array  = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:CSShareTypeWeibo]];
        if ([WXApi isWXAppInstalled]) {
            [array addObject:[NSNumber numberWithInteger:CSShareTypeWechat]];
            [array addObject:[NSNumber numberWithInteger:CSShareTypeQQ]];
            [array addObject:[NSNumber numberWithInteger:CSShareTypeTimeLine]];
        }else
        {
            [array addObject:[NSNumber numberWithInteger:CSShareTypeQQ]];
        }
        _shareTypes = array;
    }
    return _shareTypes;
}
- (NSArray *)circleColors
{
    if (!_circleColors) {
        _circleColors = @[HEX_COLOR(0xfdb57e),HEX_COLOR(0xf57967),HEX_COLOR(0xa3d588),HEX_COLOR(0x6ad5d5),HEX_COLOR(0xaca2e3),HEX_COLOR(0xf18eba)];
    }
    return _circleColors;
}
- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR(0x1b162f);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubViews];
    
    [self configNavigationItem];
    
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGr];
//    [self chatToolBarSpreadButtonPressed];///
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRoomData) name:USER_ROOM_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    if (self.messages.count) {
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    [_musicStateView startAnimation];
    // 房间状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomStatusChanged) name:ROOM_STATUS_CHANGED object:nil];
    [self loadRoomData];
    [self loadStatusDataWithNoAnimation];
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self tap];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ROOM_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_ROOM_UPDATED object:nil];
    [super viewWillDisappear:animated];
}



#pragma mark - Setup
- (void)setupSubViews
{
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0,  TRANSFER_SIZE(26.0), self.view.width, SCREENHEIGHT - 64.0 - 49.0 - TRANSFER_SIZE(26.0));
    [self.view addSubview:container];
    _container = container;
    [self setupMusicStateView];
    [self setupChatTableView];
    [self setupChatToolBar];
    [self setupButtons];
}

- (void)setupMusicStateView
{
    CSMusicStateView *musicStateView = [[CSMusicStateView alloc] init];
    musicStateView.backgroundColor = HEX_COLOR(0x261f40);
    [self.view addSubview:musicStateView];
    [musicStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(musicStateView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(26.0));
    }];
    musicStateView.text = @"当前暂无歌曲";
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = HEX_COLOR(0x1d123c);
    [self.view addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(divider.superview);
        make.top.equalTo(musicStateView.mas_bottom);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
    _musicStateView = musicStateView;
}

- (void)setupChatTableView
{
    _chatTableView = [[UITableView alloc] init];
    NSString *backgroundImageName = nil;
    if (iPhone4) {
        backgroundImageName = @"room_bg_4";
    }else if(iPhone5)
    {
        backgroundImageName = @"room_bg_5";
    }else if(iPhone6)
    {
        backgroundImageName = @"room_bg_6";
    }else
    {
        backgroundImageName = @"room_bg_6p";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    _chatTableView.backgroundView = imageView;
    [_container addSubview:_chatTableView];
    _chatTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    _chatTableView.allowsSelection = NO;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    [_chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(_chatTableView.superview);
//        make.top.equalTo(_musicStateView.mas_bottom);
    }];
//    
    CGFloat insetY = TRANSFER_SIZE(10.0);
    _chatTableView.contentInset = UIEdgeInsetsMake(insetY, 0, TRANSFER_SIZE(100), 0);
}

- (void)setupChatToolBar
{
    CSChatToolBar *chatToolBar = [[CSChatToolBar alloc] init];
    chatToolBar.delegate = self;
    [_container addSubview:chatToolBar];
    [chatToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TRANSFER_SIZE(40.0));
        make.left.right.equalTo(chatToolBar.superview);
        make.bottom.equalTo(chatToolBar.superview);
    }];
    _chatToolBar = chatToolBar;
}

- (void)setupButtons
{
    // 点歌按钮
    UIButton *selectSongButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectSongButton addTarget:self action:@selector(selectSongBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [selectSongButton setBackgroundImage:[UIImage imageNamed:@"room_selectsong_normal_button"] forState:UIControlStateNormal];
    [selectSongButton setBackgroundImage:[UIImage imageNamed:@"room_selectsong_pressed_button"] forState:UIControlStateHighlighted];
    [_container addSubview:selectSongButton];
    _selectSongButton = selectSongButton;
    
    // 遥控按钮
    UIButton *remoteControlButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [remoteControlButton addTarget:self action:@selector(remoteControlBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [remoteControlButton setBackgroundImage:[UIImage imageNamed:@"room_remote_normal_button"] forState:UIControlStateNormal];
    [remoteControlButton setBackgroundImage:[UIImage imageNamed:@"room_remote_pressed_button"] forState:UIControlStateHighlighted];
    [remoteControlButton setBackgroundImage:[UIImage imageNamed:@"room_remote_disabled_button"] forState:UIControlStateDisabled];
    [_container addSubview:remoteControlButton];
    _remoteControlButton = remoteControlButton;
    
    // 超市按钮
    UIButton *orderDishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [orderDishButton addTarget:self action:@selector(orderDishBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [orderDishButton setBackgroundImage:[UIImage imageNamed:@"room_market_normal_button"] forState:UIControlStateNormal];
    [orderDishButton setBackgroundImage:[UIImage imageNamed:@"room_market_pressed_button"] forState:UIControlStateHighlighted];
    [_container addSubview:orderDishButton];
    _shoppingButton = orderDishButton;
    

    CGFloat marginX = TRANSFER_SIZE(13.0);
    [remoteControlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(remoteControlButton.superview);
        make.bottom.equalTo(_chatToolBar.mas_top);
    }];
    
    [selectSongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remoteControlButton.mas_top);
        make.right.equalTo(remoteControlButton.mas_left).offset(-marginX);
        make.width.equalTo(remoteControlButton.mas_width);
    }];

    [orderDishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remoteControlButton.mas_top);
        make.left.equalTo(remoteControlButton.mas_right).offset(marginX);
        make.width.equalTo(remoteControlButton.mas_width);
    }];
}
#pragma mark - Config
- (void)configNavigationItem
{
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPwdButton addTarget:self action:@selector(inviteFriendBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    forgetPwdButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [forgetPwdButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    [forgetPwdButton setTitleColor:HEX_COLOR(0xd0d0d4) forState:UIControlStateNormal];
    [forgetPwdButton sizeToFit];
    
    // 二维码
    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [qrButton addTarget:self action:@selector(qrButtonPressed)forControlEvents:UIControlEventTouchUpInside];
    [qrButton setBackgroundImage:[UIImage imageNamed:@"room_qr-code_icon"] forState:UIControlStateNormal];
    [qrButton setBackgroundImage:[UIImage imageNamed:@"room_no_qr_code_icon"] forState:UIControlStateDisabled];
    [qrButton sizeToFit];
    _qrButton = qrButton;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:qrButton];
    
    
//    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"临时关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed)];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forgetPwdButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self.navigationController.navigationBar setBarTintColor:HEX_COLOR(0x1b162f)];
}

- (void)configShareContent
{
    self.shareTitle = @"潮趴汇";
    [NSString stringWithFormat:@"来来来,K歌聚起来!我在潮趴汇上预订了%@K歌活动,诚邀各位参与!",_roomInfo.ktvName];
    self.shareImage = [UIImage imageNamed:@"share_icon"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSChatMessageModel *messageModel = self.messages[indexPath.row];
    switch (messageModel.type) {
        case CSChatMessageTypeMessage:
        {
            CSMessageTableViewCell *cell = [CSMessageTableViewCell cellWithTableView:tableView];
            cell.item = messageModel;
            cell.bottomLineHidden = indexPath.row == self.messages.count - 1;
            cell.topLineHidden = indexPath.row == 0;
            return cell;
        }
        case CSChatMessageTypeRoomState:
        {
            CSRoomStateTableViewCell *cell = [CSRoomStateTableViewCell cellWithTableView:tableView];
            cell.item = messageModel;
            cell.hiddenLine = indexPath.row == self.messages.count - 1 || indexPath.row == 0;
            return cell;
        }
        case CSChatMessageTypePicture:
        {
            CSMessagePictureTableViewCell *cell = [CSMessagePictureTableViewCell cellWithTableView:tableView];
            cell.item = messageModel;
            cell.bottomLineHidden = indexPath.row == self.messages.count - 1;
            cell.topLineHidden = indexPath.row == 0;
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;

//    cell.circleColor = self.circleColors[indexPath.row % self.circleColors.count];
//    if (indexPath.row == self.messages.count - 1) {
//        cell.hiddenVLine = YES;
//    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSChatMessageModel *messageModel = self.messages[indexPath.row];
    switch (messageModel.type) {
        case CSChatMessageTypeMessage:
        {
            if (!_calculateCell) {
                _calculateCell = [[CSMessageTableViewCell alloc] init];
            }
            _calculateCell.item = messageModel;
            _calculateCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(_calculateCell.bounds));
            [_calculateCell setNeedsLayout];
            [_calculateCell layoutIfNeeded];
            
            CGFloat height = [_calculateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            //    height += 1;
            return height;
        }
        case CSChatMessageTypeRoomState:
            return TRANSFER_SIZE(30.0);
        case CSChatMessageTypePicture:
            return TRANSFER_SIZE(95.0);
    }
}

#pragma mark - CSChatToolBarDelegate
- (void)chatToolBarInputTextFieldPressed:(CSChatToolBar *)chatToolBar
{
    _extensionView.hidden = YES;
    self.showToolExtension = NO;
}
#pragma mark 发送文本
- (void)chatToolBarSendButtonPressedWithText:(NSString *)sendText
{
    [MobClick event:@"RoomSendText"];
    CSRequest *param = [[CSRequest alloc] init];
    param.msgType = [NSNumber numberWithInteger:CSMessageTypeText];
    param.msgContent = sendText;
    param.reserveBoxId = _roomInfo.reserveBoxId;
    [CSRoomHttpTool sendChatMessageWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
//            [self loadStatusData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)chatToolBarSpreadButtonPressed
{
    [MobClick event:@"RoomSendNoText"];
    self.showToolExtension = YES;
    [self.view endEditing:YES];
    
    self.extensionView.hidden = NO;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 delay:0.0 options:7 << 16 animations:^{
        _container.y = - TRANSFER_SIZE(88.0 - 26.0);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.showToolExtension = NO;
    }];
}

#pragma mark - CSChatExtensionViewDelegate
- (void)chatExtensionView:(CSChatExtensionView *)chatExtensionView extensionButtonPressed:(CSChatExtensionType)type
{
    switch (type) {
        case CSChatExtensionTypeMagicFace:
            [MobClick event:@"RoomSendEmoji"];
//            [SVProgressHUD showErrorWithStatus:@"敬请期待"];
            [self sendFaceBtnPressed];
            break;
        case CSChatExtensionTypePhoto:
            [MobClick event:@"RoomSendImg"];
            [self sendPictureBtnPressed];
            break;
        case CSChatExtensionTypeDoodle:
            [MobClick event:@"RoomSendPainting"];
            [self sendDoodleBtnPressed];
            break;
        default:
            break;
    }
}

#pragma mark - Action

- (void)roomStatusChanged
{
    [self loadStatusData];
}

- (void)keyboardFrameWillChanged:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.showToolExtension) return;
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        if (keyboardY != SCREENHEIGHT) {
            _container.y = keyboardY - _container.height - 64.0;
        }else
        {
            _container.y = 0;
        }
        
    } completion:^(BOOL finished) {
    }];
}

- (void)tap
{
    [self.view endEditing:YES];
//    if (self.isShowToolExtension) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 delay:0.0 options:7 << 16 animations:^{
            _container.y = TRANSFER_SIZE(26.0);
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.showToolExtension = NO;
            self.extensionView.hidden = YES;
        }];
//    }
    
}
//点歌
- (void)selectSongBtnOnClick
{
    [self tap];
    [MobClick event:@"RoomRequestSong"];
    CSNavigationController *navVc = [[CSNavigationController alloc] initWithRootViewController:[[CSVODViewController alloc] init]];
    [self presentViewController:navVc animated:YES completion:nil];
}
//超市
- (void)orderDishBtnOnClick
{
    [self tap];
    [MobClick event:@"RoomSuperMarket"];
    CSOrderDishViewController *orderDishVc = [[CSOrderDishViewController alloc] initWithReserveBoxId:_roomInfo.reserveBoxId];
    CSNavigationController *navVc = [[CSNavigationController alloc] initWithRootViewController:orderDishVc];
    [self presentViewController:navVc animated:YES completion:nil];
}
//遥控
- (void)remoteControlBtnOnClick
{
    if (![GlobalObj.selectedId isEqualToString:_roomInfo.reserveBoxId]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请扫描点歌台上的二维码绑定房间后继续操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    [self tap];
    [MobClick event:@"RoomControl"];
    CSRemoteControlViewController *remoteControlVc = [[CSRemoteControlViewController alloc] initWithRoomInfo:_roomInfo];
    CSNavigationController *navVc = [[CSNavigationController alloc] initWithRootViewController:remoteControlVc];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)titleViewOnClick:(UIButton *)button
{
    CSInRoomDetailViewController *roomDetailVc = [[CSInRoomDetailViewController alloc] initWithReserveBoxId:_roomInfo.reserveBoxId];
    [self.navigationController pushViewController:roomDetailVc animated:YES];
}
- (void)inviteFriendBtnOnClick:(UIButton *)button
{
    [MobClick event:@"RoomInvite"];
    [self tap];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *cover = [[UIButton alloc] init];
    [cover addTarget:self action:@selector(cancelInvateFriend) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    _cover = cover;
    
    UIView *shareView = [[UIView alloc] init];
    _shareView = shareView;
    shareView.backgroundColor = HEX_COLOR(0x141417);
    
    [window addSubview:cover];
    [window addSubview:shareView];
    
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cover.superview);
    }];
    
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(shareView.superview);
        _shareViewBottomY = make.top.equalTo(shareView.superview.mas_bottom);
        make.height.mas_equalTo(89.0);
    }];
    
    CGFloat shareButtonWidth = SCREENWIDTH / self.shareTypes.count;
    for (int i = 0; i < self.shareTypes.count; i++) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSNumber *number = self.shareTypes[i];
        shareButton.tag = [number integerValue];
        [shareButton addTarget:self action:@selector(shareBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *shareImage = nil;
        switch ([number integerValue]) {
            case CSShareTypeWeibo:
                shareImage = @"player_weibo_icon";
                break;
            case CSShareTypeWechat:
                shareImage = @"player_wechat_icon";
                break;
            case CSShareTypeQQ:
                shareImage = @"player_qq_icon";
                break;
            case CSShareTypeTimeLine:
                shareImage = @"player_friends_icon";
                break;
            default:
                break;
        }
        [shareButton setImage:[[UIImage imageNamed:shareImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [shareView addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(shareButtonWidth);
            make.height.equalTo(shareButton.superview.mas_height);
            make.centerY.equalTo(shareButton.superview);
            make.left.equalTo(shareButton.superview).offset(i * shareButtonWidth);
        }];
    }
    [window layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _shareViewBottomY.offset = -(shareView.height);
        cover.alpha = 0.5;
        [window layoutIfNeeded];
    } completion:nil];
}
#pragma mark 发送图片
- (void)sendPictureBtnPressed
{
    CSActionSheet *actionSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    [actionSheet show];
}

#pragma mark  发送魔法表情
- (void)sendFaceBtnPressed
{
    
    CSSendFaceViewController *sendFaceVc = [[CSSendFaceViewController alloc] init];
    [self presentViewController:sendFaceVc animated:YES completion:^{
        
    }];
//    CSRequest *param = [[CSRequest alloc] init];
//    param.msgType = [NSNumber numberWithInteger:CSMessageTypeText];
//    param.msgContent = sendText;
//    param.reserveBoxId = _roomInfo.reserveBoxId;
//    [CSRoomHttpTool sendChatMessageWithParam:param success:^(CSBaseResponseModel *result) {
//        if (result.code == ResponseStateSuccess) {
//            //            [self loadStatusData];
//        }else
//        {
//            [SVProgressHUD showErrorWithStatus:result.message];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

#pragma mark 发送涂鸦
- (void)sendDoodleBtnPressed
{
    CSSendDoodleViewController *sendDoodleVc = [[CSSendDoodleViewController alloc] init];
    
    [self presentViewController:sendDoodleVc animated:YES completion:^{

    }];
}

- (void)qrButtonPressed
{
    [MobClick event:@"RoomQrCode"];
    CSQRImageViewController *qrImageVc = [[CSQRImageViewController alloc] initWithReserveBoxId:_roomInfo.reserveBoxId];
    CSNavigationController *navVc = [[CSNavigationController alloc] initWithRootViewController:qrImageVc];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)shareBtnOnClick:(UIButton *)button
{
    [self configShareContent];
    
    NSString *totalInviteUrl = [NSString stringWithFormat:@"%@?reserveBoxId=%@",INVITE_HTML,_roomInfo.reserveBoxId];
    switch (button.tag) {
        case CSShareTypeWeibo:
        {
            [self cancelInvateFriendForWeiboShare:YES];
            break;
        }
        case CSShareTypeWechat:
        {
            [self cancelInvateFriend];
            [UMSocialData defaultData].extConfig.wechatSessionData.url = totalInviteUrl;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享微信好友成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享微信好友失败！"];
                }
            }];
            break;
        }
        case CSShareTypeQQ:
        {
            [UMSocialData defaultData].extConfig.qqData.title =self.shareTitle;
            [UMSocialData defaultData].extConfig.qqData.url = totalInviteUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享QQ好友成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享QQ好友失败！"];
                }
            }];
            break;
        }
        case CSShareTypeTimeLine:
        {
            [self cancelInvateFriend];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = totalInviteUrl;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享朋友圈成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享朋友圈失败！"];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)cancelInvateFriend
{
    [self cancelInvateFriendForWeiboShare:NO];
}

- (void)cancelInvateFriendForWeiboShare:(BOOL)isWeiboShare;
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _shareViewBottomY.offset = 0.0;
        _cover.alpha = 0.0;
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [_cover removeFromSuperview];
        if (isWeiboShare) {
            CSWeiboShareEditViewController *weiboShareEditVc = [[CSWeiboShareEditViewController alloc] initWithRoomInfo:_roomInfo];
            [self.navigationController pushViewController:weiboShareEditVc animated:YES];
        }
    }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    CSQRCodeReadViewController *qrCodeReadVc = [[CSQRCodeReadViewController alloc] init];
    [self presentViewController:qrCodeReadVc animated:YES completion:nil];
}


#pragma mark - CSActionSheetDelegate
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) { // 拍照
        [self openCamera];
    }else   // 相册取照片
    {
        [self openAlbum];
    }
}

// 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

// 打开图册
- (void)openAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 0.1);
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    CSRequest *param = [[CSRequest alloc] init];
    param.picName = [NSString stringWithFormat:@"%.0f%d",[[NSDate date] timeIntervalSince1970],arc4random_uniform(10000)];
    param.msgType = [NSNumber numberWithInteger:CSMessageTypePicture];
    param.msgContent = imageString;
    param.reserveBoxId = _roomInfo.reserveBoxId;
    
    [CSRoomHttpTool sendChatMessageWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
//            [self loadStatusData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadRoomData
{
    CSMyRoomInfoModel *roomInfo = GlobalObj.myRooms.firstObject;
    if (_roomInfo.reserveBoxId != roomInfo.reserveBoxId) {
        [self.messages removeAllObjects];
    }
    _roomInfo = roomInfo;
    UIButton *titleView = [UIButton buttonWithType:UIButtonTypeSystem];
    [titleView addTarget:self action:@selector(titleViewOnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleView.hidden = roomInfo.roomName.length == 0 || roomInfo.joinCount.length == 0;
    [titleView setTitle:[NSString stringWithFormat:@"%@(%@)",roomInfo.roomName,roomInfo.joinCount] forState:UIControlStateNormal];
    titleView.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(18.0)];
    [titleView setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.title = roomInfo.roomName;

    _remoteControlButton.enabled = roomInfo.starting;
    _qrButton.enabled = roomInfo.starting;
    _chatToolBar.alpha = roomInfo.starting?1.0:0.7;
    _chatToolBar.userInteractionEnabled = roomInfo.starting;
}

#pragma mark - Load Data
- (void)loadStatusData
{
    CSRequest *param = [[CSRequest alloc] init];
    CSMyRoomInfoModel *room = GlobalObj.myRooms.firstObject;
    param.reserveBoxId = room.reserveBoxId;
    param.msgId = self.messages.count?[[self.messages lastObject] msgId]:@"0";
    [CSRoomHttpTool getRoomStatusWithParam:param success:^(CSChatMessageResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [self.messages addObjectsFromArray:result.data];
            [_chatTableView reloadData];
            if (self.messages.count>0) {
                [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }else
        {
//            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadStatusDataWithNoAnimation
{
    CSRequest *param = [[CSRequest alloc] init];
    CSMyRoomInfoModel *room = GlobalObj.myRooms.firstObject;
    param.reserveBoxId = room.reserveBoxId;
    param.msgId = self.messages.count?[[self.messages lastObject] msgId]:@"0";
    [CSRoomHttpTool getRoomStatusWithParam:param success:^(CSChatMessageResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [self.messages addObjectsFromArray:result.data];
            [_chatTableView reloadData];
            if (self.messages.count>0) {
                [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }else
        {
            //            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)dealloc
{
    _chatTableView.dataSource = nil;
    _chatTableView.delegate = nil;
}


@end
