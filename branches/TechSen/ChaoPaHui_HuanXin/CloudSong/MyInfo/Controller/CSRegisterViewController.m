//
//  CSRegisterViewController.m
//  CloudSong
//
//  Created by Ronnie on 15/6/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//


#import "CSRegisterViewController.h"
#import "Header.h"
#import "CSLoginHttpTool.h"
#import "CSEditUserInfoViewController.h"
#import "CSUserDataResponeModel.h"
#import <APService.h>
#define COUNTDOWN_SECONDS 60

static const NSInteger default_max_length = 20;

@interface CSRegisterViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIView *container;
/** 验证验证码区域 */
@property(nonatomic, weak) UIView *checkCodeAreaView;
/** 设置用户信息区域 */
@property(nonatomic, weak) UIView *setUserInfoAreaView;
/** 手机号码输入框 */
@property(nonatomic, weak) UITextField *phoneNumTextField;
/** 验证码输入框 */
@property(nonatomic, weak) UITextField *codeTextField;
/** 设置密码输入框 */
@property(nonatomic, weak) UITextField *setPwdTextField;
/** 设置昵称输入框 */
@property(nonatomic, weak) UITextField *setNickNameTextField;
/** 定时器 */
@property (strong, nonatomic) NSTimer *timer;
/** 当前秒数 */
@property (assign, nonatomic) NSInteger currentSecond;
/** 获取验证码按钮 */
@property(nonatomic, weak) UIButton *getCodeButton;
/** 验证按钮 */
@property(nonatomic, weak) UIButton *checkButton;
/** 注册按钮 */
@property(nonatomic, weak) UIButton *registerButton;

@property(nonatomic, copy) NSString *overString;

@end

@implementation CSRegisterViewController
#pragma mark - Getter & Setter

- (void)setCurrentSecond:(NSInteger)currentSecond
{
    if (currentSecond < 0) {// 如果倒计时结束
        // 移除定时器
        [self removeTimer];
        // 验证码按钮可用
        _getCodeButton.userInteractionEnabled = YES;
        _getCodeButton.enabled = YES;
        return;
    }
    _currentSecond = currentSecond;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_currentSecond] forState:UIControlStateDisabled];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setupSubViews];
    [self setupGestureRecognizer];
//    self.view.backgroundColor = HEX_COLOR(0x151417);

}


- (void)viewWillAppear:(BOOL)animated
{

    // 注册文本输入框字符改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [self setupScrollView];
    [self setupCheckCodeAreaView];
    [self setupCheckButton];
    [self setupSetUserInfoAreaView];
    [self setupRegisterButton];

    
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
//    self.scrollView.scrollEnabled = NO;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _scrollView = scrollView;
    UIView *container = [[UIView alloc] init];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    _container = container;
    
    
}

- (void)setupCheckCodeAreaView
{
    UIView *checkCodeAreaView = [[UIView alloc] init];
    _checkCodeAreaView = checkCodeAreaView;
//    checkCodeAreaView.backgroundColor = HEX_COLOR(0x1e1d21);
    checkCodeAreaView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
    checkCodeAreaView.layer.cornerRadius = TRANSFER_SIZE(4.0);
    checkCodeAreaView.layer.masksToBounds = YES;
    [_container addSubview:checkCodeAreaView];
    
    [checkCodeAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(_container).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(_container).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(104.0));
    }];
    
    // 手机号输入框
    UITextField *phoneNumTextField = [[UITextField alloc] init];
    phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneNumTextField.delegate = self;
    _phoneNumTextField = phoneNumTextField;
    [checkCodeAreaView addSubview:phoneNumTextField];
    phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x9893a0)}];
    phoneNumTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    phoneNumTextField.textColor = [UIColor whiteColor];
    phoneNumTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *phoneNumTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_phone_icon"]];
    phoneNumTextFieldLeftView.contentMode = UIViewContentModeCenter;
    phoneNumTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumTextField.leftView = phoneNumTextFieldLeftView;
    
    // 分割线
    UIView *inputCenterDivider = [[UIView alloc] init];
    inputCenterDivider.backgroundColor = HEX_COLOR(0x3c2c53);
    [checkCodeAreaView addSubview:inputCenterDivider];
    
    // 验证码
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.delegate = self;
    _codeTextField = codeTextField;
    [checkCodeAreaView addSubview:codeTextField];
    codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x9893a0)}];
    codeTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    codeTextField.textColor = [UIColor whiteColor];
    codeTextField.returnKeyType = UIReturnKeyGo;
    
    UIImageView *codeTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_verification_code_icon"]];
    codeTextFieldLeftView.contentMode = UIViewContentModeCenter;
    codeTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.leftView = codeTextFieldLeftView;
    
    // 获取验证码按钮
    UIButton *getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeButton addTarget:self action:@selector(getCodeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _getCodeButton = getCodeButton;
    getCodeButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.06];
    getCodeButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [getCodeButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCodeButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    getCodeButton.layer.masksToBounds = YES;
    getCodeButton.size = CGSizeMake(TRANSFER_SIZE(110.0), TRANSFER_SIZE(36.0));
    getCodeButton.x = 0;
    
    UIView *codeTextFieldRightView = [[UIView alloc] init];
    codeTextFieldRightView.size = CGSizeMake(TRANSFER_SIZE(120.0), TRANSFER_SIZE(36.0));
    [codeTextFieldRightView addSubview:getCodeButton];
    
    codeTextField.rightViewMode = UITextFieldViewModeAlways;
    codeTextField.rightView = codeTextFieldRightView;

    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(checkCodeAreaView);
        make.bottom.equalTo(inputCenterDivider.mas_top);
    }];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCenterDivider.mas_bottom);
        make.left.right.bottom.equalTo(checkCodeAreaView);
    }];
    
    CGFloat padding = TRANSFER_SIZE(10.0);
    [inputCenterDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo( 1 / [UIScreen mainScreen].scale);
        make.left.equalTo(checkCodeAreaView).offset(padding);
        make.right.equalTo(checkCodeAreaView).offset(-padding);
        make.centerY.equalTo(checkCodeAreaView);
    }];
}

- (void)setupCheckButton
{
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [checkButton addTarget:self action:@selector(checkBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setTitle:@"验证" forState:UIControlStateNormal];
    [checkButton setTitleColor:HEX_COLOR(0xf2f2f2) forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    checkButton.backgroundColor = HEX_COLOR(0xbc3581);
    checkButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    checkButton.layer.masksToBounds = YES;
    [_container addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkCodeAreaView.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.right.equalTo(_checkCodeAreaView);
        make.height.mas_equalTo(TRANSFER_SIZE(39.0));
    }];
    _checkButton = checkButton;
}

- (void)setupSetUserInfoAreaView
{
    UIView *setUserInfoAreaView = [[UIView alloc] init];
    _setUserInfoAreaView = setUserInfoAreaView;
    setUserInfoAreaView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
    setUserInfoAreaView.layer.cornerRadius = TRANSFER_SIZE(4.0);
    setUserInfoAreaView.layer.masksToBounds = YES;
    [_container addSubview:setUserInfoAreaView];
    
    [setUserInfoAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkCodeAreaView.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.right.equalTo(_checkCodeAreaView);
        make.height.mas_equalTo(TRANSFER_SIZE(104.0));
    }];
    
    // 设置密码框
    UITextField *setPwdTextField = [[UITextField alloc] init];
    setPwdTextField.delegate = self;
    _setPwdTextField = setPwdTextField;
    setPwdTextField.secureTextEntry = YES;
    [setUserInfoAreaView addSubview:setPwdTextField];
    setPwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置登录密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x9893a0)}];
    setPwdTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    setPwdTextField.textColor = [UIColor whiteColor];
    setPwdTextField.returnKeyType = UIReturnKeyNext;
    
    UIImageView *setPwdTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_key_icon"]];
    setPwdTextFieldLeftView.contentMode = UIViewContentModeCenter;
    setPwdTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    setPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    setPwdTextField.leftView = setPwdTextFieldLeftView;
    
    // 分割线
    UIView *inputCenterDivider = [[UIView alloc] init];
    inputCenterDivider.backgroundColor = WhiteColor_Alpha_6;
    [setUserInfoAreaView addSubview:inputCenterDivider];
    
    // 设置昵称
    UITextField *setNickNameTextField = [[UITextField alloc] init];
    setNickNameTextField.delegate = self;
    _setNickNameTextField = setNickNameTextField;
    [setUserInfoAreaView addSubview:setNickNameTextField];
    setNickNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置一个昵称" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x9893a0)}];
    setNickNameTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    setNickNameTextField.textColor = [UIColor whiteColor];
    setNickNameTextField.returnKeyType = UIReturnKeyDone;
    
    UIImageView *setNickNameTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_name_icon"]];
    setNickNameTextFieldLeftView.contentMode = UIViewContentModeCenter;
    setNickNameTextFieldLeftView.size = CGSizeMake(TRANSFER_SIZE(44.0), TRANSFER_SIZE(44.0));
    setNickNameTextField.leftViewMode = UITextFieldViewModeAlways;
    setNickNameTextField.leftView = setNickNameTextFieldLeftView;
    
    [setPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(setUserInfoAreaView);
        make.bottom.equalTo(inputCenterDivider.mas_top);
    }];
    
    [setNickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCenterDivider.mas_bottom);
        make.left.right.bottom.equalTo(setUserInfoAreaView);
    }];
    
    CGFloat padding = TRANSFER_SIZE(10.0);
    [inputCenterDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2 / [UIScreen mainScreen].scale);
        make.left.equalTo(setUserInfoAreaView).offset(padding);
        make.right.equalTo(setUserInfoAreaView).offset(-padding);
        make.centerY.equalTo(setUserInfoAreaView);
    }];
    
    setUserInfoAreaView.hidden = YES;
}

- (void)setupRegisterButton
{
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerButton addTarget:self action:@selector(registerBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:HEX_COLOR(0xf2f2f2) forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    registerButton.backgroundColor = HEX_COLOR(0xbc3581);
    registerButton.layer.cornerRadius = TRANSFER_SIZE(4.0);
    registerButton.layer.masksToBounds = YES;
    [_container addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setUserInfoAreaView.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.right.equalTo(_setUserInfoAreaView);
        make.bottom.equalTo(_container);
        make.height.mas_equalTo(TRANSFER_SIZE(39.0));
    }];
    _registerButton = registerButton;
    registerButton.hidden = YES;
}





#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _setNickNameTextField) {
        [_setNickNameTextField resignFirstResponder];
        [self registerBtnOnClick:_registerButton];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (iPhone4) {
        if (textField == _setPwdTextField) {
            [self.scrollView setContentOffset:CGPointMake(0, 100.0) animated:YES];
        }else if (textField == _setNickNameTextField)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 100.0) animated:YES];
        }
    }else if (iPhone5)
    {
        if (textField == _setPwdTextField) {
            [self.scrollView setContentOffset:CGPointMake(0, 50.0) animated:YES];
        }else if (textField == _setNickNameTextField)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 50.0) animated:YES];
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

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
    _getCodeButton.enabled = YES;
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
    [self.view endEditing:YES];
}

- (void)getCodeBtnOnClick:(UIButton *)button
{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    return;
    if (!(_phoneNumTextField.text != nil && _phoneNumTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    // 如果不是手机号码,则提示,并返回
    if (![PublicMethod isMobileNumber:_phoneNumTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    // 手机号码验证通过
    CSRequest *param = [[CSRequest alloc] init];
    param.phoneNum = _phoneNumTextField.text;
    param.action = [NSNumber numberWithInt:0];
    [self.view endEditing:YES];
    button.userInteractionEnabled = NO;
    [CSLoginHttpTool loginCodeWithParam:param success:^(CSBaseResponseModel *result) {
        button.userInteractionEnabled = YES;
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
        }else if(result.code == 6)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该手机号已被注册，无法重复注册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回登录",@"忘记密码",nil];
            [alertView show];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
        button.userInteractionEnabled = YES;
    }];
}

/** 验证按钮点击 */
- (void)checkBtnOnClick:(UIButton *)button
{
    
    if (!(_phoneNumTextField.text != nil && _phoneNumTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    // 如果不是手机号码,则提示,并返回
    if (![PublicMethod isMobileNumber:_phoneNumTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    if (!_codeTextField.text.length > 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    // 验证验证码
    CSRequest *param = [[CSRequest alloc] init];
    param.phoneNum = _phoneNumTextField.text;
    param.verifyCode = _codeTextField.text;
    [CSLoginHttpTool checkSmsCodeWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) { // 验证成功
            _codeTextField.enabled = NO;
            _phoneNumTextField.enabled = NO;
            _setUserInfoAreaView.hidden = NO;
            _registerButton.hidden = NO;
            _checkButton.hidden = YES;
            [_phoneNumTextField resignFirstResponder];
            [_codeTextField resignFirstResponder];
            [self removeTimer];
            [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}

/** 注册按钮点击 */
- (void)registerBtnOnClick:(UIButton *)button
{
    
    [self.view endEditing:YES];
    
    if (_setPwdTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    _setNickNameTextField.text = [_setNickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([PublicMethod stringContainsEmoji:_setNickNameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"暂不支持表情符号作为昵称"];
        return;
    }
    
    if ([PublicMethod isBlankString:_setNickNameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户昵称"];
        return;
    }
    
    if (_setPwdTextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码长度过短,请输入6~32个字符"];
        return;
    }
    if (_setPwdTextField.text.length > 32) {
        [SVProgressHUD showErrorWithStatus:@"密码长度过长,请输入6~32个字符"];
        return;
    }
    
    if ([self getBytesLength:_setNickNameTextField.text] > 20) {
        [SVProgressHUD showErrorWithStatus:@"用户昵称过长,最多20个字符"];
        return;
    }
    
    CSRequest *param = [[CSRequest alloc] init];
    param.nickName = [_setNickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    param.password = _setPwdTextField.text;
    param.phoneNum = _phoneNumTextField.text;
    param.registrationId = [APService registrationID];
    param.verifyCode = _codeTextField.text;
    param.regisType = [NSNumber numberWithInteger:0];
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [CSLoginHttpTool userRegisterWithParam:param success:^(CSUserDataWrapperModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            [GlobalVar sharedSingleton].token = result.data.token;
            [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
            CSEditUserInfoViewController *editUserInfoVc = [[CSEditUserInfoViewController alloc] initWithType:CSEditUserInfoViewControllerTypeConfirm];
            editUserInfoVc.startBlock = ^{
                if (self.finishBlock) {
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    self.finishBlock();
                }else
                {
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                }
            };
            [self.navigationController pushViewController:editUserInfoVc animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}

- (NSInteger)getBytesLength:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    return [data length];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else
    {
        id delegate = nil;
        if ([self.delegate respondsToSelector:@selector(registerViewControllerDidClickForgetPwdButton)]) {
            delegate = self.delegate;
            [self.navigationController popViewControllerAnimated:NO];
            [delegate registerViewControllerDidClickForgetPwdButton];
        }
    }
}

#pragma mark - Private Methods
- (void)textFieldEditChanged:(NSNotification *)notification
{
    
    NSString *toBeString = _setNickNameTextField.text;
    NSString *lang = [[_setNickNameTextField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_setNickNameTextField markedTextRange];
        _overString = [_setNickNameTextField textInRange:selectedRange];
        
        //获取高亮部分
        UITextPosition *position = [_setNickNameTextField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > default_max_length) {
                _setNickNameTextField.text = [toBeString substringToIndex:default_max_length];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            //            ZBZLog(@"有高亮文字");
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > default_max_length) {
            _setNickNameTextField.text = [toBeString substringToIndex:default_max_length];
        }
    }
}
@end
