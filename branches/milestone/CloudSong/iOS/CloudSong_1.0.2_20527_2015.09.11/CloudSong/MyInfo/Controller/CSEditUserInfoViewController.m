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
#import "CSEditUserIconViewController.h"
#import <UIImageView+WebCache.h>




typedef enum
{
    CSPickerViewTypeAge,
    CSPickerViewTypeCon,
    CSPickerViewTypeBloodType
}CSPickerViewType;

@interface CSEditUserInfoViewController ()<CSActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,CSUserInfoCellDelegate>
{
    UIScrollView *_scrollView;
}
@property(weak, nonatomic) CSUserInfoCell *iconCell;
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

@property(strong, nonatomic) CSUserInfoModel *tmpUserInfo;

@property(weak, nonatomic) UIButton *confirmButton;

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
    
    _tmpUserInfo = [GlobalObj.userInfo copy];
    self.title = _type?@"信息确认":@"信息编辑";
    [self configRightBarButtonItem];
    [self setupSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_type == CSEditUserInfoViewControllerTypeEdit) {
        [self loadData];
    }
    [super viewWillAppear:animated];
}


#pragma mark - Setup
- (void)setupSubViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
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
    CSUserInfoCell *iconCell = nil;
    CSUserInfoCell *nickNameCell = nil;
    UIView *nickNameBottomLine = nil;
    if (_type == CSEditUserInfoViewControllerTypeEdit) {
        
        // 用户头像
        iconCell = [[CSUserInfoCell alloc] initWithTitle:@"头像"];
        iconCell.tag = CSUserInfoCellTypeIcon;
        [iconCell addTarget:self action:@selector(btnOnClick:)];
        [container addSubview:iconCell];
        [iconCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconCell.superview).offset(TRANSFER_SIZE(19.0));
            make.left.right.equalTo(iconCell.superview);
            make.height.mas_equalTo(cellHeight);
        }];
        _iconCell = iconCell;
        
        // 昵称
        nickNameCell = [[CSUserInfoCell alloc] initWithTitle:@"昵称"];
        nickNameCell.delegate = self;
        nickNameCell.tag = CSUserInfoCellTypeNickName;
        [nickNameCell addTarget:self action:@selector(btnOnClick:)];
        [container addSubview:nickNameCell];
        [nickNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
            make.left.right.equalTo(nickNameCell.superview);
            make.height.mas_equalTo(cellHeight);
        }];
        _nickNameCell = nickNameCell;
        
        nickNameBottomLine = [[UIView alloc] init];
        nickNameBottomLine.backgroundColor = HEX_COLOR(0x3f2757);
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
    genderCellBottomLine.backgroundColor = HEX_COLOR(0x3f2757);
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
    conCellBottomLine.backgroundColor = HEX_COLOR(0x3f2757);
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
        make.bottom.equalTo(container.mas_bottom).offset(-TRANSFER_SIZE(10.0));
    }];
    _bloodTypeCell = bloodTypeCell;


//    // 最爱歌手
//    CSUserInfoCell *favoriteSingerCell = [[CSUserInfoCell alloc] initWithTitle:@"最爱歌手"];
//    favoriteSingerCell.subTitleLabel.hidden = YES;
//    favoriteSingerCell.tag = CSUserInfoCellTypeFavoriteSinger;
//    [favoriteSingerCell addTarget:self action:@selector(btnOnClick:)];
//    [container addSubview:favoriteSingerCell];
//    [favoriteSingerCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bloodTypeCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
//        make.left.right.equalTo(favoriteSingerCell.superview);
//        make.height.mas_equalTo(cellHeight);
//    }];
//    _favoriteSingerCell = favoriteSingerCell;
//    UIView *favoriteSingerCellBottomLine = [[UIView alloc] init];
//    favoriteSingerCellBottomLine.backgroundColor = HEX_COLOR(0x3f2757);
//    [container addSubview:favoriteSingerCellBottomLine];
//    [favoriteSingerCellBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(favoriteSingerCell.mas_bottom);
//        make.left.right.equalTo(favoriteSingerCellBottomLine.superview);
//        make.height.mas_equalTo(bottomLineHeight);
//    }];
//    
//    // 最喜欢的歌曲
//    CSUserInfoCell *favoriteSongCell = [[CSUserInfoCell alloc] initWithTitle:@"最喜欢的歌曲"];
//    favoriteSongCell.subTitleLabel.hidden = YES;
//    favoriteSongCell.tag = CSUserInfoCellTypeFavoriteSong;
//    [favoriteSongCell addTarget:self action:@selector(btnOnClick:)];
//    [container addSubview:favoriteSongCell];
//    [favoriteSongCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(favoriteSingerCellBottomLine.mas_bottom);
//        make.left.right.equalTo(favoriteSongCell.superview);
//        make.height.mas_equalTo(cellHeight);
//    }];
//    _favoriteSongCell = favoriteSongCell;
//    // 个性签名
//    CSUserInfoCell *signatureCell = [[CSUserInfoCell alloc] initWithTitle:@"个性签名"];
//    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
//        signatureCell.placeHolder = @"一句话介绍下自己";
//    }
//    signatureCell.tag = CSUserInfoCellTypeSignature;
//    [signatureCell addTarget:self action:@selector(btnOnClick:)];
//    [container addSubview:signatureCell];
//    [signatureCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(favoriteSongCell.mas_bottom).offset(TRANSFER_SIZE(10.0));
//        make.left.right.equalTo(signatureCell.superview);
//        make.height.mas_equalTo(cellHeight);
//        make.bottom.equalTo(container.mas_bottom).offset(-TRANSFER_SIZE(10.0));
//    }];
//    _signatureCell = signatureCell;
}

- (void)configNavigationBar
{
    
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        self.navigationItem.hidesBackButton = YES;
        return;
    }
    [super configNavigationBar];
}

- (void)createPickerViewWithType:(CSPickerViewType)type
{
    // 确认按钮区域
    UIView *buttonContainer = [[UIView alloc] init];
    _buttonContainer = buttonContainer;
    buttonContainer.backgroundColor = HEX_COLOR(0x381e59);
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
    pickView.backgroundColor = HEX_COLOR(0x412469);
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
    if (_type == CSEditUserInfoViewControllerTypeConfirm) {
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [startButton addTarget:self action:@selector(startBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        startButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANSFER_SIZE(14.0)];
        [startButton setTitle:@"开始" forState:UIControlStateNormal];
        [startButton setTitleColor:HEX_COLOR(0xee29a7) forState:UIControlStateNormal];
        [startButton sizeToFit];
        
        UIBarButtonItem *rightButtonBtn = [[UIBarButtonItem alloc] initWithCustomView:startButton];
        self.navigationItem.rightBarButtonItem = rightButtonBtn;
    }else
    {
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmButton = confirmButton;
        [confirmButton addTarget:self action:@selector(updateUserInfo) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14.0)];
        [confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        [confirmButton setTitle:@"保存" forState:UIControlStateDisabled];
        [confirmButton setTitleColor:HEX_COLOR(0xee29a7) forState:UIControlStateNormal];
        [confirmButton setTitleColor:[HEX_COLOR(0xffffff) colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
        
        [confirmButton sizeToFit];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
        
        self.navigationItem.rightBarButtonItem = barButtonItem;
        confirmButton.enabled = NO;
    }
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
        _tmpUserInfo.gender = gender;
        _genderCell.subTitle = gender;
        
        CSLog(@"%@",[GlobalObj.userInfo isEqualUserInfo:_tmpUserInfo]?@"YES":@"NO");
        _confirmButton.enabled = ![GlobalObj.userInfo isEqualUserInfo:_tmpUserInfo];
        
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
//    CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
    _nickNameCell.subTitle = _tmpUserInfo.nickName;
    _genderCell.subTitle = _tmpUserInfo.gender;
    _ageCell.subTitle = [_tmpUserInfo.age stringValue];
    _conCell.subTitle = _tmpUserInfo.constellation;
    _bloodTypeCell.subTitle = _tmpUserInfo.bloodType.length>0?[NSString stringWithFormat:@"%@型",_tmpUserInfo.bloodType]:nil;
    _favoriteSingerCell.subTitle = _tmpUserInfo.loveSingers;
    _favoriteSongCell.subTitle = _tmpUserInfo.loveSongs;
    _signatureCell.subTitle = _tmpUserInfo.signature;
    if (GlobalObj.userInfo.headUrl.length > 0) {
        [_iconCell.userIconView sd_setImageWithURL:[NSURL URLWithString:GlobalObj.userInfo.headUrl] placeholderImage:GlobalObj.userIcon];

    }else
    {
        _iconCell.userIconView.image = [UIImage imageNamed:@"mine_default_user_icon"];
    }
}

#pragma mark - Action
- (void)btnOnClick:(UITapGestureRecognizer *)tapGr
{
//    __weak typeof(self) weakSelf = self;
    switch (tapGr.view.tag) {
            /*********************** 头像修改 *************************/
        case CSUserInfoCellTypeIcon:
        {
            [self.view endEditing:YES];
            CSEditUserIconViewController *editUserIconVc = [[CSEditUserIconViewController alloc] init];
            [editUserIconVc setNavigationBarBGHidden];
//            [editUserIconVc notShowNoNetworking];
            [self.navigationController pushViewController:editUserIconVc animated:YES];
            break;
        }
            /*********************** 姓名修改 *************************/
        case CSUserInfoCellTypeNickName:
        {
//            CSInputAlertView *inputAlertView = [[CSInputAlertView alloc] initWithTitle:@"修改昵称" content:_nickNameCell.subTitle delegate:nil cancelButtonTitle:@"取消" confirmTitle:@"确认"];
//            inputAlertView.maxLength = 20;
//            inputAlertView.didInputBlock = ^(NSString *text){
//                CSUserInfoModel *userInfo = [GlobalVar sharedSingleton].userInfo;
//                CSRequest *param = [[CSRequest alloc] init];
//                param.age = userInfo.age;
//                param.nickName = text;
//                param.bloodType = userInfo.bloodType;
//                param.constellation = userInfo.bloodType;
//                param.gender = userInfo.gender;
//                param.loveSingers = userInfo.loveSingers;
//                param.loveSongs = userInfo.loveSongs;
//                param.whatIsUp = userInfo.signature;
//                [SVProgressHUD show];
//                [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
//                    if (result.code == ResponseStateSuccess) {
//                        [SVProgressHUD dismiss];
//                        weakSelf.nickNameCell.subTitle = text;
//                        [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
//                    }else
//                    {
//                        [SVProgressHUD showErrorWithStatus:result.message];
//                    }
//                    
//                } failure:^(NSError *error) {
//                    [SVProgressHUD dismiss];
//                    CSLog(@"%@",error);
//                }];
//            };
//            [inputAlertView show];
            break;
        }
        case CSUserInfoCellTypeGender:
        {
            [self.view endEditing:YES];
            CSActionSheet *genderSheet = [[CSActionSheet alloc] initWithDelegate:self headerTitle:@"选择性别" cancelButtonTitle:@"取消" otherButtonTitles:@[@"男",@"女"]];
            [genderSheet show];
            _genderSheet = genderSheet;
            break;
        }
        case CSUserInfoCellTypeAge:
        {
            [self.view endEditing:YES];
            [self createPickerViewWithType:CSPickerViewTypeAge];
            if ([GlobalVar sharedSingleton].userInfo.age) {
                NSInteger index = [[GlobalVar sharedSingleton].userInfo.age integerValue] - 1;
                [_currentPickerView selectRow:index inComponent:0 animated:NO];
            }
            break;
        }
        case CSUserInfoCellTypeCon:
        {
            [self.view endEditing:YES];
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
            [self.view endEditing:YES];
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
    /*************************** 年龄 *****************************/
    if (_currentPickerView == _agePickerView) {
        NSNumber *age = [NSNumber numberWithInteger:[_agePickerView selectedRowInComponent:0] + 1];
        _tmpUserInfo.age = age;
        _ageCell.subTitle = [age stringValue];
        
        
        
    /*************************** 星座 *****************************/
    }else if(_currentPickerView == _conPickerView)
    {
        NSInteger index = [_conPickerView selectedRowInComponent:0];
        NSString *con = self.cons[index];
        _tmpUserInfo.constellation = con;
        _conCell.subTitle = con;
        
    /*************************** 血型 *****************************/
    }else if (_currentPickerView == _bloodTypePickerView)
    {
        NSInteger index = [_bloodTypePickerView selectedRowInComponent:0];
        NSString *bloodType = self.bloodTypes[index];
        _tmpUserInfo.bloodType = bloodType;
        _bloodTypeCell.subTitle = [NSString stringWithFormat:@"%@型",bloodType];
    }
    _confirmButton.enabled = ![GlobalObj.userInfo isEqualUserInfo:_tmpUserInfo];
}

- (void)startBtnOnClick:(UIButton *)button
{
    
    CSRequest *param = [[CSRequest alloc] init];
    param.age = _tmpUserInfo.age;
    param.nickName = GlobalObj.userInfo.nickName;
    param.bloodType = _tmpUserInfo.bloodType;
    param.gender = _tmpUserInfo.gender;
    param.constellation = _tmpUserInfo.constellation;

    
    [SVProgressHUD show];
     __weak typeof(self) weakSelf = self;
    [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
        
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD dismiss];
            GlobalObj.userInfo = result.data.userInfo;
            if (weakSelf.startBlock) {
                [weakSelf.navigationController popViewControllerAnimated:NO];
                weakSelf.startBlock();
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        
    } failure:^(NSError *error) {
        CSLog(@"%@",error);
    }];
}


- (void)updateUserInfo
{
    
    [self.view endEditing:YES];
    
    if ([PublicMethod stringContainsEmoji:_nickNameCell.nickNametextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"暂不支持表情符号作为昵称"];
        return;
    }
    
    if ([self getBytesLength:_nickNameCell.nickNametextField.text] > default_max_length) {
        [SVProgressHUD showErrorWithStatus:@"用户昵称过长,最多20个字符"];
        return;
    }
    
    if (_nickNameCell.nickNametextField.text != nil && _nickNameCell.nickNametextField.text.length > 0) {
        _nickNameCell.nickNametextField.text = [_nickNameCell.nickNametextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    if ([PublicMethod isBlankString:_nickNameCell.nickNametextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    
    _tmpUserInfo.nickName = _nickNameCell.nickNametextField.text;
    
    CSRequest *param = [[CSRequest alloc] init];
    param.age = _tmpUserInfo.age;
    param.nickName = _tmpUserInfo.nickName;
    param.bloodType = _tmpUserInfo.bloodType;
    param.gender = _tmpUserInfo.gender;
    param.constellation = _tmpUserInfo.constellation;
    
//    param.loveSingers = _tmpUserInfo.loveSingers;
//    param.loveSongs = _tmpUserInfo.loveSongs;
//    param.whatIsUp = _tmpUserInfo.signature;
    
    [SVProgressHUD show];
    [CSLoginHttpTool userProfileWithParam:param success:^(CSUserDataWrapperModel *result){
        
        if (result.code == ResponseStateSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [GlobalVar sharedSingleton].userInfo = result.data.userInfo;
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


- (NSInteger)getBytesLength:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    return [data length];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - CSUserInfoCellDelegate
- (void)userInfoCellDidLostFocusWithString:(NSString *)string
{
    _tmpUserInfo.nickName = string;
    _confirmButton.enabled = ![GlobalObj.userInfo isEqualUserInfo:_tmpUserInfo];
}


@end
