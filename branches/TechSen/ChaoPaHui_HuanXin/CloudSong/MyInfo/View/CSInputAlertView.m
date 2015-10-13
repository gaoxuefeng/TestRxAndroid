//
//  CSInputAlertView.m
//  CloudSong
//
//  Created by sen on 15/6/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSInputAlertView.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "SVProgressHUD.h"
#define DEFAULT_MAX_LENGTH 10
@interface CSInputAlertView ()<UITextFieldDelegate>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *cancelTitle;
@property(nonatomic, copy) NSString *confirmTitle;

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIButton *cover;

@property(nonatomic, weak) UIView *vLine;
@property(nonatomic, weak) UIView *hLine;


@property(nonatomic, weak) UIButton *cancelButton;

@property(nonatomic, weak) UIButton *confirmButton;

@property(nonatomic, weak) MASConstraint *selfBottomY;

/** 超出部分文本 */
@property (copy, nonatomic) NSString *overString;

@property(nonatomic, assign) BOOL didSetupConstraint;

@end


@implementation CSInputAlertView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content delegate:(id<CSInputAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle
{
    _title = title;
    _content = content;
    _cancelTitle = cancelTitle;
    _confirmTitle = confirmTitle;
    _delegate = delegate;
    
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = TRANSFER_SIZE(2.0);
        self.layer.masksToBounds = YES;
        self.backgroundColor = HEX_COLOR(0x412469);
        [self setupSubViews];
        [self setupNotifications];
    }
    return self;
}

#pragma mark - Setup

- (void)setupNotifications
{
    // 注册文本输入框字符改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textColor = HEX_COLOR(0x707175);
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.text = _content;
    textField.delegate = self;
    textField.layer.cornerRadius = TRANSFER_SIZE(2.0);
    textField.layer.masksToBounds = YES;
    textField.textColor = HEX_COLOR(0xb5b7bf);
    textField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(13.0)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    textField.backgroundColor = HEX_COLOR(0x381e59);
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.frame = CGRectMake(0, 0, TRANSFER_SIZE(5.0), 0);
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:textField];
    _textField = textField;
    
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = HEX_COLOR(0x1d1d1d);
    [self addSubview:vLine];
    _vLine = vLine;
    
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = vLine.backgroundColor;
    [self addSubview:hLine];
    _hLine = hLine;


    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton addTarget:self action:@selector(cancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [cancelButton setTitleColor:HEX_COLOR(0x707175) forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    _cancelButton = cancelButton;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:_confirmTitle forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [confirmButton setTitleColor:HEX_COLOR(0xff41ab) forState:UIControlStateNormal];
    [self addSubview:confirmButton];
    _confirmButton = confirmButton;
    
    
}


- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleLabel.superview);
            make.top.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(16.0));
        }];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(TRANSFER_SIZE(16.0));
            make.left.equalTo(_textField.superview).offset(TRANSFER_SIZE(13.0));
            make.right.equalTo(_textField.superview).offset(-TRANSFER_SIZE(13.0));
            make.height.mas_equalTo(TRANSFER_SIZE(25.0));
        }];

        [_hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textField.mas_bottom).offset(TRANSFER_SIZE(21.0));
            make.left.right.equalTo(_hLine.superview);
            make.height.mas_equalTo(TRANSFER_SIZE(0.5));
        }];

        [_vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_hLine.mas_bottom);
            make.centerX.equalTo(_vLine.superview);
            make.bottom.equalTo(_vLine.superview);
            make.width.mas_equalTo(TRANSFER_SIZE(0.5));
        }];
        

        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_hLine.mas_bottom);
            make.left.equalTo(_cancelButton.superview);
            make.right.equalTo(_vLine.mas_left);
            make.height.mas_equalTo(TRANSFER_SIZE(40.0));
        }];
        
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_hLine.mas_bottom);
            make.right.equalTo(_confirmButton.superview);
            make.left.equalTo(_vLine.mas_right);
            make.height.mas_equalTo(TRANSFER_SIZE(40.0));

        }];
        
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)textFieldEditChanged:(NSNotification *)notification
{
    
    NSString *toBeString = _textField.text;
    NSString *lang = [[_textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_textField markedTextRange];
        _overString = [_textField textInRange:selectedRange];
        
        //获取高亮部分
        UITextPosition *position = [_textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > (_maxLength == 0?DEFAULT_MAX_LENGTH:_maxLength)) {
                _textField.text = [toBeString substringToIndex:(_maxLength == 0?DEFAULT_MAX_LENGTH:_maxLength)];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            //            ZBZLog(@"有高亮文字");
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > (_maxLength == 0?DEFAULT_MAX_LENGTH:_maxLength)) {
            _textField.text = [toBeString substringToIndex:(_maxLength == 0?DEFAULT_MAX_LENGTH:_maxLength)];
        }
    }
}
- (void)show
{
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    [cover addTarget:self action:@selector(cancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    cover.alpha = 0.0;
    _cover = cover;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:cover];
    [window addSubview:self];
    
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cover.superview);
    }];
    
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).offset(TRANSFER_SIZE(53.0));
        make.right.equalTo(self.superview).offset(-TRANSFER_SIZE(53.0));
        _selfBottomY = make.top.equalTo(self.superview.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(135.0));
    }];
    
    [_textField becomeFirstResponder];
    [window layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:7 << 16 animations:^{
        _selfBottomY.offset = - (SCREENHEIGHT - TRANSFER_SIZE(100.0));
        cover.alpha = 0.5;
         [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
//
    
}

#pragma mark - Action
- (void)cancelBtnOnClick
{
    [_textField resignFirstResponder];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:7 << 16 animations:^{
        _selfBottomY.offset = 0;
        _cover.alpha = 0.0;
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}

- (void)confirmBtnOnClick
{
    if ([self getBytesLength:_textField.text] > (_maxLength>0?_maxLength:DEFAULT_MAX_LENGTH * 2)) {
        [SVProgressHUD showErrorWithStatus:@"用户昵称过长,最多20个字符"];
        return;
    }
    
    if (_overString != nil && _overString.length > 0) {
        self.textField.text = [[self.textField.text stringByReplacingOccurrencesOfString:_overString withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    if ([PublicMethod isBlankString:self.textField.text]) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    
    if (self.didInputBlock) {
        self.didInputBlock(_textField.text);
    }else
    {
        if ([self.delegate respondsToSelector:@selector(inputAlertView:didInputText:)]) {
            [self.delegate inputAlertView:self didInputText:_textField.text];
        }
    }
    [self cancelBtnOnClick];
    
}

- (NSInteger)getBytesLength:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    return [data length];
}

@end
