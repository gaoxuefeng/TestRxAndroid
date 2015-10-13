//
//  CSFeedBackViewController.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSFeedBackViewController.h"
#import <Masonry.h>
#import "CSTextView.h"
#import "CSBackBarButtonItem.h"
#import "CSMyInfoHttpTool.h"
#import "SVProgressHUD.h"

#define MAX_LIMIT_NUMS 250

@interface CSFeedBackViewController ()<UITextViewDelegate>
{
    UIScrollView *_scrollView;
    CSTextView *_textView;
    UIButton *_sendButton;
}
@property(nonatomic,strong) UIButton* doneButton;
@end

@implementation CSFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setupSubViews];
    [self configNavigationBarRightItem];
}


#pragma mark - Setup
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    _textView = [[CSTextView alloc] init];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    _textView.placeHolder = @"请输入您宝贵的意见";
    _textView.placeHolderColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _textView.textColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = TRANSFER_SIZE(4.0);
    _textView.layer.masksToBounds = YES;
//    _textView.backgroundColor = HEX_COLOR(0x222126);
    _textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.04];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TRANSFER_SIZE(15.0));
        make.left.equalTo(self.view).offset(TRANSFER_SIZE(10.0));
        make.right.equalTo(self.view).offset(-TRANSFER_SIZE(10.0));
        make.height.mas_equalTo(TRANSFER_SIZE(125.0));
        make.bottom.equalTo(container);
    }];
    

}


#pragma mark - Config
- (void)configNavigationBarRightItem
{
    _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [_sendButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [_sendButton setTitleColor:[HEX_COLOR(0xffffff) colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [_sendButton addTarget:self action:@selector(sendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.size = CGSizeMake(TRANSFER_SIZE(40.0), TRANSFER_SIZE(40.0));
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sendButton];
    _sendButton.enabled = NO;
}

#pragma mark - Action


- (void)sendBtnOnClick
{
//    NSString *string = [self filterEmojiCharacter:_textView.text];
    if ([self stringContainsEmoji:_textView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请勿输入表情符号!"];
        return;
    }
    
    if ([PublicMethod isBlankString:_textView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容!"];
        return;
    }
    
    CSRequest *param = [[CSRequest alloc] init];
    param.message = _textView.text;
    [CSMyInfoHttpTool sendFeedBackWithParam:param success:^(CSBaseResponseModel *result) {
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.view endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }]; 
}


///** 过滤Emoji表情 */
//- (NSString *)filterEmojiCharacter:(NSString *)originalString
//{
//    __block NSString *string = nil;
//    [originalString enumerateSubstringsInRange:NSMakeRange(0, originalString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//        if (substring.length == 2) {
//            string = [originalString stringByReplacingOccurrencesOfString:substring withString:@""];
//        }
//    }];
//    return string;
//}

- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
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


#pragma mark - UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
//            self.lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    CSLog(@"%ld",textView.text.length);
     _sendButton.enabled = textView.text.length > 0;
    
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
//    self.lbNums.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

@end
