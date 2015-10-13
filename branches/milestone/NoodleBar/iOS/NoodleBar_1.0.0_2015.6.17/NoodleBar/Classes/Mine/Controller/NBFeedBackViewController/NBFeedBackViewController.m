//
//  NBFeedBackViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBFeedBackViewController.h"
#import "NBTextView.h"
#import "NBLoginHttpTool.h"
#import "NBLoginTool.h"
#import "NBCommon.h"
#import "NBAccountTool.h"
#import <MJExtension.h>
#import "NSDictionary+JSONCategories.h"
#define OPINION_AND_EMAIL_VIEW_WIDTH (SCREEN_WIDTH - 14)
#define OPINION_VIEW_HEIGHT 128
#define EMAIL_VIEW_HEIGHT 51
#define OPINION_TO_TOP_MARGIN 16
#define OPINION_TO_EMAIL_MARGIN 9
#define EMAIL_TO_CONFIRM_MARGIN 26
#define SUCCESS_TO_TOP 75 + 64
#define SUCCUESS_FONT [UIFont systemFontOfSize:22]
#define MAX_TEXT_LENGTH 120
#define MAX_EMAIL_LENGTH 20

@interface NBFeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>
/**
 *  scrollView
 */
@property (strong, nonatomic) UIScrollView *scrollView;
/**
 *  意见输入框
 */
@property (weak, nonatomic) NBTextView *opinionView;
/**
 *  邮箱输入框
 */
@property (weak, nonatomic) NBTextView *emailView;

@property(nonatomic, weak) UIButton *sendSuccessLabel;
@end

@implementation NBFeedBackViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(0xededed);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"意见反馈";
    [self setupSubViews];

}

#pragma mark - Setup
- (void)setupSubViews
{
    
    UIButton *sendSuccessLabel = [[UIButton alloc] initForAutoLayout];
    sendSuccessLabel.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8.f);
    sendSuccessLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 8.f, 0, 0);

    sendSuccessLabel.userInteractionEnabled = NO;
    [sendSuccessLabel setTitle:@"发送成功!" forState:UIControlStateNormal];
    [sendSuccessLabel setTitleColor:HEX_COLOR(0x009944) forState:UIControlStateNormal];
    sendSuccessLabel.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [sendSuccessLabel setImage:[UIImage imageNamed:@"mine_feedback_send_success"] forState:UIControlStateNormal];
    [self.view addSubview:sendSuccessLabel];
    sendSuccessLabel.hidden = YES;
    _sendSuccessLabel = sendSuccessLabel;
    
    [sendSuccessLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [sendSuccessLabel autoSetDimension:ALDimensionWidth toSize:152.f];
    [sendSuccessLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:75.0];
    
    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT));
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = _scrollView.bounds.size;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    _scrollView.bounces = NO;
    [_scrollView addGestureRecognizer:tap];
    
    [tap addTarget:self action:@selector(tapOnClick:)];
    
    
    // 意见输入框
    NBTextView *opinionView = [[NBTextView alloc] init];
    opinionView.backgroundColor = HEX_COLOR(0xf5f5f5);
    opinionView.textColor = HEX_COLOR(0x464646);
    opinionView.delegate = self;
    opinionView.placeHolder = @"请在这里填写您对\"名麦面吧\"的意见,我们将不断改进,感谢支持! :)          ";
    opinionView.placeHolderColor = HEX_COLOR(0xb5b5b5);
    opinionView.layer.borderWidth = 0.5;
    opinionView.layer.borderColor = HEX_COLOR(0xdcdcdc).CGColor;
    opinionView.layer.cornerRadius = 3;
    opinionView.returnKeyType = UIReturnKeyNext;
    CGFloat opinionW = OPINION_AND_EMAIL_VIEW_WIDTH;
    CGFloat opinionH = OPINION_VIEW_HEIGHT;
    CGFloat opinionX = (SCREEN_WIDTH - opinionW) * 0.5;
    CGFloat opinionY = OPINION_TO_TOP_MARGIN;
    opinionView.frame = CGRectMake(opinionX, opinionY, opinionW, opinionH);
    self.opinionView = opinionView;
    [_scrollView addSubview:opinionView];
    
    // 邮箱输入框
    NBTextView *emailView = [[NBTextView alloc] init];
    emailView.scrollEnabled = NO;
    emailView.backgroundColor= HEX_COLOR(0xf5f5f5);
    emailView.delegate = self;
    emailView.textColor = HEX_COLOR(0x464646);
    emailView.placeHolder = @"电子邮件(选填,以便我们回复您)";
    emailView.placeHolderColor = opinionView.placeHolderColor;
    emailView.returnKeyType = UIReturnKeyDone;
    emailView.layer.borderWidth = 0.5;
    emailView.layer.borderColor = HEX_COLOR(0xdcdcdc).CGColor;
    emailView.layer.cornerRadius = 3;
    emailView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
    CGFloat emailW = opinionW;
    CGFloat emailH = EMAIL_VIEW_HEIGHT;
    CGFloat emailX = opinionX;
    CGFloat emailY = CGRectGetMaxY(opinionView.frame) + OPINION_TO_EMAIL_MARGIN;
    emailView.frame = CGRectMake(emailX, emailY, emailW, emailH);
    self.emailView = emailView;
    [_scrollView addSubview:emailView];

    // 确认键
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"mine_feedback_send_btn_bg"] forState:UIControlStateNormal];
    [confirmButton setTitle:@"发送" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat confirmW = opinionW;
    CGFloat confirmH = 50;
    CGFloat confirmX = (SCREEN_WIDTH - confirmW) * 0.5;
    CGFloat confirmY = CGRectGetMaxY(emailView.frame) + EMAIL_TO_CONFIRM_MARGIN;
    confirmButton.frame = CGRectMake(confirmX, confirmY, confirmW, confirmH);
    [_scrollView addSubview:confirmButton];
}

/**
 *  文本改变时调用
 *
 *  @param textView 改变的文本视图
 */
- (void)textViewDidChange:(UITextView *)textView
{
    int maxLength = textView == _emailView?MAX_EMAIL_LENGTH:MAX_TEXT_LENGTH;
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textView.text = [toBeString substringToIndex:maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength) {
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        if (_opinionView == textView) {
            [textView resignFirstResponder];
            [_emailView becomeFirstResponder];
        }else
        {
            [_emailView resignFirstResponder];
        }
        
        return NO;
    }
    
    return YES;
}


/**
 *  空白区域点击手势,触发使键盘退下
 *
 *  @param tap 手势
 */
- (void)tapOnClick:(UITapGestureRecognizer *)tap
{
    [_scrollView endEditing:YES];
}


/**
 *  按钮点击事件
 *
 *  @param btn 被点击的按钮
 */
- (void)btnOnClick:(UIButton *)btn
{
    if (_opinionView.text == nil || _opinionView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容"];
        return;
    }
    
    if ([self stringContainsEmoji:_opinionView.text]) {
        [SVProgressHUD showErrorWithStatus:@"包含非法字符"];
        return;
    }
    [_emailView resignFirstResponder];
    [_opinionView resignFirstResponder];

    NBFeedbackJsonStringModel *feedbackJsonStringModel = [[NBFeedbackJsonStringModel alloc] init];
    feedbackJsonStringModel.token = [NBAccountTool userToken];
    feedbackJsonStringModel.content = _opinionView.text;
    feedbackJsonStringModel.email = _emailView.text;
    feedbackJsonStringModel.appver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    feedbackJsonStringModel.did = [NBLoginTool idfa];
    NSDate *nowDate = [NSDate date];
    feedbackJsonStringModel.t_time = [NSString stringWithFormat:@"%d000",(int)[nowDate timeIntervalSince1970]];
    NSDictionary *dict = [feedbackJsonStringModel keyValues];
    NSString *jsonStr = [dict JSONString];
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.feedBackJsonString = jsonStr;
    
    [SVProgressHUD show];
    [NBLoginHttpTool submitFeedbackWithParam:param success:^(NBResponseModel *result) {
        [SVProgressHUD dismiss];
        if (0 == result.code) {
        _scrollView.hidden = YES;
        _sendSuccessLabel.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}

- (void)dealloc
{
    NBLog(@"意见反馈挂了");
}

//利用正则表达式验证
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 是否包含emoji
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

@end
