//
//  CSQRImageViewController.m
//  CloudSong
//
//  Created by sen on 15/7/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSQRImageViewController.h"
#import "CSRoomHttpTool.h"
#import "CSDefine.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "CSQRCodeReadViewController.h"
#import <MobClick.h>
#import "UMSocial.h"
#import <WXApi.h>
#import "UMSocialDataService.h"
#import <UMSocialQQHandler.h>
#import "CSLoginHttpTool.h"
#import "CSWeiboShareEditViewController.h"
#import <APService.h>
#import "CSAlterTabBarTool.h"


typedef enum {
    CSShareTypeWeibo,
    CSShareTypeWechat,
    CSShareTypeQQ,
    CSShareTypeTimeLine
}CSShareType;
@interface CSQRImageViewController ()<CSQRCodeReadViewControllerDelegate>
{
    UIImage * wantToShare_image;
}
@property(nonatomic, copy) NSString *reserveBoxId;
@property(nonatomic, weak) UIImageView *qrImageView;
@property(nonatomic, weak) UIButton *cover;

@property(nonatomic, weak) UIView *shareView;

@property(nonatomic, weak) UIView *container;
@property(nonatomic, weak) MASConstraint *shareViewBottomY;
@property(nonatomic, strong) NSMutableArray *shareTypes;

@end

@implementation CSQRImageViewController

- (instancetype)initWithReserveBoxId:(NSString *)reserveBoxId
{
    _reserveBoxId = reserveBoxId;
    return [self init];
}
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"房间二维码";
    [self setupSubviews];
    [self loadData];
}


#pragma mark - Config
- (void)configNavigationBar
{
    [super configNavigationBar];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"room_nav_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

#pragma mark - Setup
- (void)setupSubviews
{
    // 背景图
    [self setupBackgroundImageView];
    [self setupViews];
}

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

- (void)setupViews
{
    UIImageView *qrImageView = [[UIImageView alloc] init];
    qrImageView.layer.cornerRadius = TRANSFER_SIZE(5.0);
    qrImageView.layer.masksToBounds = YES;
    qrImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:qrImageView];
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(215.0), TRANSFER_SIZE(215.0)));
        make.centerX.equalTo(qrImageView.superview);
        make.centerY.equalTo(qrImageView.superview).offset(TRANSFER_SIZE(-100.0));
    }];
    _qrImageView = qrImageView;
    
//    UILabel *firstLabel = [[UILabel alloc] init];
//    firstLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
//    firstLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
//    firstLabel.textColor = [UIColor whiteColor];
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"   分享二维码,一起加入手机点歌   "];
//    NSRange range = NSMakeRange(3, 6);
//    [attrString addAttribute:NSForegroundColorAttributeName value:HEX_COLOR(0x16bede) range:range];
//    firstLabel.attributedText = attrString;
//    
//    CGFloat radius = TRANSFER_SIZE(12.0);
//    firstLabel.layer.cornerRadius = radius;
//    firstLabel.layer.masksToBounds = YES;
//    
//    [self.view addSubview:firstLabel];
//    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(qrImageView.mas_bottom).offset(38.0);
//        make.centerX.equalTo(firstLabel.superview);
//        make.height.mas_equalTo(TRANSFER_SIZE(2 * radius));
//    }];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.textColor = HEX_COLOR(0xe4e2e6);
    secondLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.5)];
    secondLabel.text = @"让好友扫描此二维码,即可完成房间绑定";
    [self.view addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrImageView.mas_bottom).offset(TRANSFER_SIZE(25.0));
        make.centerX.equalTo(secondLabel.superview);
    }];
    
    UIButton *reScanQRButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [reScanQRButton addTarget:self action:@selector(scanQRButton) forControlEvents:UIControlEventTouchUpInside];
    
//    reScanQRButton.backgroundColor = [UIColor yellowColor];
    [reScanQRButton setImage:[[UIImage imageNamed:@"room_code_again"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.view addSubview:reScanQRButton];
    
    [reScanQRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(reScanQRButton.superview);
        make.top.equalTo(secondLabel.mas_bottom).offset(TRANSFER_SIZE(38.0));
    }];

}
//- (void)tap
//{
//    [self.view endEditing:YES];
//    //    if (self.isShowToolExtension) {
//    [self.view layoutIfNeeded];
//    [UIView animateWithDuration:0.25 delay:0.0 options:7 << 16 animations:^{
//        _container.y = TRANSFER_SIZE(26.0);
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        self.showToolExtension = NO;
//        self.extensionView.hidden = YES;
//    }];
//    //    }
//    
//}
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
- (void)goToShare:(UITapGestureRecognizer *)tapR
{
//    NSString * contentStr = @"扫描二维码,一起加入手机点歌";
//    wantToShare_image = [UIImage imageNamed:@"share_icon"];//@"二维码"
//    NSString * shareUrl = @"http://www.baidu.com";
//    [[UMSocialControllerService defaultControllerService] setShareText:contentStr shareImage:wantToShare_image socialUIDelegate:nil];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:k].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    CSLog(@"分享二维码,一起加入手机点歌");
    [MobClick event:@"RoomInvite"];
//    [self tap];
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
            CSWeiboShareEditViewController *weiboShareEditVc = [[CSWeiboShareEditViewController alloc] init];
            [self.navigationController pushViewController:weiboShareEditVc animated:YES];
        }
    }];
}

#pragma maark --- 分享二维码
- (void)shareBtnOnClick:(UIButton *)button
{
    NSString * contentStr = @"扫描二维码,一起加入手机点歌";
    NSString * shareUrl = @"http://www.baidu.com";//分享链接
    switch (button.tag) {
        case CSShareTypeWeibo:
        {
//            [self cancelInvateFriendForWeiboShare:YES];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:contentStr image:wantToShare_image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享sina微博成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享sina微博失败！"];
                }
            }];
            break;
        }
        case CSShareTypeWechat:
        {
            [self cancelInvateFriend];
            [UMSocialData defaultData].extConfig.wechatSessionData.url =shareUrl;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = contentStr;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:contentStr image:wantToShare_image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享微信好友成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享微信好友失败！"];
                }
            }];
            break;
        }
        case CSShareTypeQQ:
        {
            [UMSocialData defaultData].extConfig.qqData.title = contentStr;
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:contentStr image:wantToShare_image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
                    [SVProgressHUD showSuccessWithStatus:@"分享QQ成功！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"分享QQ失败！"];
                }
            }];
            break;
        }
        case CSShareTypeTimeLine:
        {
            [self cancelInvateFriend];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url =shareUrl;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = contentStr;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contentStr image:wantToShare_image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                [self cancelInvateFriend];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    CSLog(@"分享成功！");
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

#pragma mark - CSQRCodeReadViewControllerDelegate
/**
 *  二维码中携带的数据信息
 *
 *  @param serverIP KTV 的 IP
 *  @param code     二维码中的随机编码
 *  @param roomNum  房间号
 */
- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum{
    GlobalObj.centerIp = serverIP;
    CSRequest *param = [[CSRequest alloc] init];
    param.registrationId = [APService registrationID];
    param.code = code;
    param.reserveBoxId = roomNum;
    
    // 发送请求绑定包厢
    [CSQRCodeReadHttpTool bindingRoomWithParam:param success:^(CSBindingRoomResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            GlobalObj.roomNum = roomNum;
            GlobalObj.boxIp = result.data.boxIP;
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 切换tabBar至房间
                CSRequest *param = [[CSRequest alloc] init];
                // 扫码成功后，后台服务器将该用户与该包厢绑定，重新请求该用户信息，获取包厢号
                [CSLoginHttpTool getUserInfoWithParam:param success:^(CSUserDataWrapperModel *result) {
                    if (result.code == ResponseStateSuccess) {
                        NSInteger originalCount = [GlobalVar sharedSingleton].myRooms.count;
                        
                        if (!(result.data.myrooms.count > originalCount)) {
                            [SVProgressHUD showErrorWithStatus:@"绑定房间失败"];
                        }
                        [GlobalVar sharedSingleton].myRooms = result.data.myrooms;
                        GlobalObj.selectedId = [result.data.myrooms.firstObject reserveBoxId];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:result.message];
                    }
                } failure:^(NSError *error) {
                    CSLog(@"%@",error);
                }];
                
//            });
        }
        else
            [SVProgressHUD showErrorWithStatus:result.message];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请连接KTV无线网..."];
        CSLog(@"error = %@", error) ;
    }];
}

#pragma mark - Action Methods
- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanQRButton
{
    CSQRCodeReadViewController *qrCodeReadVc = [[CSQRCodeReadViewController alloc] init];
    qrCodeReadVc.delegate = self;
    [self presentViewController:qrCodeReadVc animated:YES completion:nil];
}

#pragma mark - Load Data
- (void)loadData
{
    CSRequest *param = [[CSRequest alloc] init];
    param.reserveBoxId = _reserveBoxId;
//    param.registrationId = [APService registrationID];
    [CSRoomHttpTool getRoomQRWithParam:param success:^(CSRoomQRResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            
            [_qrImageView sd_setImageWithURL:[NSURL URLWithString:result.data.imageUrl]];
            wantToShare_image = _qrImageView.image;
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}
@end
