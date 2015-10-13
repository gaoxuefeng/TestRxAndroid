//
//  CSEditUserInfoViewController.m
//  CloudSong
//
//  Created by sen on 15/6/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSEditUserInfoViewController.h"
#import <Masonry.h>
#import "CSUserInfoCell.h"
#import "CSInputAlertView.h"
#import "CSActionSheet.h"
#import "CSFavoriteUserInfoViewController.h"
#import "CSLoginHttpTool.h"
#import "SVProgressHUD.h"

typedef enum {
    CSUserInfoCellTypeNickName,
    CSUserInfoCellTypeGender,
    CSUserInfoCellTypeAge,
    CSUserInfoCellTypeCon,
    CSUserInfoCellTypeBloodType,
    CSUserInfoCellTypeFavoriteSinger,
    CSUserInfoCellTypeFavoriteSong,
    CSUserInfoCellTypeSignature
}CSUserInfoCellType;

typedef enum
{
    CSPickerViewTypeAge,
    CSPickerViewTypeCon,
    CSPickerViewTypeBloodType
}CSPickerViewType;

@interface CSEditUserInfoViewController ()<CSActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, weak) CSUserInfoCell *nickNameCell;
@property(nonatomic, weak) CSUserInfoCell *genderCell;
@property(nonatomic, weak) CSUserInfoCell *ageCell;
@property(nonatomic, weak) CSUserInfoCell *conCell;
@property(nonatomic, weak) CSUserInfoCell *bloodTypeCell;
@property(nonatomic, weak) CSUserInfoCell *favoriteSingerCell;
@property(nonatomic, weak) CSUserInfoCell *favoriteSongCell;
@property(nonatomic, weak) CSUserInfoCell *signatureCell;

@property(nonatomic, weak) CSActionSheet *genderSheet;


@property(nonatomic, assign) CSEditUserInfoViewControllerType type;

@property(nonatomic, weak) UIPickerView *agePickerView;
@property(nonatomic, weak) UIPickerView *conPickerView;
@property(nonatomic, weak) UIPickerView *bloodTypePickerView;
@property(nonatomic, weak) UIPickerView *currentPickerView;
@property(nonatomic, weak) UIView *buttonContainer;

@property(nonatomic, strong)  NSMutableArray *ages;
@property(nonatomic, strong) NSArray *cons;
@property(nonatomic, strong) NSArray *bloodTypes;

@property(nonatomic, weak) MASConstraint *buttonContainerBottomY;
@property(nonatomic, weak) UIButton *cover;

@end

@implementation CSEditUserInfoViewController


- (NSArray *)ages
{
    if (!_ages) {
        NSMutableArray *agesM = [NSMutableArray arrayWithCapacity:99];
        for (int i = 0; i < 99; i++) {
            [agesM addObject:[NSString stringWithFormat:@"%d岁",i+1]];
        }
        _ages = agesM;
    }
    return _ages;
}
- (NSArray *)cons{
    if (!_cons) {
        _cons = @[@"白羊座",
                  @"金牛座",
                  @"双子座",
                  @"巨蟹座",
                  @"狮子座",
                  @"处女座",
                  @"天秤座",
                  @"天蝎座",
                  @"射手座",
                  @"摩羯座",
                  @"水瓶座",
                  @"双鱼座"];
    }
    return _cons;
}
- (NSArray *)bloodTypes
{
    if (!_bloodTypes) {
        _bloodTypes = @[@"A",
                        @"B",
                        @"AB",
                        @"O"];
    }
    return _bloodTypes;
}



- (instancetype)initWithType:(CSEditUserInfoViewControllerType)type
{
    _type = type;
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _type?@"信息确认":@"信息编辑";
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        [self configRightBarButtonItem];
    }
    [self setupSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}


#pragma mark - Setup
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview);
        make.width.equalTo(container.superview);
    }];
    
    
    CGFloat cellHeight = TRANSFER_SIZE(55.0);
    CGFloat bottomLineHeight = 1 / [UIScreen mainScreen].scale;
    CSUserInfoCell *nickNameCell = nil;
    UIView *nickNameBottomLine = nil;
    if (_type == CSEditUserInfoViewControllerTypeEdit) {
        // 昵称
        nickNameCell = [[CSUserInfoCell alloc] initWithTitle:@"昵称"];
        nickNameCell.tag = CSUserInfoCellTypeNickName;
        [nickNameCell addTarget:self action:@selector(btnOnClick:)];
        [container addSubview:nickNameCell];
        [nickNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nickNameCell.superview).offset(TRANSFER_SIZE(19.0));
            make.left.right.equalTo(nickNameCell.superview);
            make.height.mas_equalTo(cellHeight);
        }];
        _nickNameCell = nickNameCell;
        
        nickNameBottomLine = [[UIView alloc] init];
        nickNameBottomLine.backgroundColor = HEX_COLOR(0x17171a);
        [container addSubview:nickNameBottomLine];
        [nickNameBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nickNameCell.mas_bottom);
            make.left.right.equalTo(nickNameBottomLine.superview);
            make.height.mas_equalTo(bottomLineHeight);
        }];
    }
    
    // 性别
    CSUserInfoCell *genderCell = [[CSUserInfoCell alloc] initWithTitle:@"性别"];
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        genderCell.placeHolder = @"你的性别";
    }
    genderCell.tag = CSUserInfoCellTypeGender;
    [genderCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:genderCell];
    [genderCell mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_type == CSEditUserInfoViewControllerTypeConfirm) {
            make.top.equalTo(genderCell.superview).offset(TRANSFER_SIZE(19.0));
        }else
        {
            make.top.equalTo(nickNameBottomLine.mas_bottom);
        }
        
        make.left.right.equalTo(genderCell.superview);
        make.height.mas_equalTo(cellHeight);
    }];
    _genderCell = genderCell;
    UIView *genderCellBottomLine = [[UIView alloc] init];
    genderCellBottomLine.backgroundColor = HEX_COLOR(0x17171a);
    [container addSubview:genderCellBottomLine];
    [genderCellBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genderCell.mas_bottom);
        make.left.right.equalTo(genderCellBottomLine.superview);
        make.height.mas_equalTo(bottomLineHeight);
    }];
    // 年龄
    CSUserInfoCell *ageCell = [[CSUserInfoCell alloc] initWithTitle:@"年龄"];
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        ageCell.placeHolder = @"你的年龄";
    }
    ageCell.tag = CSUserInfoCellTypeAge;
    [ageCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:ageCell];
    [ageCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genderCellBottomLine.mas_bottom);
        make.left.right.equalTo(ageCell.superview);
        make.height.mas_equalTo(cellHeight);
    }];
    _ageCell = ageCell;
    // 星座
    CSUserInfoCell *conCell = [[CSUserInfoCell alloc] initWithTitle:@"星座"];
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        conCell.placeHolder = @"你的星座";
    }
    conCell.tag = CSUserInfoCellTypeCon;
    [conCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:conCell];
    [conCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ageCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.right.equalTo(conCell.superview);
        make.height.mas_equalTo(cellHeight);
    }];
    _conCell = conCell;
    UIView *conCellBottomLine = [[UIView alloc] init];
    conCellBottomLine.backgroundColor = HEX_COLOR(0x17171a);
    [container addSubview:conCellBottomLine];
    [conCellBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(conCell.mas_bottom);
        make.left.right.equalTo(conCellBottomLine.superview);
        make.height.mas_equalTo(bottomLineHeight);
    }];
    // 血型
    CSUserInfoCell *bloodTypeCell = [[CSUserInfoCell alloc] initWithTitle:@"血型"];
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        bloodTypeCell.placeHolder = @"你的血型";
    }
    bloodTypeCell.tag = CSUserInfoCellTypeBloodType;
    [bloodTypeCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:bloodTypeCell];
    [bloodTypeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(conCellBottomLine.mas_bottom);
        make.left.right.equalTo(bloodTypeCell.superview);
        make.height.mas_equalTo(cellHeight);
    }];
    _bloodTypeCell = bloodTypeCell;


    // 最爱歌手
    CSUserInfoCell *favoriteSingerCell = [[CSUserInfoCell alloc] initWithTitle:@"最爱歌手"];
    favoriteSingerCell.subTitleLabel.hidden = YES;
    favoriteSingerCell.tag = CSUserInfoCellTypeFavoriteSinger;
    [favoriteSingerCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:favoriteSingerCell];
    [favoriteSingerCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bloodTypeCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.right.equalTo(favoriteSingerCell.superview);
        make.height.mas_equalTo(cellHeight);
    }];
    _favoriteSingerCell = favoriteSingerCell;
    UIView *favoriteSingerCellBottomLine = [[UIView alloc] init];
    favoriteSingerCellBottomLine.backgroundColor = HEX_COLOR(0x17171a);
    [container addSubview:favoriteSingerCellBottomLine];
    [favoriteSingerCellBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favoriteSingerCell.mas_bottom);
        make.left.right.equalTo(favoriteSingerCellBottomLine.superview);
        make.height.mas_equalTo(bottomLineHeight);
    }];
    
    // 最喜欢的歌曲
    CSUserInfoCell *favoriteSongCell = [[CSUserInfoCell alloc] initWithTitle:@"最喜欢的歌曲"];
    favoriteSongCell.subTitleLabel.hidden = YES;
    favoriteSongCell.tag = CSUserInfoCellTypeFavoriteSong;
    [favoriteSongCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:favoriteSongCell];
    [favoriteSongCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favoriteSingerCellBottomLine.mas_bottom);
        make.left.right.equalTo(favoriteSongCell.superview);
        make.height.mas_equalTo(cellHeight);
    }];
    _favoriteSongCell = favoriteSongCell;
    // 个性签名
    CSUserInfoCell *signatureCell = [[CSUserInfoCell alloc] initWithTitle:@"个性签名"];
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        signatureCell.placeHolder = @"一句话介绍下自己";
    }
    signatureCell.tag = CSUserInfoCellTypeSignature;
    [signatureCell addTarget:self action:@selector(btnOnClick:)];
    [container addSubview:signatureCell];
    [signatureCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(favoriteSongCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
        make.left.right.equalTo(signatureCell.superview);
        make.height.mas_equalTo(cellHeight);
        make.bottom.equalTo(container.mas_bottom).offset(-TRANSFER_SIZE(10.0));
    }];
    _signatureCell = signatureCell;
}

- (void)createPickerViewWithType:(CSPickerViewType)type
{
    // 确认按钮区域
    UIView *buttonContainer = [[UIView alloc] init];
    _buttonContainer = buttonContainer;
    buttonContainer.backgroundColor = HEX_COLOR(0x242424);
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:HEX_COLOR(0x898a91) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(18.0)];
    [cancelButton addTarget:self action:@selector(pickerViewCancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:cancelButton];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HEX_COLOR(0x898a91) forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(18.0)];
    [confirmButton addTarget:self action:@selector(pickerViewConfirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:confirmButton];
    
    
    // 选择器
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.backgroundColor = HEX_COLOR(0x2a2a2a);
    switch (type) {
        case CSPickerViewTypeAge:
            _agePickerView = pickView;
            
            break;
        case CSPickerViewTypeCon:
            _conPickerView = pickView;
            break;
        case CSPickerViewTypeBloodType:
            _bloodTypePickerView = pickView;
            break;
        default:
            break;
    }
    _currentPickerView = pickView;
    pickView.delegate = self;
    pickView.dataSource = self;
    
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    _cover = cover;
    [cover addTarget:self action:@selector(pickerViewCancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:cover];
    [window addSubview:pickView];
    [window addSubview:buttonContainer];
    
    
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cover.superview);
    }];
    
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pickView.superview);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelButton.superview);
        make.left.equalTo(cancelButton.superview.mas_left).offset(TRANSFER_SIZE(15.0));
    }];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmButton.superview);
        make.right.equalTo(confirmButton.superview.mas_right).offset(-TRANSFER_SIZE(15.0));
    }];
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        _buttonContainerBottomY = make.top.equalTo(buttonContainer.superview.mas_bottom);
        make.bottom.equalTo(pickView.mas_top);
        make.left.right.equalTo(buttonContainer.superview);
        make.height.mas_equalTo(TRANSFER_SIZE(44.0));
    }];
    
    [window layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cover.alpha = 0.5;
        _buttonContainerBottomY.offset = -(buttonContainer.height + pickView.height);
        [window layoutIfNeeded];
    } completion:nil];
    

}

#pragma mark - Config
- (void)configRightBarButtonItem
{
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [startButton addTarget:self action:@selector(startBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(14.0)];
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton setTitleColor:HEX_COLOR(0xcd418f) forState:UIControlStateNormal];
    [startButton sizeToFit];
    
    UIBarButtonItem *rightButtonBtn = [[UIBarButtonItem alloc] initWithCustomView:startButton];
    self.navigationItem.rightBarButtonItem = rightButtonBtn;
}
#pragma mark - CSActionSheet
/**********************性别修改***********************/
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (actionSheet == _genderSheet) { // 性别
        NSString *gender = nil;
        if (buttonIndex == 1) { // 男
            gender = @"男";
        }else // 女
        {
            gender = @"女";
        }
        CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
        CSRequest *param = [[CSRequest alloc] init];
        param.age = userInfo.age;
        param.nickName = userInfo.nickName;
        param.bloodType = userInfo.nickName;
        param.gender = gender;
        param.constellation = userInfo.constellation;
        param.loveSingers = userInfo.loveSingers;
        param.loveSongs = userInfo.loveSongs;
        param.whatIsUp = userInfo.signature;
        
        [SVProgressHUD show];
        [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
            [SVProgressHUD dismiss];
            if (result.code == ResponseStateSuccess) {
                self.genderCell.subTitle = gender;
                [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            CSLog(@"%@",error);
        }];
    }
}

#pragma mark - UIPickerViewDataSource
/**********************星座 血型 年龄修改***********************/
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    if (pickerView == _agePickerView) {
        string = self.ages[row];
        
    }else if (pickerView == _conPickerView)
    {
        string = self.cons[row];
    }else if (pickerView == _bloodTypePickerView)
    {
        string = [NSString stringWithFormat:@"%@型",self.bloodTypes[row]];
    }
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TRANSFER_SIZE(17.0)],NSForegroundColorAttributeName:HEX_COLOR(0xb4b5bf)}];;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return TRANSFER_SIZE(30.0);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _agePickerView) {
        return self.ages.count;
    }else if (pickerView == _conPickerView)
    {
        return self.cons.count;
    }else if (pickerView == _bloodTypePickerView)
    {
        return self.bloodTypes.count;
    }
    return 0;
}



#pragma mark - UIPickerViewDelegate

- (void)loadData
{
    CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
    _nickNameCell.subTitle = userInfo.nickName;
    _genderCell.subTitle = userInfo.gender;
    _ageCell.subTitle = [userInfo.age stringValue];
    _conCell.subTitle = userInfo.constellation;
    _bloodTypeCell.subTitle = userInfo.bloodType.length>0?[NSString stringWithFormat:@"%@型",userInfo.bloodType]:nil;
    _favoriteSingerCell.subTitle = userInfo.loveSingers;
    _favoriteSongCell.subTitle = userInfo.loveSongs;
    _signatureCell.subTitle = userInfo.signature;
}

#pragma mark - Action
- (void)btnOnClick:(UITapGestureRecognizer *)tapGr
{
    __weak typeof(self) weakSelf = self;
    switch (tapGr.view.tag) {
            /*********************** 姓名修改 *************************/
        case CSUserInfoCellTypeNickName:
        {
            CSInputAlertView *inputAlertView = [[CSInputAlertView alloc] initWithTitle:@"修改昵称" content:_nickNameCell.subTitle delegate:nil cancelButtonTitle:@"取消" confirmTitle:@"确认"];
            inputAlertView.maxLength = 20;
            inputAlertView.didInputBlock = ^(NSString *text){
                CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
                CSRequest *param = [[CSRequest alloc] init];
                param.age = userInfo.age;
                param.nickName = text;
                param.bloodType = userInfo.bloodType;
                param.constellation = userInfo.bloodType;
                param.gender = userInfo.gender;
                param.loveSingers = userInfo.loveSingers;
                param.loveSongs = userInfo.loveSongs;
                param.whatIsUp = userInfo.signature;
                [SVProgressHUD show];
                [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
                    [SVProgressHUD dismiss];
                    if (result.code == ResponseStateSuccess) {
                        weakSelf.nickNameCell.subTitle = text;
                        [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:result.message];
                    }
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    CSLog(@"%@",error);
                }];
            };
            [inputAlertView show];
            break;
        }
        case CSUserInfoCellTypeGender:
        {
            CSActionSheet *genderSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:@"选择性别" cancelButtonTitle:@"取消" otherButtonTitles:@[@"男",@"女"]];
            [genderSheet show];
            _genderSheet = genderSheet;
            break;
        }
        case CSUserInfoCellTypeAge:
        {
            [self createPickerViewWithType:CSPickerViewTypeAge];
            if ([GlobalVar sharedSingleton].userInfo.age) {
                NSInteger index = [[GlobalVar sharedSingleton].userInfo.age integerValue] - 1;
                [_currentPickerView selectRow:index inComponent:0 animated:NO];
            }
            break;
        }
        case CSUserInfoCellTypeCon:
        {
            [self createPickerViewWithType:CSPickerViewTypeCon];
            NSInteger index = [self.cons indexOfObject:[GlobalVar sharedSingleton].userInfo.constellation];
            if (index == NSNotFound) {
                [_currentPickerView selectRow:0 inComponent:0 animated:NO];
            }else
            {
                [_currentPickerView selectRow:index inComponent:0 animated:NO];
            }
            
            break;
        }
        case CSUserInfoCellTypeBloodType:
        {
            [self createPickerViewWithType:CSPickerViewTypeBloodType];
            NSInteger index = [self.bloodTypes indexOfObject:[GlobalVar sharedSingleton].userInfo.bloodType];
            if (index == NSNotFound) {
                [_currentPickerView selectRow:0 inComponent:0 animated:NO];
            }else
            {
                [_currentPickerView selectRow:index inComponent:0 animated:NO];
            }
            break;
        }
        case CSUserInfoCellTypeFavoriteSinger:
        {
            CSFavoriteUserInfoViewController *favoriteSingerVc = [[CSFavoriteUserInfoViewController alloc] initWithType:CSFavoriteUserInfoViewControllerTypeSinger];
            [self.navigationController pushViewController:favoriteSingerVc animated:YES];
            break;
        }
        case CSUserInfoCellTypeFavoriteSong:
        {
            CSFavoriteUserInfoViewController *favoriteSongVc = [[CSFavoriteUserInfoViewController alloc] initWithType:CSFavoriteUserInfoViewControllerTypeSong];
            [self.navigationController pushViewController:favoriteSongVc animated:YES];
            break;
        }
        case CSUserInfoCellTypeSignature:
        {
            CSFavoriteUserInfoViewController *signatureVc = [[CSFavoriteUserInfoViewController alloc] initWithType:CSFavoriteUserInfoViewControllerTypeSignature];
            [self.navigationController pushViewController:signatureVc animated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)pickerViewCancelBtnOnClick
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cover.alpha = 0.0;
        _buttonContainerBottomY.offset = 0.0;
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
        [_currentPickerView removeFromSuperview];
        [_buttonContainer removeFromSuperview];
    }];
}

- (void)pickerViewConfirmBtnOnClick
{
    [self pickerViewCancelBtnOnClick];
    if (_currentPickerView == _agePickerView) {
        NSNumber *age = [NSNumber numberWithInteger:[_agePickerView selectedRowInComponent:0] + 1];
        CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
        CSRequest *param = [[CSRequest alloc] init];
        param.age = age;
        param.nickName = userInfo.nickName;
        param.bloodType = userInfo.bloodType;
        param.constellation = userInfo.bloodType;
        param.gender = userInfo.gender;
        param.loveSingers = userInfo.loveSingers;
        param.loveSongs = userInfo.loveSongs;
        param.whatIsUp = userInfo.signature;
        
        [SVProgressHUD show];
        [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
            [SVProgressHUD dismiss];
            if (result.code == ResponseStateSuccess) {
                self.ageCell.subTitle = [age stringValue];
                [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            CSLog(@"%@",error);
        }];
    }else if(_currentPickerView == _conPickerView)
    {
        NSInteger index = [_conPickerView selectedRowInComponent:0];
        NSString *con = self.cons[index];
        CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
        CSRequest *param = [[CSRequest alloc] init];
        param.age = userInfo.age;
        param.nickName = userInfo.nickName;
        param.bloodType = userInfo.bloodType;
        param.constellation = con;
        param.gender = userInfo.gender;
        param.loveSingers = userInfo.loveSingers;
        param.loveSongs = userInfo.loveSongs;
        param.whatIsUp = userInfo.signature;
        
        [SVProgressHUD show];
        [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
            [SVProgressHUD dismiss];
            if (result.code == ResponseStateSuccess) {
                self.conCell.subTitle = con;
                [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            CSLog(@"%@",error);
        }];
        
    }else if (_currentPickerView == _bloodTypePickerView)
    {
        NSInteger index = [_bloodTypePickerView selectedRowInComponent:0];
        NSString *bloodType = self.bloodTypes[index];
        CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
        CSRequest *param = [[CSRequest alloc] init];
        param.age = userInfo.age;
        param.nickName = userInfo.nickName;
        param.bloodType = bloodType;
        param.gender = userInfo.gender;
        param.constellation = userInfo.constellation;
        param.loveSingers = userInfo.loveSingers;
        param.loveSongs = userInfo.loveSongs;
        param.whatIsUp = userInfo.signature;
        
        [SVProgressHUD show];
        [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
            [SVProgressHUD dismiss];
            if (result.code == ResponseStateSuccess) {
                self.bloodTypeCell.subTitle = bloodType.length>0?[NSString stringWithFormat:@"%@型",bloodType]:nil;
                [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            CSLog(@"%@",error);
        }];
    }
}

- (void)startBtnOnClick:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    if (self.startBlock) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        weakSelf.startBlock();
    }
}



@end
