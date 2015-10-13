//
//  CSFavoriteUserInfoViewController.m
//  CloudSong
//
//  Created by sen on 15/6/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSFavoriteUserInfoViewController.h"
#import "CSTextView.h"
#import <Masonry.h>
#import "SVProgressHUD.h"
#import "CSLoginHttpTool.h"
@interface CSFavoriteUserInfoViewController ()
@property(nonatomic, assign) CSFavoriteUserInfoViewControllerType type;
@property(nonatomic, weak) CSTextView *textView;
@end

@implementation CSFavoriteUserInfoViewController


- (instancetype)initWithType:(CSFavoriteUserInfoViewControllerType)type
{
    _type = type;
    return [self init];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_type) {
        case CSFavoriteUserInfoViewControllerTypeSinger:
            self.title = @"最爱歌手";
            break;
        case CSFavoriteUserInfoViewControllerTypeSong:
            self.title = @"最喜欢的歌曲";
            break;
        case CSFavoriteUserInfoViewControllerTypeSignature:
            self.title = @"个性签名";
            break;
        default:
            break;
    }
    [self setupSubViews];
    [self configNavigationRightItem];
}

#pragma mark - Setup
- (void)setupSubViews
{
    CSTextView *textView = [[CSTextView alloc] init];
    textView.backgroundColor = HEX_COLOR(0x222126);
    NSString *placeHolder = nil;
    NSString *text;
    switch (_type) {
        case CSFavoriteUserInfoViewControllerTypeSinger:
            placeHolder = @"请输入您最爱歌手";
            text = [GlobalVar sharedSingleton].userInfo.loveSingers;
            break;
        case CSFavoriteUserInfoViewControllerTypeSong:
            placeHolder = @"请输入您最喜欢的歌曲";
            text = [GlobalVar sharedSingleton].userInfo.loveSongs;
            break;
        case CSFavoriteUserInfoViewControllerTypeSignature:
            placeHolder = @"请输入您的个性签名";
            text = [GlobalVar sharedSingleton].userInfo.signature;
            break;
        default:
            break;
    }
    textView.text = text;
    textView.placeHolder = placeHolder;
    textView.returnKeyType = UIReturnKeyNext;
    textView.placeHolderColor = HEX_COLOR(0x4c4c53);
    textView.font = [UIFont systemFontOfSize:TRANSFER_SIZE(15.0)];
    textView.textColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    _textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textView.superview);
        make.top.equalTo(textView.superview).offset(TRANSFER_SIZE(20.0));
        make.height.mas_equalTo(TRANSFER_SIZE(110.0));
    }];
}

#pragma mark Config
- (void)configNavigationRightItem
{
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HEX_COLOR(0x818289) forState:UIControlStateNormal];
    [confirmButton sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - Action
- (void)confirmBtnOnClick
{
    [SVProgressHUD show];
    
    CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
    CSRequest *param = [[CSRequest alloc] init];
    param.age = userInfo.age;
    param.nickName = userInfo.nickName;
    param.bloodType = userInfo.nickName;
    param.gender = userInfo.gender;
    param.constellation = userInfo.constellation;
    param.loveSingers = userInfo.loveSingers;
    param.loveSongs = userInfo.loveSongs;
    param.whatIsUp = userInfo.signature;
    switch (_type) {
        case CSFavoriteUserInfoViewControllerTypeSinger:
            param.loveSingers = _textView.text;
            break;
        case CSFavoriteUserInfoViewControllerTypeSong:
            param.loveSongs = _textView.text;
            break;
        case CSFavoriteUserInfoViewControllerTypeSignature:
            param.whatIsUp = _textView.text;
            break;
        default:
            break;
    }
    
    [SVProgressHUD show];
    [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];

}


@end
