 //
//  CSRemoteControlViewController.m
//  CloudSong
//
//  Created by sen on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRemoteControlViewController.h"
#import <Masonry.h>
#import <OBShapedButton.h>
#import "UIImage+Extension.h"
#import "CSOrderDishViewController.h"
#import "CSDefine.h"
#import "CSQRCodeReadViewController.h"
#import "YSCircleSelector.h"
#import <APService.h>
#import "CSRemoteControlHttpTool.h"
//#import "CSInteractionViewController.h"
#import "SVProgressHUD.h"
#import "UIImage+Extension.h"
#import "CSLoginViewController.h"
#import "CSMusicStateView.h"
#import <MobClick.h>
#import "CSMyRoomInfoModel.h"
typedef enum
{
    RemoteControlButtonTypeLight           =   1,        // 灯光
    RemoteControlButtonTypeSoundEffect     =   2,        // 唱效
    RemoteControlButtonTypeInteraction     =   3,        // 互动
    RemoteControlButtonTypeService         =   4,        // 服务
    RemoteControlButtonTypeOrderDish       =   5,        // 餐饮
    RemoteControlButtonTypeNextSong        = 101,        // 切歌
    RemoteControlButtonTypeReplay          = 107,        // 重唱
    RemoteControlButtonTypeSilence         = 103,        // 静音
    RemoteControlButtonTypePlayOrPause     = 106,        // 播放/暂停
    RemoteControlButtonTypeOrgOrAcco       = 102,        // 原唱或伴奏
    RemoteControlButtonTypeMicSoundDown    =   7,        // 麦克风音量减
    RemoteControlButtonTypeMicSoundUp      =   8,        // 麦克风音量增
    RemoteControlButtonTypeFlat            =   9,        // 降调
    RemoteControlButtonTypeSharp           =  10,        // 升调
    RemoteControlButtonTypeAccoSoundDown   = 105,        // 伴奏音量减
    RemoteControlButtonTypeAccoSoundUp     = 104,        // 伴奏音量增
    RemoteControlButtonTypeRecord          = 11,         // 录音
}RemoteControlButtonType;

@interface CSRemoteControlViewController () <CSQRCodeReadViewControllerDelegate,YSCircleSelectorDelegate,UIAlertViewDelegate>
/** 圆形遥控器 */
@property(nonatomic, weak) UIView *circleAreaView;
@property(nonatomic, weak) UIView *songControlAreaView;
@property(nonatomic, weak) UIButton *nextSongButton;
@property(nonatomic, weak) UIView *topView;
@property(nonatomic, weak) UIView *mainAreaView;
@property(nonatomic, strong) CSMyRoomInfoModel *roomInfo;

@end


@implementation CSRemoteControlViewController


- (instancetype)initWithRoomInfo:(CSMyRoomInfoModel *)roomInfo
{
    _roomInfo = roomInfo;
    return [self init];
}


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"遥控";
//    self.view.backgroundColor = HEX_COLOR(0x232227);
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    UIView *navLine = [[UIView alloc] init];
//    navLine.backgroundColor = HEX_COLOR(0x000000);
//    navLine.alpha = 0.55;
//    [self.navigationController.navigationBar addSubview:navLine];
//    navLine.frame = CGRectMake(0, 44.0, SCREENWIDTH, 0.5);

    [self setupSubViews];
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    _topView.hidden = GlobalObj.boxIp > 0;
//}



#pragma mark - Config

- (void)configNavigationBar
{
    [super configNavigationBar];
    
    self.navigationItem.title = @"遥控";
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"room_nav_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}


#pragma mark - Setup
- (void)setupSubViews
{
    // 背景图
//    [self setupBackgroundImageView];
    
    // 当前歌曲提示View
    [self setupMusicStateView];
    
    // 主按钮区域
    [self setupMainAreaButtons];
    
    // 声音控制按钮
    [self setupSoundControlAreaButtons];
    
    // 功能区
    [self setupFunctionAreaButtons];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button addTarget:self action:@selector(bindRoomBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"暂时扫描开关" forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, 100, 30);
//    button.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:button];
    
    

}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (![self isPureNumandCharacters:textField.text]) {
//        [SVProgressHUD showErrorWithStatus:@"不是数字输个蛋呀"];
//        return NO;
//    }
//    
//    if ([textField.text integerValue] > 255 || [textField.text integerValue] < 0) {
//        [SVProgressHUD showErrorWithStatus:@"有点常识好不好,IP段是0-255"];
//        return NO;
//    }
//    
//    GlobalObj.boxIp = [NSString stringWithFormat:@"192.168.1.%@:9000",textField.text];
//    
//    [self.view endEditing:YES];
//    return YES;
//}

//- (BOOL)isPureNumandCharacters:(NSString *)string
//{
//    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
//    if(string.length > 0)
//    {
//        return NO;
//    }
//    return YES;
//}

- (void)setupBackgroundImageView
{
    // 背景图
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
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    [self.view addSubview:backgroundImageView];
}

- (void)setupMusicStateView
{
    CSMusicStateView *musicStateView = [[CSMusicStateView alloc] init];
    [self.view addSubview:musicStateView];
    [musicStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(musicStateView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(22.0));
    }];
    musicStateView.text = @"当前暂无歌曲";

    [musicStateView startAnimation];
}

- (void)setupMainAreaButtons
{
    UIView *mainAreaView = [[UIView alloc] init];
    [self.view addSubview:mainAreaView];
    _mainAreaView = mainAreaView;
    [mainAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainAreaView.superview);
        make.centerY.equalTo(mainAreaView.superview).offset(iPhone6Plus?-150:-100.0);
    }];
    
    UIImageView *mainAreaBgView = [[UIImageView alloc] init];
    mainAreaBgView.image = [UIImage imageNamed:@"remote_btn_bg"];
    [mainAreaView addSubview:mainAreaBgView];
    [mainAreaBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainAreaBgView.superview);
    }];
    
    // 切歌按钮
    UIButton *nextSongButton = [[UIButton alloc] init];
    nextSongButton.tag = RemoteControlButtonTypeNextSong;
    _nextSongButton = nextSongButton;
    [nextSongButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextSongButton setBackgroundImage:[UIImage imageNamed:@"remote_change-song_btn"] forState:UIControlStateNormal];
    [nextSongButton setBackgroundImage:[UIImage imageNamed:@"remote_change-song_btn_press"] forState:UIControlStateHighlighted];
    [mainAreaView addSubview:nextSongButton];
    [nextSongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextSongButton.superview);
        make.centerY.equalTo(nextSongButton.superview).offset(41.0);
    }];
    
    
    // 静音按钮
    UIButton *silenceButton = [[UIButton alloc] init];
    silenceButton.tag = RemoteControlButtonTypeSilence;
    [silenceButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [silenceButton setBackgroundImage:[UIImage imageNamed:@"remote_mute_btn"] forState:UIControlStateNormal];
    [silenceButton setBackgroundImage:[UIImage imageNamed:@"remote_mute_btn_press"] forState:UIControlStateHighlighted];
    [mainAreaView addSubview:silenceButton];
    [silenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(silenceButton.superview).offset(22.0);
        make.top.equalTo(silenceButton.superview).offset(115.0);
    }];
    
    // 重唱按钮
    UIButton *replayButton = [[UIButton alloc] init];
    replayButton.tag = RemoteControlButtonTypeReplay;
    [replayButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [replayButton setBackgroundImage:[UIImage imageNamed:@"remote_resing_btn"] forState:UIControlStateNormal];
    [replayButton setBackgroundImage:[UIImage imageNamed:@"remote_resing_btn_press"] forState:UIControlStateHighlighted];
    [mainAreaView addSubview:replayButton];
    [replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replayButton.superview).offset(64.0);
        make.top.equalTo(replayButton.superview).offset(13.0);
    }];
    
    // 原/伴按钮
    UIButton *orgOrAccoButton = [[UIButton alloc] init];
    orgOrAccoButton.tag = RemoteControlButtonTypeOrgOrAcco;
    [orgOrAccoButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [orgOrAccoButton setBackgroundImage:[UIImage imageNamed:@"remote_singer_btn"] forState:UIControlStateNormal];
    [orgOrAccoButton setBackgroundImage:[UIImage imageNamed:@"remote_singer_btn_press"] forState:UIControlStateHighlighted];
    [mainAreaView addSubview:orgOrAccoButton];
    [orgOrAccoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orgOrAccoButton.superview).offset(-64.0);
        make.top.equalTo(orgOrAccoButton.superview).offset(13.0);
    }];
    
    // 播/停按钮
    UIButton *playOrPauseButton = [[UIButton alloc] init];
    playOrPauseButton.tag = RemoteControlButtonTypePlayOrPause;
    [playOrPauseButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"remote_play_btn"] forState:UIControlStateNormal];
    [playOrPauseButton setBackgroundImage:[UIImage imageNamed:@"remote_play_btn_press"] forState:UIControlStateHighlighted];
    [mainAreaView addSubview:playOrPauseButton];
    [playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(playOrPauseButton.superview).offset(-19.0);
        make.top.equalTo(playOrPauseButton.superview).offset(115.0);
    }];


}

- (void)setupSoundControlAreaButtons
{
    UIImage *downBtnImage = [UIImage imageNamed:@"remote_down_btn"];
    CGSize downBtnSize = downBtnImage.size;
    
    UIImage *upBtnImage = [UIImage imageNamed:@"remote_up_btn"];
    CGSize upBtnSize = upBtnImage.size;
    // 麦克风
    UIView *micView  = [[UIView alloc] init];
    [self.view addSubview:micView];
    
    UIImageView *micBg = [[UIImageView alloc] init];
    micBg.image = [UIImage imageNamed:@"remote_up-down_bg"];
    [micView addSubview:micBg];
    
    
    // 麦克风-按钮
    UIButton *micSoundDownButton = [[UIButton alloc] init];
    micSoundDownButton.tag = RemoteControlButtonTypeMicSoundDown;
    [micSoundDownButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [micSoundDownButton setBackgroundImage:downBtnImage forState:UIControlStateHighlighted];
    
    [micView addSubview:micSoundDownButton];
    
    // 麦克风+按钮
    UIButton *micSoundUpButton = [[UIButton alloc] init];
    
    micSoundUpButton.tag = RemoteControlButtonTypeMicSoundUp;
    [micSoundUpButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [micSoundUpButton setBackgroundImage:upBtnImage forState:UIControlStateHighlighted];
    [micView addSubview:micSoundUpButton];
    
    UILabel *micLabel =  [[UILabel alloc] init];
    micLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    micLabel.textColor = HEX_COLOR(0xc9c6d2);
    micLabel.text = @"麦克风";
    [micView addSubview:micLabel];
    
    
    CGFloat margin = iPhone6Plus?50:30.0;
    CGFloat padding = iPhone6Plus?50.0:26.0;
    [micView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainAreaView.mas_bottom).offset(margin);
        make.left.equalTo(self.view).offset(padding);
    }];
    
    [micBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(micBg.image.size);
        make.top.right.left.equalTo(micView);
    }];
    
    [micLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(micView);
        make.top.equalTo(micBg.mas_bottom).offset(TRANSFER_SIZE(9.0));
        make.bottom.equalTo(micView.mas_bottom);
    }];
    
    [micSoundDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(downBtnSize);
        make.top.left.bottom.equalTo(micBg);
    }];
    [micSoundUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(upBtnSize);
        make.top.right.bottom.equalTo(micBg);
    }];
    
    
    
    // 伴奏
    UIView *accoView = [[UIView alloc] init];
    [self.view addSubview:accoView];
    
    UIImageView *accoBg = [[UIImageView alloc] init];
    accoBg.image = [UIImage imageNamed:@"remote_up-down_bg"];
    [accoView addSubview:accoBg];
    
    UILabel *accoLabel =  [[UILabel alloc] init];
    accoLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];;
    accoLabel.textColor = HEX_COLOR(0xc9c6d2);
    accoLabel.text = @"伴奏";
    [accoView addSubview:accoLabel];
    
    
    // 伴奏-按钮
    UIButton *accoSoundDownButton = [[UIButton alloc] init];
    accoSoundDownButton.tag = RemoteControlButtonTypeAccoSoundDown;
    [accoSoundDownButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [accoSoundDownButton setBackgroundImage:downBtnImage forState:UIControlStateHighlighted];
    [accoView addSubview:accoSoundDownButton];
    
    // 伴奏+按钮
    UIButton *accoSoundUpButton = [[UIButton alloc] init];
    accoSoundUpButton.tag = RemoteControlButtonTypeAccoSoundUp;
    [accoSoundUpButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [accoSoundUpButton setBackgroundImage:upBtnImage forState:UIControlStateHighlighted];
    [accoView addSubview:accoSoundUpButton];
    
    [accoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainAreaView.mas_bottom).offset(margin);
        make.right.equalTo(self.view).offset(-padding);
    }];
    
    [accoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(accoBg.image.size);
        make.top.right.left.equalTo(accoView);
    }];
    [accoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(accoView);
        make.top.equalTo(accoBg.mas_bottom).offset(TRANSFER_SIZE(9.0));
        make.bottom.equalTo(accoView.mas_bottom);
    }];
    [accoSoundDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(downBtnSize);
        make.top.left.bottom.equalTo(accoBg);
    }];
    [accoSoundUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(upBtnSize);
        make.top.right.bottom.equalTo(accoBg);
    }];
    
    
    // 升降调
    UIView *sharpAndFlatView = [[UIView alloc] init];
    [self.view addSubview:sharpAndFlatView];
    
    UIImageView *sharpAndFlatViewBg = [[UIImageView alloc] init];
    sharpAndFlatViewBg.image = [UIImage imageNamed:@"remote_up-down_bg"];
    [sharpAndFlatView addSubview:sharpAndFlatViewBg];
    
    UILabel *sharpAndFlatLabel =  [[UILabel alloc] init];
    sharpAndFlatLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];;
    sharpAndFlatLabel.textColor = HEX_COLOR(0xc9c6d2);
    sharpAndFlatLabel.text = @"升降调";
    [sharpAndFlatView addSubview:sharpAndFlatLabel];
    

    
    // 升调
    UIButton *sharpButton = [[UIButton alloc] init];
    sharpButton.tag = RemoteControlButtonTypeSharp;
    [sharpButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sharpButton setBackgroundImage:upBtnImage forState:UIControlStateHighlighted];
    [sharpAndFlatView addSubview:sharpButton];
    
    // 降调
    UIButton *flatButton = [[UIButton alloc] init];
    flatButton.tag = RemoteControlButtonTypeFlat;
    [flatButton addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [flatButton setBackgroundImage:downBtnImage forState:UIControlStateHighlighted];
    
    [sharpAndFlatView addSubview:flatButton];
    
    
    
    [sharpAndFlatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainAreaView.mas_bottom).offset(margin);
        make.centerX.equalTo(self.mainAreaView);
    }];
    
    [sharpAndFlatViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(sharpAndFlatViewBg.image.size);
        make.top.right.left.equalTo(sharpAndFlatViewBg.superview);
    }];
    [sharpAndFlatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sharpAndFlatLabel.superview);
        make.top.equalTo(sharpAndFlatViewBg.mas_bottom).offset(TRANSFER_SIZE(9.0));
        make.bottom.equalTo(sharpAndFlatLabel.superview.mas_bottom);
    }];
    [flatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(downBtnSize);
        make.top.left.bottom.equalTo(sharpAndFlatViewBg);
    }];
    [sharpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(upBtnSize);
        make.top.right.bottom.equalTo(sharpAndFlatViewBg);
        
    }];

    
}

- (void)setupFunctionAreaButtons
{
    UIView *functionContainer = [[UIView alloc] init];
    [self.view addSubview:functionContainer];
    [functionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainAreaView.mas_bottom).offset(iPhone6Plus?150.0:100.0);
        make.centerX.equalTo(functionContainer.superview);
    }];
    // 灯光按钮
    UIView *lightView = [self buttonViewWithButtonImage:[UIImage imageNamed:@"remote_light_btn"] selectedImage:[UIImage imageNamed:@"remote_light_btn_press"] title:@"灯光" tag:RemoteControlButtonTypeLight];
    
    // 唱效
    UIView *soundEffectView = [self buttonViewWithButtonImage:[UIImage imageNamed:@"remote_effect_btn"] selectedImage:[UIImage imageNamed:@"remote_effect_btn_press"] title:@"唱效" tag:RemoteControlButtonTypeSoundEffect];
    
    // 录音
    UIView *recordView = [self buttonViewWithButtonImage:[UIImage imageNamed:@"remote_record_btn"] selectedImage:[UIImage imageNamed:@"remote_record_btn_press"] title:@"录音" tag:RemoteControlButtonTypeRecord];
    
    // 服务
    UIView *servieView = [self buttonViewWithButtonImage:[UIImage imageNamed:@"remote_service_btn"] selectedImage:[UIImage imageNamed:@"remote_service_btn_press"] title:@"服务" tag:RemoteControlButtonTypeService];
    
    [functionContainer addSubview:lightView];
    [functionContainer addSubview:soundEffectView];
    [functionContainer addSubview:recordView];
    [functionContainer addSubview:servieView];
    
    
    CGFloat margin = iPhone6Plus?25.0:13.0;
    [lightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(lightView.superview);
    }];
    
    [soundEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(soundEffectView.superview);
        make.left.equalTo(lightView.mas_right).offset(margin);
    }];
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(recordView.superview);
        make.left.equalTo(soundEffectView.mas_right).offset(margin);
    }];
    [servieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(servieView.superview);
        make.left.equalTo(recordView.mas_right).offset(margin);

    }];
    
 
    
}



- (UIView *)buttonViewWithButtonImage:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title tag:(NSInteger)tag
{
    UIView *buttonView = [[UIView alloc] init];
    buttonView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *buttonLabel = [[UILabel alloc] init];
    buttonLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    buttonLabel.textColor = HEX_COLOR(0xc9c6d2);
    buttonLabel.text = title;
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(remoteControlBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    
    
    [buttonView addSubview:buttonLabel];
    [buttonView addSubview:button];
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonLabel.superview);
        make.top.equalTo(button.mas_bottom).offset(TRANSFER_SIZE(11.0));
        make.bottom.equalTo(buttonLabel.superview);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(button.currentImage.size);
        make.top.right.left.equalTo(button.superview);
    }];
    
    return buttonView;
}


#pragma mark - Invalid

#pragma mark - Action
//#warning 测试专用接口
//- (void)cancelBindingPressed
//{
//    GlobalObj.boxIp = nil;
//    GlobalObj.centerIp = nil;
//    GlobalObj.roomNum = nil;
//    _topView.hidden = NO;
//    [SVProgressHUD showSuccessWithStatus:@"解除绑定成功"];
//}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)remoteControlBtnOnClick:(UIButton *)button
{
//    if (GlobalObj.token == 0) { // 未登录
//        CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
//        __weak typeof(self) weakSelf = self;
//        loginVc.loginBlock = ^(BOOL loginSuccess){
//            if (loginSuccess) {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//                [self remoteControlWithType:button.tag];
//            }
//        };
//        [self.navigationController pushViewController:loginVc animated:YES];
//    }else
//    {
        [self remoteControlWithType:button.tag];
//    }
}

- (void)remoteControlWithType:(NSInteger)type
{
//    if (GlobalObj.centerIp == 0) {
//        UIAlertView *orderDishAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"暂未绑定房间,是否扫描绑定" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        [orderDishAlertView show];
//        return;
//    }
    switch (type) {
        case RemoteControlButtonTypeLight:
        {
            [MobClick event:@"RoomControlLight"];
            [self setupLightView];
            break;
        }
        case RemoteControlButtonTypeSoundEffect:
        {
            [MobClick event:@"RoomControlMusictype"];
            [self setupSoundEffect];
            break;
        }
        case RemoteControlButtonTypeOrderDish:
        {
            break;
        }
        case RemoteControlButtonTypeRecord:
        {//录音
            [MobClick event:@"RoomControlRecord"];
            break;
        }
        case RemoteControlButtonTypeInteraction:
        {
//            [self setupInteraction];
            break;
        }
        case RemoteControlButtonTypeService:
        {
            [MobClick event:@"RoomControlServe"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeNextSong:
        {
            [MobClick event:@"RoomControlNext"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeReplay:
        {
            [MobClick event:@"RoomControlReplay"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeSilence:
        {
            [MobClick event:@"RoomControlMute"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypePlayOrPause:
        {
            [MobClick event:@"RoomControlPause"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeOrgOrAcco:
        {
            [MobClick event:@"RoomControlHarmy"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeMicSoundDown:
        {
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeMicSoundUp:
        {
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeFlat:
        {
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeSharp:
        {
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeAccoSoundDown:
        {
            [MobClick event:@"RoomControlVolDown"];
            [self requestForServeWith:type];
            break;
        }
        case RemoteControlButtonTypeAccoSoundUp:
        {
            [MobClick event:@"RoomControlVolUp"];
            [self requestForServeWith:type];
            break;
        }
    }
}
- (void)requestForServeWith:(NSInteger)type
{
    CSRequest *param = [[CSRequest alloc] init];
    param.controlType = [NSNumber numberWithInteger:type];
    param.boxToken = _roomInfo.boxToken;

    [CSRemoteControlHttpTool remoteControlWithParam:param success:^(CSBaseResponseModel *result)
     {
         if (result.code == ResponseStateSuccess) {
             [SVProgressHUD showSuccessWithStatus:@"发送成功"];
         }else
         {
             [SVProgressHUD showErrorWithStatus:result.message];
         }
     } failure:^(NSError *error) {
         CSLog(@"%@",error);
     }];
}
- (void)bindRoomBtnOnClick
{
    if (GlobalObj.isLogin) {
        CSQRCodeReadViewController *codeReadVc = [[CSQRCodeReadViewController alloc] init];
        codeReadVc.delegate = self;
        [self presentViewController:codeReadVc animated:YES completion:nil];
    }else
    {
        CSLoginViewController *loginVc = [[CSLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVc animated:YES];
        loginVc.loginBlock = ^(BOOL loginSuccess){
            [self.navigationController popViewControllerAnimated:YES];
            CSQRCodeReadViewController *codeReadVc = [[CSQRCodeReadViewController alloc] init];
            codeReadVc.delegate = self;
            [self presentViewController:codeReadVc animated:YES completion:nil];
        };
    }
}

- (void)removeBtnOnClick:(UIButton *)button
{
    [self.topView removeFromSuperview];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    CSQRCodeReadViewController *codeReadVc = [[CSQRCodeReadViewController alloc] init];
    codeReadVc.delegate = self;
    [self presentViewController:codeReadVc animated:YES completion:nil];
}

#pragma mark - CSQRCodeReadViewControllerDelegate

- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum
{
    GlobalObj.centerIp = serverIP;
    CSRequest *param = [[CSRequest alloc] init];
    param.registrationId = [APService registrationID];
    param.code = code;
    param.reserveBoxId = roomNum;
    
    // TODO 发送请求绑定包厢
    [CSQRCodeReadHttpTool bindingRoomWithParam:param success:^(CSBindingRoomResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            GlobalObj.roomNum = roomNum;
            GlobalObj.boxIp = result.data.boxIP;
            _topView.hidden = YES;
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
//        CSLog(@"%@",error);
    }];
}

#pragma mark - YSCircleSelectorDelegate

- (void)circleSelectorDidClosed
{
}
- (void)circleSelector:(YSCircleSelector *)circleSelector itemDidPickUp:(YSCircleSelectorItem *)item
{
    CSLog(@"%@",item.title);
}

- (void)setupLightView
{
    YSCircleSelectorItem *dynamic = [[YSCircleSelectorItem alloc] init];
    dynamic.backgroundImage = [UIImage imageNamed:@"remote_dynamic_bg"];
    dynamic.centerCircleImage = [UIImage imageNamed:@"remote_dynamic_circle"];
    dynamic.centerImage = [UIImage imageNamed:@"remote_dynamic_big_icon"];
    dynamic.aroundImage = [UIImage imageNamed:@"remote_dymatic_icon"];
    dynamic.title = @"动感";
    
    YSCircleSelectorItem *business = [[YSCircleSelectorItem alloc] init];
    business.backgroundImage = [UIImage imageNamed:@"remote_business_bg"];
    business.centerCircleImage = [UIImage imageNamed:@"remote_business_circle"];
    business.centerImage = [UIImage imageNamed:@"remote_business_big_icon"];
    business.aroundImage = [UIImage imageNamed:@"remote_business_icon"];
    business.title = @"商务";
    
    YSCircleSelectorItem *lyric = [[YSCircleSelectorItem alloc] init];
    lyric.backgroundImage = [UIImage imageNamed:@"remote_lyric_bg"];
    lyric.centerCircleImage = [UIImage imageNamed:@"remote_lyric_circle"];
    lyric.centerImage = [UIImage imageNamed:@"remote_lyric_big_icon"];
    lyric.aroundImage = [UIImage imageNamed:@"remote_lyric_icon"];
    lyric.title = @"抒情";
    
    YSCircleSelectorItem *light = [[YSCircleSelectorItem alloc] init];
    light.backgroundImage = [UIImage imageNamed:@"remote_light_bg"];
    light.centerCircleImage = [UIImage imageNamed:@"remote_light_circle"];
    light.centerImage = [UIImage imageNamed:@"remote_light_big_icon"];
    light.aroundImage = [UIImage imageNamed:@"remote_light_icon"];
    light.title = @"明亮";
    
    YSCircleSelectorItem *gentle = [[YSCircleSelectorItem alloc] init];
    gentle.backgroundImage = [UIImage imageNamed:@"remote_gentle_bg"];
    gentle.centerCircleImage = [UIImage imageNamed:@"remote_gentle_circle"];
    gentle.centerImage = [UIImage imageNamed:@"remote_gentle_big_icon"];
    gentle.aroundImage = [UIImage imageNamed:@"remote_gentle_icon"];
    gentle.title = @"柔和";
    
    YSCircleSelectorItem *romantic = [[YSCircleSelectorItem alloc] init];
    romantic.backgroundImage = [UIImage imageNamed:@"remote_romantic_bg"];
    romantic.centerCircleImage = [UIImage imageNamed:@"remote_romantic_circle"];
    romantic.centerImage = [UIImage imageNamed:@"remote_romantic_big_icon"];
    romantic.aroundImage = [UIImage imageNamed:@"remote_romantic_icon"];
    romantic.title = @"浪漫";

    YSCircleSelector *lightSelector = [[YSCircleSelector alloc] initWithCircleSelectorItems:@[dynamic,business,lyric,light,gentle,romantic]];
    lightSelector.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:lightSelector];
    [lightSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(lightSelector.superview);;
    }];
    [lightSelector spread];
}

- (void)setupSoundEffect
{
    YSCircleSelectorItem *theatre = [[YSCircleSelectorItem alloc] init];
    theatre.centerCircleImage = [UIImage imageNamed:@"remote_theatre_circle"];
    theatre.aroundImage = [UIImage imageNamed:@"remote_theatre_icon"];
    theatre.confirmColor = HEX_COLOR(0xcb9c34);
    theatre.title = @"剧场";
    YSCircleSelectorItem *caraok = [[YSCircleSelectorItem alloc] init];
    caraok.centerCircleImage = [UIImage imageNamed:@"remote_caraok_circle"];
    caraok.aroundImage = [UIImage imageNamed:@"remote_caraok_icon"];
    caraok.confirmColor = HEX_COLOR(0xa3206a);
    caraok.title = @"卡拉OK";
    YSCircleSelectorItem *singer = [[YSCircleSelectorItem alloc] init];
    singer.centerCircleImage = [UIImage imageNamed:@"remote_singer_circle"];
    singer.aroundImage = [UIImage imageNamed:@"remote_singer_icon"];
    singer.confirmColor = HEX_COLOR(0x4f08af);
    singer.title = @"唱将";
    YSCircleSelectorItem *concert = [[YSCircleSelectorItem alloc] init];
    concert.centerCircleImage = [UIImage imageNamed:@"remote_concert_circle"];
    concert.aroundImage = [UIImage imageNamed:@"remote_concert_icon"];
    concert.confirmColor = HEX_COLOR(0x0858af);
    concert.title = @"演唱会";
    YSCircleSelectorItem *magic = [[YSCircleSelectorItem alloc] init];
    magic.centerCircleImage = [UIImage imageNamed:@"remote_magic_circle"];
    magic.aroundImage = [UIImage imageNamed:@"remote_magic_icon"];
    magic.confirmColor = HEX_COLOR(0xb83024);
    magic.title = @"魔音";
    

    YSCircleSelector *soundEffectSelector = [[YSCircleSelector alloc] initWithCircleSelectorItems:@[theatre,caraok,singer,concert,magic]];
    soundEffectSelector.backgroundImage = [UIImage imageNamed:@"remote_sing_effect_bg"];
    soundEffectSelector.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:soundEffectSelector];
    [soundEffectSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(soundEffectSelector.superview);
    }];
    [soundEffectSelector spread];
}

//- (void)setupInteraction
//{
//    UIImage *orImage = [UIImage screenshotWithView:[UIApplication sharedApplication].keyWindow];
//    CSInteractionViewController *interactionVc = [[CSInteractionViewController alloc] initWithBGImage:orImage];
//    [self.navigationController pushViewController:interactionVc animated:NO];
//}


@end
