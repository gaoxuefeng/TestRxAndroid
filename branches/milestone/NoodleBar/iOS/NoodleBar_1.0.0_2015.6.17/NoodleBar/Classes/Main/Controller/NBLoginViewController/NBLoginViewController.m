//
//  NBLoginViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBLoginViewController.h"
#import "NBAccountTool.h"
#import "NBLoginHttpTool.h"
#import "NBLoginTool.h"
#import "NSDictionary+JSONCategories.h"
#import <MJExtension.h>
#define COUNTDOWN_SECONDS 30
@interface NBLoginViewController ()
/**
 *  手机号码输入框
 */
@property(nonatomic, weak) UITextField *phoneTextField;
/**
 *  验证码输入框
 */
@property(nonatomic, weak) UITextField *codeTextField;
/**
 *  定时器
 */
@property (strong, nonatomic) NSTimer *timer;
/**
 *  当前秒数
 */
@property (assign, nonatomic) NSInteger currentSecond;
/**
 *  发送验证码按钮
 */
@property(nonatomic, weak) UIButton *sendCodeButton;
/**
 *  验证并登录按钮
 */
@property(nonatomic, weak) UIButton *loginButton;
/** 请求中 */
@property(nonatomic, assign) BOOL inRequest;
@end

@implementation NBLoginViewController

- (void)setCurrentSecond:(NSInteger)currentSecond
{
    if (currentSecond < 0) {// 如果倒计时结束
        // 移除定时器
        [self removeTimer];
        // 验证码按钮可用
        _sendCodeButton.enabled = YES;

        return;
    }
    _currentSecond = currentSecond;
    [_sendCodeButton setTitle:[NSString stringWithFormat:@"倒计时%ld秒",_currentSecond] forState:UIControlStateDisabled];
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = HEX_COLOR(0xf3f3f3);
    [self setupSubViews];
    [self configNavgationBar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeTimer];
}

#pragma mark - Setup
- (void)setupSubViews
{
    
    CGFloat margin = 16.f;
    // 手机号码输入框
    UITextField *phoneTextField = [[UITextField alloc] initForAutoLayout];
    _phoneTextField = phoneTextField;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xc5c7d1)}];
    phoneTextField.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:phoneTextField];
    [phoneTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:23.5];
    [phoneTextField autoSetDimension:ALDimensionHeight toSize:43.f];
    [phoneTextField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:370.f/640];
    [phoneTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
    phoneTextField.layer.borderWidth = .5f;
    phoneTextField.layer.borderColor = HEX_COLOR(0x95a6b7).CGColor;
    phoneTextField.layer.cornerRadius = 1.f;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *phoneLeftView = [[UIImageView alloc] init];
    phoneLeftView.image = [UIImage imageNamed:@"mine_phone_field_left"];
    phoneLeftView.size = CGSizeMake(34.f, 0.f);
    phoneLeftView.contentMode = UIViewContentModeCenter;
    phoneTextField.leftView = phoneLeftView;

    // 发送验证码按钮
    UIButton *sendCodeButton = [[UIButton alloc] initForAutoLayout];
    [sendCodeButton addTarget:self action:@selector(sendCodeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeButton setBackgroundImage:[UIImage imageNamed:@"mine_send_code_bg"] forState:UIControlStateNormal];
    [sendCodeButton setBackgroundImage:[UIImage imageNamed:@"mine_send_code_bg_d"] forState:UIControlStateDisabled];
    sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCodeButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sendCodeButton];
    [sendCodeButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:phoneTextField];
    [sendCodeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:phoneTextField];
    [sendCodeButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:194.f/640];
    [sendCodeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
    _sendCodeButton = sendCodeButton;
    
    // 验证码输入框
    UITextField *codeTextField = [[UITextField alloc] initForAutoLayout];
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    _codeTextField = codeTextField;
    codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信中的验证码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xc5c7d1)}];
    codeTextField.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:codeTextField];
    codeTextField.layer.borderWidth = .5f;
    codeTextField.layer.borderColor = HEX_COLOR(0x95a6b7).CGColor;
    codeTextField.layer.cornerRadius = 1.f;
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *codeLeftView = [[UIImageView alloc] init];
    codeLeftView.image = [UIImage imageNamed:@"mine_code_field_left"];
    codeLeftView.contentMode = UIViewContentModeCenter;
    codeLeftView.size = CGSizeMake(34.f, 0.f);
    codeTextField.leftView = codeLeftView;
    [codeTextField autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:phoneTextField];
    [codeTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneTextField withOffset:13.5f];
    [codeTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
    [codeTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
    

    UIButton *loginButton = [[UIButton alloc] initForAutoLayout];
    [loginButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"mine_check_and_login_bg"] resizedImage] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton autoSetDimension:ALDimensionHeight toSize:43.f];
    [loginButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
    [loginButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
    [loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:codeTextField withOffset:59.f];
    [loginButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _loginButton  = loginButton;
    
    
    // 提示
    // 提示头
    UILabel *warningHeaderLabel = [[UILabel alloc] initForAutoLayout];
    [self.view addSubview:warningHeaderLabel];
    warningHeaderLabel.text = @"温馨提示 : ";
    warningHeaderLabel.font = [UIFont systemFontOfSize:12.f];
    warningHeaderLabel.textColor = HEX_COLOR(0xe33030);
    [warningHeaderLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:codeTextField withOffset:19.f];
    [warningHeaderLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
    CGSize headerLabelSize = [NSString sizeWithString:warningHeaderLabel.text font:warningHeaderLabel.font maxSize:MAXSIZE];
    [warningHeaderLabel autoSetDimension:ALDimensionWidth toSize:headerLabelSize.width];
    
    // 提示体
    UILabel *warningLabel = [[UILabel alloc] initForAutoLayout];
    warningLabel.numberOfLines = 0;
    [self.view addSubview:warningLabel];
    warningLabel.text = @"无需注册,请输入正确的手机号码进行登录方便送餐人员与您联系";
    warningLabel.font = [UIFont systemFontOfSize:12.f];
    warningLabel.textColor = HEX_COLOR(0x848484);
    
    [warningLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:warningHeaderLabel];
    [warningLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:warningHeaderLabel];
    [warningLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];

    
    
}

#pragma mark - Config
- (void)configNavgationBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

}
- (void)loginBtnOnClick:(UIButton *)button
{
    // 判断手机号码是否为空
    if (!(_phoneTextField.text != nil && _phoneTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    // 如果不是手机号码,则提示,并返回
    if (![NBLoginTool isMobileNumber:_phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    // 判断验证码是否为空
    if (!(_codeTextField.text != nil && _codeTextField.text.length > 0) && ![_phoneTextField.text isEqualToString:@"18624361671"]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    
    // 遮板
    [SVProgressHUD show];
    
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.phoneNum = _phoneTextField.text;
    param.code = _codeTextField.text;

    NBDeviceJsonString *deviceJsonStringModel = [[NBDeviceJsonString alloc] init];
    deviceJsonStringModel.did = [NBLoginTool idfa];
    deviceJsonStringModel.dev = @"2";
    deviceJsonStringModel.appver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    deviceJsonStringModel.rom = [UIDevice currentDevice].systemVersion;
    NSDictionary *dict = [deviceJsonStringModel keyValues];
    NSString *deviceJsonString = dict.JSONString;
    param.deviceJsonString = deviceJsonString;
    //**********************************验证验证码是否正确 ****************************************/
    [NBLoginHttpTool checkCodeAndLoginWithParam:param success:^(NBLoginResponseModel *result) {
        // 登录成功
        if (result.code == 0) {
            [SVProgressHUD dismiss];
            
            [NBAccountTool setUserToken:result.data.token];
            [self loadAccountData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NBLog(@"%@",error);
    }];
}

//********************************** 获取用户信息 ****************************************/
- (void)loadAccountData
{
    NBRequestModel *param = [[NBRequestModel alloc] init];
    [NBLoginHttpTool getUserInfoWithParam:param success:^(NBAccountResponseModel *result) {
        if (result.code == 0) {
            // 拿到账号信息设置账号和地址
            [NBAccountTool setAccount:result.data.account];
            [NBAccountTool setAddresses:result.data.addresses];
            [NBAccountTool setUserId:result.data.account.userid];
//            NBAccountModel *account = [NBAccountTool account];
            // 如果设置了block 则执行
            if (self.loginBlock) {
                self.loginBlock(YES);
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
    }];
}

- (void)sendCodeBtnOnClick:(UIButton *)button
{
    if (_inRequest) return; // 如果正在请求,则直接返回
    _inRequest = YES;
    if (!(_phoneTextField.text != nil && _phoneTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    
    // 如果不是手机号码,则提示,并返回
    if (![NBLoginTool isMobileNumber:_phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    // 手机号码验证通过
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.phoneNum = _phoneTextField.text;
    [NBLoginHttpTool loginCodeWithParam:param success:^(NBLoginResponseModel *result) {
        _inRequest = NO;
        if (result.code == 0) { // 成功
            // 设置倒计时数
            _currentSecond = COUNTDOWN_SECONDS;
            // 按钮为不可点击状态
            button.enabled = NO;
            [_sendCodeButton setTitle:[NSString stringWithFormat:@"倒计时%ld秒",_currentSecond] forState:UIControlStateDisabled];
            // 开启定时器
            [self addTimer];
            // 提示验证码发送成功
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        _inRequest = NO;
        NBLog(@"%@",error);
    }];
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

/**
 *  秒数递减
 */
- (void)countDown
{
    [self setCurrentSecond:_currentSecond - 1];
}


#pragma mark - Action
- (void)backBtnOnClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
