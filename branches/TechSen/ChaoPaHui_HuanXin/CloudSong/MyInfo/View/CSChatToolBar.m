//
//  CSChatToolBar.m
//  CloudSong
//
//  Created by sen on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSChatToolBar.h"
#import <Masonry.h>
#import "CSDefine.h"

@interface CSChatToolBar ()<UITextFieldDelegate>
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UITextField *inputTextField;
@property(nonatomic, weak) UIButton *spreadButton;
@end


@implementation CSChatToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x43246b);
        [self setupSubviews];
    }
    return self;
}

#pragma mark - SubView
- (void)setupSubviews
{
    UITextField *inputTextField = [[UITextField alloc] init];
    inputTextField.delegate = self;
    inputTextField.returnKeyType = UIReturnKeySend;
    inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    inputTextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    inputTextField.textColor = [UIColor whiteColor];
    
    inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"发送文字到屏幕,鼓励下唱歌的小伙伴吧~" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.6]}];
    inputTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.07];
    [self addSubview:inputTextField];
    _inputTextField = inputTextField;
    
    UIButton *spreadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [spreadButton setImage:[[UIImage imageNamed:@"room_add_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [spreadButton addTarget:self action:@selector(spreadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:spreadButton];
    _spreadButton = spreadButton;
}


#pragma mark - Inherit
- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(TRANSFER_SIZE(27.0));
            make.centerY.equalTo(_inputTextField.superview);
            make.left.mas_equalTo(TRANSFER_SIZE(8.0));
            make.right.mas_equalTo(TRANSFER_SIZE(-39.0));
        }];
        
        [_spreadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_inputTextField.mas_right);
            make.top.bottom.right.equalTo(_spreadButton.superview);
        }];
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) return NO;
    if ([self.delegate respondsToSelector:@selector(chatToolBarSendButtonPressedWithText:)]) {
        
        [self.delegate chatToolBarSendButtonPressedWithText:textField.text];
        textField.text = nil;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(chatToolBarInputTextFieldPressed:)]) {
        [self.delegate chatToolBarInputTextFieldPressed:self];
    }
    return YES;
}

#pragma mark - Action Methods
- (void)spreadButtonPressed
{
    if ([self.delegate respondsToSelector:@selector(chatToolBarSpreadButtonPressed)]) {
        [self.delegate chatToolBarSpreadButtonPressed];
    }
}


@end
