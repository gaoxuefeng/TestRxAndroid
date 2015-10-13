//
//  CSLoginViewController.m
//  CloudSong
//
//  Created by Ronnie on 15/5/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSLoginViewController.h"
#import "CSUserDataResponeModel.h"
#import "CSRegisterViewController.h"
#import "Header.h"
#import <APService.h>
#import "CSForgetPwdViewController.h"
#import "CSAlterTabBarTool.h"
#import "CSRoomUpdateTool.h"
typedef enum{
    OGThirdPartyTypeWechat,
    OGThirdPartyTypeWebo,
    OGThirdPartyTypeQQ,
    OGThirdPartyTypeAlipay
}OGThirdPartyType;

@interface CSLoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,CSRegisterViewControllerDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, weak) UIView *container;
@property(nonatomic, weak) UIView *inputAreaView;
@property(nonatomic, weak) UIButton *loginButton;
@property(nonatomic, weak) UIButton *registerButton;
@property(nonatomic, weak) UIButton *shortcutLoginButton;
@property(nonatomic, weak) UIView *bottomLine;
@property(nonatomic, weak) UITextField *accountTextField;
@property(nonatomic, weak) UITextField *passwordTextField;
@property(nonatomic, weak) UIView *orLeftLine;
@property(weak, nonatomic) UIView *orRightLine;
@property(nonatomic, weak) UIButton *forgetPwdButton;
@end

@implementation CSLoginViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = HEX_COLOR(0x151417);
    self.title = @"登录";
    [self setupSubViews];
    [self setupGestureRecognizer];
    [self configNavigationBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

//    self.navigationController.navigationBar.alpha = 1 ;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated] ;
    [self.accountTextField becomeFirstResponder] ;
}
#pragma mark - Setup

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGr];
}
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview);
        make.width.equalTo(container.superview);
    }];
    _container = container;
    
    [self setupInputAreaView];
    [self setupLoginButton];
    [self setupOrView];
    [self setupRegisterButton];
//    [self setupBottomLine];
//    [self setupThirdPartyLoginButtons];
    [self configRightBarButtonItem];
}

- (void)setupInputAreaView
{
    UIView *inputAreaView = [[UIView alloc] init];
    _inputAreaView = inputAreaView;
    inputAreaView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
    inputAreaView.layer.cornerRadius = TRANSFER_SIZE(4.0);
    inputAreaView.layer.masksToBounds = YES;
    [_container addSubview:inputAreaView];
    
    [inputAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputAreaView.superview).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(inputAreaView.superview).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(inputAreaView.superview).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(104.0));
    }];
    
    // 账号输入框
    UITextField *accountTextField = [[UITextField alloc] init];
    accountTextField.keyboardType = UIKeyboardTypePhonePad;
    accountTextField.delegate = self;
    _accountTextField = accountTextField;
    [inputAreaView addSubview:accountTextField];
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x9893a0)}];
    accountTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    accountTextField.textColor = [UIColor whiteColor];
    accountTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *accountTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_phone_icon"]];
    accountTextFieldLeftView.contentMode = UIViewContentModeCenter;
    accountTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    accountTextField.leftView = accountTextFieldLeftView;
    
    // 分割线
    UIView *inputCenterDivider = [[UIView alloc] init];
    inputCenterDivider.backgroundColor = HEX_COLOR(0x3c2c53);
    [inputAreaView addSubview:inputCenterDivider];
    
    // 密码输入框
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate = self;
    _passwordTextField = passwordTextField;
    [inputAreaView addSubview:passwordTextField];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x9893a0)}];
    passwordTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.returnKeyType = UIReturnKeyGo;
    
    UIImageView *passwordTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_key_icon"]];
    passwordTextFieldLeftView.contentMode = UIViewContentModeCenter;
    passwordTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.leftView = passwordTextFieldLeftView;
    
    [accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(inputAreaView);
        make.bottom.equalTo(inputCenterDivider.mas_top);
    }];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCenterDivider.mas_bottom);
        make.left.right.bottom.equalTo(inputAreaView);
    }];
    
    CGFloat padding = TRANSFER_SIZE(10.0);
    [inputCenterDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        make.left.equalTo(inputAreaView).offset(padding);
        make.right.equalTo(inputAreaView).offset(-padding);
        make.centerY.equalTo(inputAreaView);
    }];
}

- (void)setupLoginButton
{
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton = loginButton;
    loginButton.backgroundColor = HEX_COLOR(0xbc3581);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [loginButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(loginBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputAreaView.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.equalTo(loginButton.superview).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(loginButton.superview).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(39.0));
    }];
}

- (void)setupOrView
{
    UIView *orLeftLine = [[UIView alloc] init];
    orLeftLine.backgroundColor = HEX_COLOR(0x422f5a);
    [_container addSubview:orLeftLine];
    _orLeftLine = orLeftLine;
    
    UIView *orRightLine = [[UIView alloc] init];
    orRightLine.backgroundColor = orLeftLine.backgroundColor;
    _orRightLine = orLeftLine;
    [_container addSubview:orRightLine];
    
    UILabel * orLabel = [[UILabel alloc] init];
    orLabel.text = @"or";
    orLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(13.0)];
    orLabel.textColor = HEX_COLOR(0x9992a3);
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [_container addSubview:orLabel];
    
    [orLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orLeftLine.superview).offset(TRANSFER_SIZE(35.0));
//        make.right.equalTo(orLeftLine.superview).offset(-TRANSFER_SIZE(35.0));
        make.right.equalTo(orLabel.mas_left);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        make.top.equalTo(_loginButton.mas_bottom).offset(TRANSFER_SIZE(14.0));
    }];
    
    [orRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orRightLine.superview).offset(-TRANSFER_SIZE(35.0));
        make.left.equalTo(orLabel.mas_right);
        make.height.equalTo(orLeftLine);
        make.centerY.equalTo(orLeftLine);
    }];
    
    [orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orLeftLine);
        make.centerX.equalTo(orLabel.superview);
        make.width.mas_equalTo(TRANSFER_SIZE(50.0));
    }];

}

- (void)setupRegisterButton
{
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.backgroundColor = HEX_COLOR(0x7447b1);
    [registerButton addTarget:self action:@selector(registerBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [registerButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    registerButton.layer.masksToBounds = YES;
    [registerButton setTitle:@"手机号注册" forState:UIControlStateNormal];
    [_container addSubview:registerButton];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orLeftLine.mas_bottom).offset(TRANSFER_SIZE(14.0));
        make.left.equalTo(registerButton.superview).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(registerButton.superview).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(39.0));
        make.bottom.equalTo(registerButton.superview.mas_bottom);
    }];
    
}



//- (void)setupBottomLine
//{
//    UIView *bottomLine = [[UIView alloc] init];
//    _bottomLine = bottomLine;
//    bottomLine.backgroundColor = HEX_COLOR(0x2e2e31);
//    [self.view addSubview:bottomLine];
//    
//    UILabel *bottomLineTextLabel = [[UILabel alloc] init];
//    bottomLineTextLabel.textAlignment = NSTextAlignmentCenter;
//    bottomLineTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
//    bottomLineTextLabel.textColor = HEX_COLOR(0x2e2e31);
//    bottomLineTextLabel.backgroundColor = self.view.backgroundColor;
//    bottomLineTextLabel.text = @"使用第三方账号登录";
//    [self.view addSubview:bottomLineTextLabel];
//    
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-87.0);
//        make.left.equalTo(self.view).offset(33.0);
//        make.right.equalTo(self.view).offset(-33.0);
//        make.height.mas_equalTo(1);
//    }];
//    
//    [bottomLineTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(bottomLine);
//        make.centerY.equalTo(bottomLine);
//        make.width.mas_equalTo(153.0);
//        
//    }];
//}

//- (void)setupThirdPartyLoginButtons
//{
//    
//    UIView *thirdPartyLoginAreaView = [[UIView alloc] init];
//    [self.view addSubview:thirdPartyLoginAreaView];
//    
//    [thirdPartyLoginAreaView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.right.equalTo(_bottomLine);
//        make.top.equalTo(_bottomLine.mas_bottom);
//        make.bottom.equalTo(self.view);
//    }];
//    
//    
//    UIButton *wechatButton = [[UIButton alloc] init];
//    wechatButton.tag = OGThirdPartyTypeWechat;
//    [wechatButton addTarget:self action:@selector(thirdPartyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [wechatButton setImage:[UIImage imageNamed:@"sign_in_wechat_icon"] forState:UIControlStateNormal];
//    [thirdPartyLoginAreaView addSubview:wechatButton];
//    
//    UIButton *weboButton = [[UIButton alloc] init];
//    weboButton.tag = OGThirdPartyTypeWebo;
//    [weboButton addTarget:self action:@selector(thirdPartyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [weboButton setImage:[UIImage imageNamed:@"sign_in_weibo_icon"] forState:UIControlStateNormal];
//    [thirdPartyLoginAreaView addSubview:weboButton];
//    
//    UIButton *qqButton = [[UIButton alloc] init];
//    qqButton.tag = OGThirdPartyTypeQQ;
//    [qqButton addTarget:self action:@selector(thirdPartyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [qqButton setImage:[UIImage imageNamed:@"sign_in_qq_icon"] forState:UIControlStateNormal];
//    [thirdPartyLoginAreaView addSubview:qqButton];
//    
//    UIButton *alipayButton = [[UIButton alloc] init];
//    alipayButton.tag = OGThirdPartyTypeAlipay;
//    [alipayButton addTarget:self action:@selector(thirdPartyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [alipayButton setImage:[UIImage imageNamed:@"sign_in_alipay_icon"] forState:UIControlStateNormal];
//    [thirdPartyLoginAreaView addSubview:alipayButton];
//    
//    CGSize iconSize = CGSizeMake(35, 35);
//    CGFloat padding = ((SCREENWIDTH - 70) - ( 4 * iconSize.width) ) / 3.0;
//    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(thirdPartyLoginAreaView);
//        make.centerY.equalTo(thirdPartyLoginAreaView);
//        make.size.mas_equalTo(iconSize);
//    }];
//    [weboButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(wechatButton.mas_right).offset(padding);
//        make.centerY.equalTo(thirdPartyLoginAreaView);
//        make.size.mas_equalTo(iconSize);
//    }];
//    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weboButton.mas_right).offset(padding);
//        make.centerY.equalTo(thirdPartyLoginAreaView);
//        make.size.mas_equalTo(iconSize);
//    }];
//    
//    [alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(thirdPartyLoginAreaView);
//        make.centerY.equalTo(thirdPartyLoginAreaView);
//        make.size.mas_equalTo(iconSize);
//    }];
//}

#pragma mark - Config
- (void)configRightBarButtonItem
{
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPwdButton addTarget:self action:@selector(forgetPwdBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    forgetPwdButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(14.0)];
    [forgetPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdButton setTitleColor:HEX_COLOR(0xee29a7) forState:UIControlStateNormal];
    [forgetPwdButton sizeToFit];
    
    UIBarButtonItem *rightButtonBtn = [[UIBarButtonItem alloc] initWithCustomView:forgetPwdButton];
    self.navigationItem.rightBarButtonItem = rightButtonBtn;
}

#pragma mark - Action
- (void)tap
{
//    [_accountTextField resignFirstResponder];
//    [_passwordTextField resignFirstResponder];
    [self.view endEditing:YES];
}
/** 忘记密码按钮点击 */
- (void)forgetPwdBtnOnClick:(UIButton *)button
{
    CSForgetPwdViewController *forgetPwdVc = [[CSForgetPwdViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    forgetPwdVc.loginBlock = ^(BOOL loginSuccess)
    {
        if (loginSuccess) {
//            [weakSelf.navigationController popViewControllerAnimated:NO];
            if (weakSelf.loginBlock) {
                weakSelf.loginBlock(YES);
            }else
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    [self.navigationController pushViewController:forgetPwdVc animated:YES];
}

/** 登录按钮点击 */
- (void)loginBtnOnClick:(UIButton *)button
{
    // 判断手机号码是否为空
    if (!(_accountTextField.text != nil && _accountTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    // 如果不是手机号码,则提示,并返回
    if (![PublicMethod isMobileNumber:_accountTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    // 判断密码是否为空
    if (!_passwordTextField.text.length > 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (_passwordTextField.text.length > 32 || _passwordTextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"用户密码长度为6-32个字符"];
        return;
    }
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    [SVProgressHUD show];
    button.enabled = NO;
    CSRequest *param = [[CSRequest alloc] init];
    param.password = _passwordTextField.text;
    param.registrationId =  [APService registrationID];
    param.phoneNum = _accountTextField.text;
    
    [CSLoginHttpTool userLoginWithParam:param success:^(CSUserDataWrapperModel *result) {
        button.enabled = YES;
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            GlobalObj.token = result.data.token;
            GlobalObj.userInfo = result.data.userInfo;
            NSArray *array = [result.data.myrooms sortedArrayUsingComparator:^NSComparisonResult(CSMyRoomInfoModel *obj1, CSMyRoomInfoModel *obj2) {
                return [obj1.rbStartTime compare:obj2.rbStartTime] ==  NSOrderedDescending;
            }];
            GlobalObj.myRooms = array;

//            GlobalObj.selectedId = GlobalObj.selectedId;
            if (GlobalObj.selectedId.length == 0) {
                GlobalObj.selectedId = [GlobalObj.myRooms.firstObject reserveBoxId];
            }
            
            [[CSRoomUpdateTool sharedSingleton] resetTimers];
            for (CSMyRoomInfoModel *roomInfo in GlobalObj.myRooms) {
                if (roomInfo.starting) continue;
                if (roomInfo.rbStartTime.length > 0 && roomInfo.serverTimeStamp.length > 0) {
                    NSTimeInterval seconds = roomInfo.rbStartTime.doubleValue - roomInfo.serverTimeStamp.doubleValue;
                    [[CSRoomUpdateTool sharedSingleton] addTimerAfterTimeInterval:seconds];
                }
            }
            
            if (GlobalObj.myRooms.count > 0) {
                [CSAlterTabBarTool alterTabBarToRoomController];
            }else
            {
//                [CSAlterTabBarTool alterTabBarToKtvBookingController];
            }
            if (self.loginBlock) {
                self.loginBlock(YES);
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        
    } failure:^(NSError *error) {
        button.enabled = YES;
        CSLog(@"%@",error);
    }];
}
/** 手机注册按钮点击 */
- (void)registerBtnOnClick:(UIButton *)button
{
    CSRegisterViewController *registerVc = [[CSRegisterViewController alloc] init];
    registerVc.delegate = self;
    __weak typeof(self) weakSelf = self;
    registerVc.finishBlock = ^
    {
        if (weakSelf.loginBlock) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakSelf.loginBlock(YES);
        }else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [self.navigationController pushViewController:registerVc animated:YES];
}
///** 第三方登录按钮点击 */
//- (void)thirdPartyBtnOnClick:(UIButton *)button
//{
////    CSLog(@"%d",button.tag);
//}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - CSRegisterViewControllerDelegate
- (void)registerViewControllerDidClickForgetPwdButton
{
    CSForgetPwdViewController *forgetPwdVc = [[CSForgetPwdViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    forgetPwdVc.loginBlock = ^(BOOL loginSuccess)
    {
        if (loginSuccess) {
            //            [weakSelf.navigationController popViewControllerAnimated:NO];
            if (weakSelf.loginBlock) {
                weakSelf.loginBlock(YES);
            }else
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    [self.navigationController pushViewController:forgetPwdVc animated:YES];
}


@end
