//
//  NBToLoginView.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBToLoginView.h"
#import "NBCommon.h"

@interface NBToLoginView()
@property(nonatomic, weak) UIButton *toLoginButton;
@property(nonatomic, weak) UILabel *phoneLabel;
@property(nonatomic, weak) UIImageView *userIcon;
@end
@implementation NBToLoginView
#pragma setter
- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    
    
    if (!_phoneLabel) {
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.hidden = YES;
        [self addSubview:phoneLabel];
        _phoneLabel = phoneLabel;

        phoneLabel.textColor = [UIColor whiteColor];
        if (iPhone6Plus) {
            phoneLabel.font = [UIFont systemFontOfSize:14.f];
        }else
        {
            phoneLabel.font = [UIFont systemFontOfSize:12.f];
        }
        [phoneLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.f];
    }
    if (!_userIcon) {
        UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_icon_with_login"]];
        userIcon.hidden = YES;
        [self addSubview:userIcon];
        _userIcon = userIcon;
        [userIcon autoCenterInSuperview];
    }
    _phoneLabel.text = phone;

    _phoneLabel.hidden = phone == nil;
    _userIcon.hidden = _phoneLabel.hidden;
    _toLoginButton.hidden = !_phoneLabel.hidden;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"mine_login_bg"];
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIButton *toLoginButton = [[UIButton alloc] initForAutoLayout];
    [self addSubview:toLoginButton];
    [toLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toLoginButton setTitle:@"点此登录" forState:UIControlStateNormal];
    toLoginButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    toLoginButton.layer.borderWidth = 1.f;
    toLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [toLoginButton autoSetDimensionsToSize:CGSizeMake(97.5f, 43.f)];
    [toLoginButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [toLoginButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:75.f];
    _toLoginButton = toLoginButton;
    
}

#pragma mark - public

- (void)toLoginBtnAddTarget:(id)target Action:(SEL)sel
{
//    NBLog(@"%@",_toLoginButton);
    [_toLoginButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}
@end
