//
//  CSSendTextViewController.m
//  CloudSong
//
//  Created by sen on 15/6/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSSendTextViewController.h"
#import <Masonry.h>
#import "CSTextView.h"
@interface CSSendTextViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, weak) CSTextView *textView;
@property(nonatomic, weak) UIView *middleView;
@property(nonatomic, weak) UITableView *promptTableView;
@property(nonatomic, weak) UILabel *wordCountLabel;
@property(nonatomic, strong) NSArray *promptSentences;
@end

@implementation CSSendTextViewController
#pragma mark - Lazy Load
- (NSArray *)promptSentences
{
    if (!_promptSentences) {
        _promptSentences = @[
                             @"大哥,你唱得好牛逼啊!",
                             @"歌坛小王子称号,非你莫属!",
                             @"杰伦二代,唱得太逼真了!",
                             @"张惠妹转世!",
                             @"唱得太好旁听了,我竟无言以对!",
                             @"大哥,你唱得好牛逼啊!",
                             @"张惠妹转世!",
                             @"唱得太好旁听了,我竟无言以对!",
                             @"大哥,你唱得好牛逼啊!",
                             @"歌坛小王子称号,非你莫属!",
                             ];
    }
    return _promptSentences;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发文字";
    [self setupSubViews];
    [self configNavigationRightItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


#pragma mark - Setup
- (void)setupSubViews
{
    [self setupTextView];
    [self setupMiddleView];
    [self setupPromptTableView];
}

- (void)setupTextView
{
    
    CSTextView *textView = [[CSTextView alloc] init];
    textView.delegate = self;
    textView.backgroundColor = HEX_COLOR(0x1d1c21);
    textView.placeHolder = @"说点什么吧,点击发送至大屏幕~";
    textView.placeHolderColor = HEX_COLOR(0xb5b7bf);
    textView.textColor = HEX_COLOR(0xb5b7bf);
    textView.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(textView.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(200.0));
    }];
    _textView = textView;
}

- (void)setupMiddleView
{
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = HEX_COLOR(0x151417);
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(middleView.superview);
        make.top.equalTo(_textView.mas_bottom);
        make.height.mas_equalTo(TRANSFER_SIZE(35.0));
    }];
    _middleView = middleView;
    
    UILabel *wordCountLabel = [[UILabel alloc] init];
    wordCountLabel.textColor = HEX_COLOR(0x68696e);
    wordCountLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    wordCountLabel.text = [NSString stringWithFormat:@"%ld/16",_textView.text.length];
    [middleView addSubview:wordCountLabel];
    [wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wordCountLabel.superview);
        make.right.equalTo(wordCountLabel.superview).offset(-TRANSFER_SIZE(17.0));
    }];
    _wordCountLabel = wordCountLabel;

}

- (void)setupPromptTableView
{
    UITableView *promptTableView = [[UITableView alloc] init];
    promptTableView.delegate = self;
    promptTableView.dataSource = self;
    promptTableView.rowHeight = TRANSFER_SIZE(55.0);
    promptTableView.separatorColor = HEX_COLOR(0x141417);
    promptTableView.separatorInset = UIEdgeInsetsMake(0, TRANSFER_SIZE(20.0), 0, 0);
    promptTableView.backgroundColor = HEX_COLOR(0x1d1c21);
    [self.view addSubview:promptTableView];
    [promptTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(promptTableView.superview);
        make.top.equalTo(_middleView.mas_bottom);
    }];
}

#pragma mark Config
- (void)configNavigationRightItem
{
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(sendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [confirmButton setTitle:@"发送" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HEX_COLOR(0x818289) forState:UIControlStateNormal];
    [confirmButton sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - Action Methods
- (void)backBtnOnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)sendBtnOnClick
{
    // TODO
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _wordCountLabel.text = [NSString stringWithFormat:@"%ld/16",_textView.text.length];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.promptSentences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"promptCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = HEX_COLOR(0xb5b7bf);
        cell.textLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
        cell.textLabel.x = TRANSFER_SIZE(20.0);
        cell.backgroundColor = HEX_COLOR(0x1d1c21);
        
    }
    cell.textLabel.text = self.promptSentences[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _textView.text = self.promptSentences[indexPath.row];
    _wordCountLabel.text = [NSString stringWithFormat:@"%ld/16",_textView.text.length];
}




@end
