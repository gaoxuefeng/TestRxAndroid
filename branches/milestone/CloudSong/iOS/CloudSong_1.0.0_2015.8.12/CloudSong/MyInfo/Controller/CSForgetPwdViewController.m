//
//  CSForgetPwdViewController.m
//  CloudSong
//
//  Created by sen on 15/6/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  忘记密码

#import "CSForgetPwdViewController.h"
#import <Masonry.h>
#import "SVProgressHUD.h"
#import "CSLoginHttpTool.h"
#import <APService.h>
#import "CSDefine.h"
#import "CSRoomUpdateTool.h"
#import "CSAlterTabBarTool.h"
#define COUNTDOWN_SECONDS 60
@interface CSForgetPwdViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, weak) UIView *container;
@property(nonatomic, weak) UIView *inputAreaView;
@property(nonatomic, weak) UIButton *loginButton;
@property(nonatomic, weak) UITextField *accountTextField;
@property(nonatomic, weak) UITextField *passwordTextField;
@property(nonatomic, weak) UIButton *dynamicPwdButton;
/** 定时器 */
@property (strong, nonatomic) NSTimer *timer;
/** 当前秒数 */
@property (assign, nonatomic) NSInteger currentSecond;
@end

@implementation CSForgetPwdViewController
#pragma mark - Getter & Setter

- (void)setCurrentSecond:(NSInteger)currentSecond
{
    if (currentSecond < 0) {// 如果倒计时结束
        // 移除定时器
        [self removeTimer];
        // 验证码按钮可用
        _dynamicPwdButton.enabled = YES;
        return;
    }
    _currentSecond = currentSecond;
    [_dynamicPwdButton setTitle:[NSString stringWithFormat:@"倒计时%ld秒",_currentSecond] forState:UIControlStateDisabled];
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(0x151417);
    self.title = @"忘记密码";
    [self setupSubViews];
    [self setupGestureRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeTimer];
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
}

- (void)setupInputAreaView
{
    UIView *inputAreaView = [[UIView alloc] init];
    _inputAreaView = inputAreaView;
    inputAreaView.backgroundColor = HEX_COLOR(0x1e1d21);
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
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x4e4e54)}];
    accountTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    accountTextField.textColor = [UIColor whiteColor];
    accountTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *accountTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_in_phone_icon"]];
    accountTextFieldLeftView.contentMode = UIViewContentModeCenter;
    accountTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    accountTextField.leftView = accountTextFieldLeftView;
    
    // 分割线
    UIView *inputCenterDivider = [[UIView alloc] init];
    inputCenterDivider.backgroundColor = HEX_COLOR(0x1a1a1d);
    [inputAreaView addSubview:inputCenterDivider];
    
    // 密码输入框
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate = self;
    passwordTextField.keyboardType = UIKeyboardTypePhonePad;
    _passwordTextField = passwordTextField;
    [inputAreaView addSubview:passwordTextField];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入动态密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x4e4e54)}];
    passwordTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.returnKeyType = UIReturnKeyGo;
    
    UIImageView *passwordTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_in_key_icon"]];
    passwordTextFieldLeftView.contentMode = UIViewContentModeCenter;
    passwordTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.leftView = passwordTextFieldLeftView;
    
    // 获取验证码按钮
    UIButton *dynamicPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dynamicPwdButton addTarget:self action:@selector(getdynamicPwdBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _dynamicPwdButton = dynamicPwdButton;
    dynamicPwdButton.backgroundColor = HEX_COLOR(0x2c2a30);
    dynamicPwdButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [dynamicPwdButton setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    [dynamicPwdButton setTitle:@"获取动态密码" forState:UIControlStateNormal];
    dynamicPwdButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    dynamicPwdButton.layer.masksToBounds = YES;
    dynamicPwdButton.size = CGSizeMake(TRANSFER_SIZE(110.0), TRANSFER_SIZE(36.0));
    dynamicPwdButton.x = 0;
    
    UIView *phoneNumTextFieldRightView = [[UIView alloc] init];
    phoneNumTextFieldRightView.size = CGSizeMake(TRANSFER_SIZE(120.0), TRANSFER_SIZE(36.0));
    [phoneNumTextFieldRightView addSubview:dynamicPwdButton];
    
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    passwordTextField.rightView = phoneNumTextFieldRightView;
    
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
        make.height.mas_equalTo(2 / [UIScreen mainScreen].scale);
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
    [loginButton setTitleColor:HEX_COLOR(0xf2f2f2) forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(loginBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputAreaView.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.equalTo(loginButton.superview).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(loginButton.superview).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(39.0));
        make.bottom.equalTo(loginButton.superview.mas_bottom);
    }];
}

#pragma mark - Config

#pragma  mark - Private
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

/**
 *  秒数递减
 */
- (void)countDown
{
    [self setCurrentSecond:_currentSecond - 1];
}

#pragma mark - Action
- (void)tap
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)loginBtnOnClick
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
    
    [SVProgressHUD show];
    CSRequest *param = [[CSRequest alloc] init];
    
    param.dynamicPw = _passwordTextField.text;
    param.phoneNum = _accountTextField.text;
    __weak typeof(self) weakSelf = self;
    [CSLoginHttpTool dynamicLoginWithParam:param success:^(CSUserDataWrapperModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            GlobalObj.token = result.data.token;
            GlobalObj.userInfo = result.data.userInfo;
//            NSArray *array = [result.data.myrooms sortedArrayUsingComparator:^NSComparisonResult(CSMyRoomInfoModel *obj1, CSMyRoomInfoModel *obj2) {
//                return [obj1.startTime compare:obj2.startTime] ==  NSOrderedDescending;
//            }];
            GlobalObj.myRooms = result.data.myrooms;
            
            GlobalObj.selectedId = GlobalObj.selectedId;
            
            [[CSRoomUpdateTool sharedSingleton] resetTimers];
            for (CSMyRoomInfoModel *roomInfo in GlobalObj.myRooms) {
                if (roomInfo.starting) continue;
                if (roomInfo.startTime.length > 0 && roomInfo.serviceDate.length > 0) {
                    NSTimeInterval seconds = roomInfo.startTime.doubleValue - roomInfo.serviceDate.doubleValue;
                    [[CSRoomUpdateTool sharedSingleton] addTimerAfterTimeInterval:seconds];
                }
            }
            if (GlobalObj.myRooms.count > 0) {
                [CSAlterTabBarTool alterTabBarToRoomController];
            }
            if (weakSelf.loginBlock) {
                [weakSelf.navigationController popViewControllerAnimated:NO];
                weakSelf.loginBlock(YES);
            }else
            {
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)getdynamicPwdBtnOnClick:(UIButton *)button
{
    if (!(_accountTextField.text != nil && _accountTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    // 如果不是手机号码,则提示,并返回
    if (![PublicMethod isMobileNumber:_accountTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    // 手机号码验证通过
    CSRequest *param = [[CSRequest alloc] init];
    param.phoneNum = _accountTextField.text;
    param.action = [NSNumber numberWithInteger:1];
    [CSLoginHttpTool loginCodeWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) { // 成功
            // 设置倒计时数
            _currentSecond = COUNTDOWN_SECONDS;
            // 按钮为不可点击状态
            button.enabled = NO;
            [button setTitle:[NSString stringWithFormat:@"倒计时%ld秒",_currentSecond] forState:UIControlStateDisabled];
            // 开启定时器
            [self addTimer];
            // 提示验证码发送成功
            [SVProgressHUD showSuccessWithStatus:result.message];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
