//
//  CSMyInfoHeaderView.m
//  CloudSong
//
//  Created by sen on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSMyInfoHeaderView.h"
#import <Masonry.h>
#import "CSDefine.h"
#import <UIImageView+WebCache.h>
#define USER_ICON_RADIOUS TRANSFER_SIZE(27.0)
#define USER_ICON_BG_RADUOUS TRANSFER_SIZE(30.0)
#define LOGIN_BUTTON_HEIGHT TRANSFER_SIZE(31.0)
@interface CSMyInfoHeaderView ()
{
    BOOL _didSetupConstraint;
}
/** 头像View */
@property(nonatomic, weak) UIImageView *userIconView;

@property(weak, nonatomic) UIView *userIconBGView;
/** 姓名Label */
@property(nonatomic, weak) UILabel *userNameLabel;
/** 性别星座容器 */
@property(nonatomic, weak) UIView *consAndGenderView;
/** 性别view */
@property(nonatomic, weak) UIImageView *genderView;
/** 星座 */
@property(nonatomic, weak) UILabel *consLabel;
/** 未登录提示标语 */
@property(nonatomic, weak) UILabel *warningLabel;
/** 登录按钮 */
@property(nonatomic, weak) UIButton *loginButton;
/** 个人主页按钮 */
@property(nonatomic, weak) UIButton *personPageButton;
@end


@implementation CSMyInfoHeaderView
#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubViews
{
    [self setupBackgroundView];
    [self setupCenterView];

}

- (void)setupBackgroundView
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bg"]];
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
}

- (void)setupCenterView
{
    UIView *centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    _centerView = centerView;
    
    // 用户头像
    UIImageView *userIconView = [[UIImageView alloc] init];
    userIconView.image = [UIImage imageNamed:@"mine_default_user_icon"];
    userIconView.layer.cornerRadius = USER_ICON_RADIOUS;
    userIconView.layer.masksToBounds = YES;
//    userIconView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.04].CGColor;
//    userIconView.layer.borderWidth = 3.0;
    [centerView addSubview:userIconView];
    _userIconView = userIconView;
    
    UIView *userIconBGView = [[UIView alloc] init];
    userIconBGView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    userIconBGView.layer.cornerRadius = USER_ICON_BG_RADUOUS;
    userIconBGView.layer.masksToBounds = YES;

    [centerView addSubview:userIconBGView];
    _userIconBGView = userIconBGView;
    
    // 用户名称
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = HEX_COLOR(0xffffff);
    userNameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
//    userNameLabel.text = @"保罗哈哈哈";
    [centerView addSubview:userNameLabel];
    userNameLabel.hidden = YES;
    _userNameLabel = userNameLabel;
    
    // 星座性别容器
    UIView *consAndGenderView = [[UIView alloc] init];
    [centerView addSubview:consAndGenderView];
    consAndGenderView.hidden = YES;
    _consAndGenderView = consAndGenderView;
    // 性别
    UIImageView *genderView = [[UIImageView alloc] init];
    genderView.image = [UIImage imageNamed:@"mine_man"];
    [consAndGenderView addSubview:genderView];
    _genderView = genderView;
    
    // 星座
    UILabel *consLabel = [[UILabel alloc] init];
    consLabel.textColor = HEX_COLOR(0xb5b7bf);
    consLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
//    consLabel.text = @"水瓶座";
    [consAndGenderView addSubview:consLabel];
    _consLabel = consLabel;
    
    // 未登录
    UILabel *warningLabel = [[UILabel alloc] init];
    warningLabel.text = @"还没登录呢?赶快登录潮趴汇KTV,尽享音乐的海洋!";
    warningLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    warningLabel.textColor = HEX_COLOR(0xf1f0f1);
    [centerView addSubview:warningLabel];
    _warningLabel = warningLabel;
    
    // 登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.backgroundColor = [HEX_COLOR(0x7447b1) colorWithAlphaComponent:0.8];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
//    loginButton.layer.borderColor = HEX_COLOR(0x786369).CGColor;
//    loginButton.layer.borderWidth = 1.5;
    loginButton.layer.cornerRadius = LOGIN_BUTTON_HEIGHT * 0.5;
    loginButton.layer.masksToBounds = YES;
    [centerView addSubview:loginButton];
    _loginButton = loginButton;
    
    // 个人主页按钮
    UIButton *personPageButton = [[UIButton alloc] init];
    [centerView addSubview:personPageButton];
    personPageButton.hidden = YES;
    _personPageButton = personPageButton;
    
}


- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(2 * USER_ICON_RADIOUS, 2 * USER_ICON_RADIOUS));
            make.centerX.equalTo(_centerView);
            make.top.equalTo(_centerView).offset(TRANSFER_SIZE(30.0));
        }];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_centerView);
            make.top.equalTo(_userIconView.mas_bottom).offset(TRANSFER_SIZE(15.0));
        }];
        
        [_consAndGenderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_centerView);
            make.top.equalTo(_userNameLabel.mas_bottom).offset(TRANSFER_SIZE(12.0));
        }];
        
        [_genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_consAndGenderView);
            make.left.equalTo(_consAndGenderView);
        }];
        
        [_consLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(_consAndGenderView);
            make.left.equalTo(_genderView.mas_right).offset(TRANSFER_SIZE(6.0));
        }];
        
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_centerView);
            make.top.equalTo(_userIconView.mas_bottom).offset(TRANSFER_SIZE(13.0));
        }];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(121.0), TRANSFER_SIZE(31.0)));
            make.centerX.equalTo(_centerView);
            make.top.equalTo(_warningLabel.mas_bottom).offset(TRANSFER_SIZE(8.0));
        }];
        
        [_personPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_personPageButton.superview);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(115.0), TRANSFER_SIZE(135.0)));
        }];
        
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

- (void)loginButtonAddTarget:(id)target action:(SEL)sel
{
    [_loginButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)personPageButtonAddTarget:(id)target action:(SEL)sel
{
    [_personPageButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public
- (void)setItem:(CSUserInfoModel *)item
{
    _item = item;
    if (item) { // 如果获取到用户信息 说明用户已登录
        _userNameLabel.hidden = NO;
        _consAndGenderView.hidden = NO;
        _warningLabel.hidden = YES;
        _loginButton.hidden = YES;
        _personPageButton.hidden = NO;
        if (_item.headUrl) {
            [_userIconView sd_setImageWithURL:[NSURL URLWithString:_item.headUrl] placeholderImage:GlobalObj.userIcon];
        }else
        {
            _userIconView.image = [UIImage imageNamed:@"mine_default_user_icon"];
        }
        
        _userNameLabel.text = _item.nickName.length > 0?_item.nickName:@"无名氏";

        _genderView.image = [UIImage imageNamed:[_item.gender isEqualToString:@"男"]?@"mine_man":@"mine_female"];
        _consLabel.text = _item.constellation.length > 0?_item.constellation:@"无星座";
    }else
    {
        _userIconView.image = [UIImage imageNamed:@"mine_default_user_icon"];
        _userNameLabel.hidden = YES;
        _consAndGenderView.hidden = YES;
        _warningLabel.hidden = NO;
        _loginButton.hidden = NO;
        _personPageButton.hidden = YES;
    }
}
@end
