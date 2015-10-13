//
//  CSAlterPwdViewController.m
//  CloudSong
//
//  Created by sen on 15/6/29.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  修改密码控制器

#import "CSAlterPwdViewController.h"
#import <Masonry.h>
#import "CSLoginHttpTool.h"
#import "SVProgressHUD.h"
#define COUNTDOWN_SECONDS 60
@interface CSAlterPwdViewController ()<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, weak) UIView *container;
/** 验证码区域 */
@property(nonatomic, weak) UIView *codeView;
/** 密码 */
@property(nonatomic, weak) UIView *pwdView;

/** 确认按钮 */
@property(nonatomic, weak) UIButton *confirmButton;
/** 手机号码输入框 */
@property(nonatomic, weak) UITextField *phoneNumTextField;
/** 分割线 */
@property(nonatomic, weak) UIView *inputCenterDivider;
/** 验证码输入框 */
@property(nonatomic, weak) UITextField *codeTextField;
/** 获取验证码按钮 */
@property(nonatomic, weak) UIButton *getCodeButton;
/** 密码输入框 */
@property(nonatomic, weak) UITextField *pwdTextField;

/** 定时器 */
@property (strong, nonatomic) NSTimer *timer;
/** 当前秒数 */
@property (assign, nonatomic) NSInteger currentSecond;
/** 是否已设置约束 */

@property(nonatomic, assign) BOOL didSetupConstaint;

@end

@implementation CSAlterPwdViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = HEX_COLOR(0x151417);
    [self setupSubViews];
    
    [self updateConstraints];
    
    [self setupGestureRecognizer];
}

#pragma mark - Setup
- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGr];
}

- (void)setupSubViews
{
    [self setupScrollView];
    [self setupCodeView];
    [self setupPwdView];
    [self setupConfirmButton];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    _container = container;
}

- (void)setupCodeView
{
    UIView *codeView = [[UIView alloc] init];
    codeView.backgroundColor = HEX_COLOR(0x1e1d21);
    codeView.layer.cornerRadius = 4.0;
    codeView.layer.masksToBounds = YES;
    _codeView = codeView;
    [_container addSubview:codeView];
    
    // 手机号输入框
    UITextField *phoneNumTextField = [[UITextField alloc] init];
    phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneNumTextField.delegate = self;
    _phoneNumTextField = phoneNumTextField;
    [codeView addSubview:phoneNumTextField];
//    phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x4e4e54)}];
    phoneNumTextField.text = GlobalObj.userInfo.phoneNum;
    phoneNumTextField.enabled = NO;
    phoneNumTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    phoneNumTextField.textColor = HEX_COLOR(0x5a5a60);
    phoneNumTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *phoneNumTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_phone_icon"]];
    phoneNumTextFieldLeftView.contentMode = UIViewContentModeCenter;
    phoneNumTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumTextField.leftView = phoneNumTextFieldLeftView;
    
    // 分割线
    UIView *inputCenterDivider = [[UIView alloc] init];
    inputCenterDivider.backgroundColor = HEX_COLOR(0x1a1a1d);
    [codeView addSubview:inputCenterDivider];
    _inputCenterDivider = inputCenterDivider;
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.delegate = self;
    _codeTextField = codeTextField;
    [_codeView addSubview:codeTextField];
    codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x4e4e54)}];
    codeTextField.font = [UIFont systemFontOfSize:15.0];
    codeTextField.textColor = [UIColor whiteColor];
    codeTextField.returnKeyType = UIReturnKeyGo;
    
    UIImageView *codeTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_verification_code_icon"]];
    codeTextFieldLeftView.contentMode = UIViewContentModeCenter;
    codeTextFieldLeftView.size = CGSizeMake(44.0, 44.0);
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.leftView = codeTextFieldLeftView;
    
    // 获取验证码按钮
    UIButton *getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeButton addTarget:self action:@selector(getCodeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _getCodeButton = getCodeButton;
    getCodeButton.backgroundColor = HEX_COLOR(0x2c2a30);
    getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [getCodeButton setTitleColor:HEX_COLOR(0xb5b7bf) forState:UIControlStateNormal];
    [getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCodeButton.layer.cornerRadius = 4.0;
    getCodeButton.layer.masksToBounds = YES;
    getCodeButton.size = CGSizeMake(110.0, 36.0);
    getCodeButton.x = 0;
    
    UIView *codeTextFieldRightView = [[UIView alloc] init];
    codeTextFieldRightView.size = CGSizeMake(120.0, 36.0);
    [codeTextFieldRightView addSubview:getCodeButton];
    
    codeTextField.rightViewMode = UITextFieldViewModeAlways;
    codeTextField.rightView = codeTextFieldRightView;
    
}

- (void)setupPwdView
{
    UIView *pwdView = [[UIView alloc] init];
    _pwdView = pwdView;
    pwdView.backgroundColor = HEX_COLOR(0x1e1d21);
    pwdView.layer.cornerRadius = 4.0;
    pwdView.layer.masksToBounds = YES;
    [_container addSubview:pwdView];
    
    // 设置密码框
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.delegate = self;
    _pwdTextField = pwdTextField;
    pwdTextField.secureTextEntry = YES;
    [pwdView addSubview:pwdTextField];
    pwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x4e4e54)}];
    pwdTextField.font = [UIFont systemFontOfSize:15.0];
    pwdTextField.textColor = [UIColor whiteColor];
    pwdTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *pwdTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_key_icon"]];
    pwdTextFieldLeftView.contentMode = UIViewContentModeCenter;
    pwdTextFieldLeftView.size = CGSizeMake(44.0, 44.0);
    pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    pwdTextField.leftView = pwdTextFieldLeftView;
    
//    // 分割线
//    UIView *inputCenterDivider = [[UIView alloc] init];
//    _inputCenterDivider = inputCenterDivider;
//    inputCenterDivider.backgroundColor = HEX_COLOR(0x1a1a1d);
//    [pwdView addSubview:inputCenterDivider];
//    
//    // 验证新密码
//    UITextField *rePwdTextField = [[UITextField alloc] init];
//    rePwdTextField.delegate = self;
//    _rePwdTextField = rePwdTextField;
//    [pwdView addSubview:rePwdTextField];
//    rePwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请重新输入新密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x4e4e54)}];
//    rePwdTextField.font = [UIFont systemFontOfSize:15.0];
//    rePwdTextField.textColor = [UIColor whiteColor];
//    rePwdTextField.returnKeyType = UIReturnKeyDone;
//    
//    UIImageView *rePwdTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_key_icon"]];
//    rePwdTextFieldLeftView.contentMode = UIViewContentModeCenter;
//    rePwdTextFieldLeftView.size = CGSizeMake(44.0, 44.0);
//    rePwdTextField.leftViewMode = UITextFieldViewModeAlways;
//    rePwdTextField.leftView = rePwdTextFieldLeftView;
}

- (void)setupConfirmButton
{
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(confirmBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HEX_COLOR(0xf2f2f2) forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    confirmButton.backgroundColor = HEX_COLOR(0xbc3581);
    confirmButton.layer.cornerRadius = 4.0;
    confirmButton.layer.masksToBounds = YES;
    [_container addSubview:confirmButton];
    
    _confirmButton = confirmButton;
}

- (void)updateConstraints
{
    if (!_didSetupConstaint) {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView.superview);
        }];
        
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container.superview);
            make.width.equalTo(_container.superview);
        }];
        
        [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_container).offset(15.0);
            make.left.equalTo(_container).offset(10.0);
            make.right.equalTo(_container).offset(-10.0);
            make.height.mas_equalTo(104.0);
        }];
        
        [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_phoneNumTextField.superview);
            make.bottom.equalTo(_inputCenterDivider.mas_top);
        }];
        
        CGFloat padding = 10.0;
        [_inputCenterDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_inputCenterDivider.superview).offset(padding);
            make.right.equalTo(_inputCenterDivider.superview).offset(-padding);
            make.height.mas_equalTo(1.0);
            make.centerY.equalTo(_inputCenterDivider.superview);
        }];
        
        [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_phoneNumTextField.superview);
            make.top.equalTo(_inputCenterDivider.mas_bottom);

        }];
        
        [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_codeView.mas_bottom).offset(10.0);
            make.left.right.equalTo(_codeView);
            make.height.mas_equalTo(52.0);
        }];
        
        [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(_pwdTextField.superview);

        }];
        
        
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_pwdView.mas_bottom).offset(10.0);
            make.left.right.equalTo(_pwdView);
            make.bottom.equalTo(_confirmButton.superview);
            make.height.mas_equalTo(39.0);
        }];
        
        _didSetupConstaint = YES;
    }
}


#pragma mark - Timer
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

- (void)setCurrentSecond:(NSInteger)currentSecond
{
    if (currentSecond < 0) {// 如果倒计时结束
        // 移除定时器
        [self removeTimer];
        // 验证码按钮可用
        _getCodeButton.enabled = YES;
        return;
    }
    _currentSecond = currentSecond;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_currentSecond] forState:UIControlStateDisabled];
}


#pragma mark - Action

- (void)tap
{
    [self.view endEditing:YES];
}

- (void)getCodeBtnOnClick:(UIButton *)button
{
    CSRequest *param = [[CSRequest alloc] init];
    param.phoneNum = GlobalObj.userInfo.phoneNum;
    param.action = [NSNumber numberWithInt:2];
    [self.view endEditing:YES];
    [CSLoginHttpTool loginCodeWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) { // 成功
            //
            // 设置倒计时数
            _currentSecond = COUNTDOWN_SECONDS;
            // 按钮为不可点击状态
            button.enabled = NO;
            [button setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_currentSecond] forState:UIControlStateDisabled];
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


- (void)confirmBtnOnClick:(UIButton *)confirmButton
{
    if (_codeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (_pwdTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
//    if (_rePwdTextField.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"请重新输入新密码"];
//        return;
//    }
//    if (![_rePwdTextField.text isEqualToString:_pwdTextField.text]) {
//        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
//        return;
//    }
    
    if (_pwdTextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码长度过短,请输入6~32个字符"];
        return;
    }
    if (_pwdTextField.text.length > 32) {
        [SVProgressHUD showErrorWithStatus:@"密码长度过长,请输入6~32个字符"];
        return;
    }
    
    [SVProgressHUD show];
    CSRequest *param = [[CSRequest alloc] init];
    param.alterPassword = _pwdTextField.text;
    param.phoneNum = GlobalObj.userInfo.phoneNum;
    param.verifyCode = _codeTextField.text;
    [CSLoginHttpTool alterPwdWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];

}


@end
