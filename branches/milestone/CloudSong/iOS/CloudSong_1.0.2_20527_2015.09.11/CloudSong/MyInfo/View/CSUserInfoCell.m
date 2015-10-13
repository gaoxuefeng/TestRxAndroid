//
//  CSUserInfoCell.m
//  CloudSong
//
//  Created by sen on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSUserInfoCell.h"
#import "CSDefine.h"
#import <Masonry.h>

static const CGFloat UserIconRadius = 20.0;
@interface CSUserInfoCell () <UITextFieldDelegate>
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIImageView *arrawView;
@property(nonatomic, weak) UILabel *placeHolderLabel;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(copy, nonatomic) NSString *overString;

@end

@implementation CSUserInfoCell

- (UIImageView *)userIconView
{
    if (!_userIconView) {
        _userIconView = [[UIImageView alloc] init];
        _userIconView.contentMode = UIViewContentModeScaleAspectFill;
        _userIconView.layer.cornerRadius = TRANSFER_SIZE(UserIconRadius);
        _userIconView.layer.masksToBounds = YES;
        [self addSubview:_userIconView];
        [_userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(UserIconRadius) * 2, TRANSFER_SIZE(UserIconRadius) * 2));
            make.centerY.equalTo(_userIconView.superview);
            make.right.equalTo(_arrawView.mas_left).offset(-TRANSFER_SIZE(20.0));
        }];
    }
    return _userIconView;
}

- (instancetype)initWithTitle:(NSString *)title
{
    _title = title;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
        [self setupNotifications];
        self.backgroundColor = WhiteColor_Alpha_4;
    }
    return self;
}


#pragma mark - Setup
- (void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textColor = HEX_COLOR(0xffffff);
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    subTitleLabel.textColor = HEX_COLOR(0xb5b7bf);
    [self addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    
    UIImageView *arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self addSubview:arrawView];
    _arrawView = arrawView;
}

- (void)setupNotifications
{
    // 注册文本输入框字符改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Public Methods



- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    if (tag == CSUserInfoCellTypeIcon) {
//        _arrawView.hidden = YES;
    }else if (tag == CSUserInfoCellTypeNickName)
    {
        _subTitleLabel.hidden = YES;
        UITextField *nickNametextField = [[UITextField alloc] init];
        nickNametextField.delegate = self;
        nickNametextField.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
        nickNametextField.textColor = HEX_COLOR(0xb5b7bf);
        nickNametextField.text = _subTitleLabel.text;
        nickNametextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:nickNametextField];
        _nickNametextField = nickNametextField;
        [nickNametextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nickNametextField.superview);
            make.left.equalTo(nickNametextField.superview).offset(TRANSFER_SIZE(94.0));
            make.right.equalTo(nickNametextField.superview).offset(-AUTOLENGTH(50.0));
        }];
    }
}


- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
    _nickNametextField.text = subTitle;
    if (_placeHolderLabel) {
        _placeHolderLabel.hidden = subTitle.length > 0;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    if (placeHolder.length > 0) {
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
        placeHolderLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        placeHolderLabel.text = placeHolder;
        [self addSubview:placeHolderLabel];
        [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(placeHolderLabel.superview);
            make.left.equalTo(placeHolderLabel.superview).offset(TRANSFER_SIZE(95.0));
        }];
        _placeHolderLabel = placeHolderLabel;
    }
}



- (void)addTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGr];
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.superview);
            make.left.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(19.0));
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_subTitleLabel.superview);
            make.left.equalTo(_subTitleLabel.superview).offset(TRANSFER_SIZE(94.0));
            make.width.mas_lessThanOrEqualTo(AUTOLENGTH(190));
        }];
        
        [_arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_arrawView.superview);
            make.right.equalTo(_arrawView.superview).offset(-TRANSFER_SIZE(26.0));
        }];
        
        _didSetupConstraint = YES;
    }

    [super updateConstraints];
}

#pragma mark - Private Methods
- (void)textFieldEditChanged:(NSNotification *)notification
{
    
    NSString *toBeString = _nickNametextField.text;
    NSString *lang = [[_nickNametextField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_nickNametextField markedTextRange];
        _overString = [_nickNametextField textInRange:selectedRange];
        
        //获取高亮部分
        UITextPosition *position = [_nickNametextField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > default_max_length) {
                _nickNametextField.text = [toBeString substringToIndex:default_max_length];
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
             _nickNametextField.text = [toBeString substringToIndex:default_max_length];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(userInfoCellDidLostFocusWithString:)]) {
        [self.delegate userInfoCellDidLostFocusWithString:textField.text];
    }
}

- (NSInteger)getBytesLength:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    return [data length];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
