//
//  NBAddressEditViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAddressEditViewController.h"
#import "NBAddAddressButton.h"
#import "NBAccountTool.h"
#import "NBLoginHttpTool.h"
#import "NBLoginTool.h"
#import <MJExtension.h>
#import "NSDictionary+JSONCategories.h"
#define H_MARGIN 14.f
#define CELL_HEIGHT 38.f
#define H_CHILD_MARGIN 94.f
#define MAX_NAME_LENGTH 8
#define MAX_ADDRESS_LENGTH 30
@interface NBAddressEditViewController ()
@property(nonatomic, assign) NBAddressEditViewControllerType type;
@property(nonatomic, weak) UIView *linkmanView;
@property(nonatomic, weak) UIButton *selectedButton;
@property(nonatomic, weak) UIView *genderView;
@property(nonatomic, weak) UIView *addressView;
@property(nonatomic, weak) UIView *phoneView;
/** 联系人 */
@property(nonatomic, weak) UITextField *linkmanTextField;
/** 男按钮 */
@property(nonatomic, weak) UIButton *maleButton;
/** 女按钮 */
@property(nonatomic, weak) UIButton *femaleButton;
/** 地址 */
@property(nonatomic, weak) UITextField *addressTextField;
/** 手机 */
@property(nonatomic, weak) UITextField *phoneTextField;
/** 所选性别 */
@property(nonatomic, assign) GenderType gender;
@end

@implementation NBAddressEditViewController

- (instancetype)initWithType:(NBAddressEditViewControllerType)type
{
    if (self  = [self init]) {
        _type = type;
    }
    return self;
}

- (GenderType)gender
{
    if (_maleButton.selected == YES && _femaleButton.selected == NO) {
        return GenderTypeMale;
    }else
    {
        return GenderTypeFemale;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _type?@"新增地址":@"编辑地址";
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 联系人
    [self setupLinkmanView];
    
    // 性别
    [self setupGenderView];
    
    // 地址
    [self setupAddress];
    
    // 手机号
    [self setupPhoneView];
    
    // 保存按钮
    [self setupSaveButton];
    
    if (_type == NBAddressEditViewControllerTypeEdit && _item) { // 增加
        _linkmanTextField.text = _item.name;
        if (_item.gender == GenderTypeMale) { // 如果是男
            _maleButton.selected = YES;
            _femaleButton.selected = NO;
            _selectedButton = _maleButton;
        }else // 女
        {
            _maleButton.selected = NO;
            _femaleButton.selected = YES;
            _selectedButton = _femaleButton;
        }
        _addressTextField.text = _item.address;
        _phoneTextField.text = _item.phone;
    }
}

- (void)setupLinkmanView
{
    UIView *linkmanView = [[UIView alloc] initForAutoLayout];
    linkmanView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linkmanView];
    _linkmanView = linkmanView;
    [linkmanView autoSetDimension:ALDimensionHeight toSize:CELL_HEIGHT];
    [linkmanView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [linkmanView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [linkmanView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    UILabel *linkmanLabel = [[UILabel alloc] initForAutoLayout];
    linkmanLabel.text = @"联系人";
    linkmanLabel.textColor = HEX_COLOR(0x464646);
    linkmanLabel.font = [UIFont systemFontOfSize:15.f];
    [linkmanView addSubview:linkmanLabel];
    [linkmanLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    [linkmanLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 下划线
    UIView *divider = [[UIView alloc]initForAutoLayout];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [linkmanView addSubview:divider];
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, H_CHILD_MARGIN, 0, H_MARGIN) excludingEdge:ALEdgeTop];
    
    
    // 输入框
    UITextField *linkmantextField = [[UITextField alloc] initForAutoLayout];
    _linkmanTextField = linkmantextField;
    linkmantextField.font = [UIFont systemFontOfSize:12.f];
    linkmantextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"您的姓名" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x8a8a8a)}];
    [linkmanView addSubview:linkmantextField];
    [linkmantextField autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:linkmanView];
    [linkmantextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 94.f, 0, H_MARGIN) excludingEdge:ALEdgeTop];
}

- (void)setupGenderView
{
    UIView *genderView = [[UIView alloc] initForAutoLayout];
    _genderView = genderView;
    [self.view addSubview:genderView];
    genderView.backgroundColor = [UIColor whiteColor];
    
    [genderView autoSetDimension:ALDimensionHeight toSize:CELL_HEIGHT];
    [genderView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [genderView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_linkmanView];
    [genderView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 下划线
    UIView *divider = [[UIView alloc]initForAutoLayout];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [genderView addSubview:divider];
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, H_MARGIN, 0, H_MARGIN) excludingEdge:ALEdgeTop];
    
    
    // 男按钮
    UIButton *maleButton = [[UIButton alloc] initForAutoLayout];
    maleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7.f);
    maleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7.f, 0, 0);
    maleButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [maleButton addTarget:self action:@selector(genderBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:maleButton];
    [maleButton setTitle:@"先生" forState:UIControlStateNormal];
    [maleButton setTitleColor:HEX_COLOR(0x646464) forState:UIControlStateNormal];
    [maleButton setImage:[UIImage imageNamed:@"mine_address_selected_icon"] forState:UIControlStateSelected];
    [maleButton setImage:[UIImage imageNamed:@"mine_address_normal_icon"] forState:UIControlStateNormal];
    [maleButton setTitleColor:HEX_COLOR(0x646464) forState:UIControlStateNormal];
    maleButton.selected = YES;
    _maleButton = maleButton;
    _selectedButton = maleButton;
    [maleButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [maleButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_CHILD_MARGIN];
    [maleButton autoSetDimension:ALDimensionWidth toSize:52.f];
    [maleButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:genderView];
    
    // 女按钮
    UIButton *femaleButton = [[UIButton alloc] initForAutoLayout];
    femaleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7.f);
    femaleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7.f, 0, 0);
    femaleButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [femaleButton addTarget:self action:@selector(genderBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [genderView addSubview:femaleButton];
    _femaleButton = femaleButton;
    [femaleButton setTitle:@"女士" forState:UIControlStateNormal];
    [femaleButton setTitleColor:HEX_COLOR(0x646464) forState:UIControlStateNormal];
    [femaleButton setImage:[UIImage imageNamed:@"mine_address_selected_icon"] forState:UIControlStateSelected];
    [femaleButton setImage:[UIImage imageNamed:@"mine_address_normal_icon"] forState:UIControlStateNormal];
    [femaleButton setTitleColor:HEX_COLOR(0x646464) forState:UIControlStateNormal];
    [femaleButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [femaleButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:maleButton withOffset:48.f];
    [femaleButton autoSetDimension:ALDimensionWidth toSize:52.f];
    [femaleButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:genderView];
    
    
}

- (void)setupAddress
{
    UIView *addressView = [[UIView alloc] initForAutoLayout];
    _addressView = addressView;
    addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressView];
    [addressView autoSetDimension:ALDimensionHeight toSize:CELL_HEIGHT];
    [addressView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [addressView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderView];
    [addressView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UILabel *addressLabel = [[UILabel alloc] initForAutoLayout];
    addressLabel.text = @"收餐地址";
    addressLabel.textColor = HEX_COLOR(0x464646);
    addressLabel.font = [UIFont systemFontOfSize:15.f];
    [addressView addSubview:addressLabel];
    [addressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    [addressLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 输入框
    UITextField *addresstextField = [[UITextField alloc] initForAutoLayout];
    addresstextField.font = [UIFont systemFontOfSize:12.f];
    addresstextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写您的详细地址" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x8a8a8a)}];
    _addressTextField = addresstextField;
    [addressView addSubview:addresstextField];
    [addresstextField autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:addressView];
    [addresstextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, H_CHILD_MARGIN, 0, H_MARGIN) excludingEdge:ALEdgeTop];
    
    
    // 下划线
    UIView *divider = [[UIView alloc]initForAutoLayout];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [addressView addSubview:divider];
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, H_MARGIN, 0, H_MARGIN) excludingEdge:ALEdgeTop];
    
}

- (void)setupPhoneView
{
    UIView *phoneView = [[UIView alloc] initForAutoLayout];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    _phoneView = phoneView;
    [phoneView autoSetDimension:ALDimensionHeight toSize:CELL_HEIGHT];
    [phoneView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [phoneView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_addressView];
    [phoneView autoAlignAxisToSuperviewAxis:ALAxisVertical];


    
    UILabel *phoneLabel = [[UILabel alloc] initForAutoLayout];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = HEX_COLOR(0x464646);
    phoneLabel.font = [UIFont systemFontOfSize:15.f];
    [phoneView addSubview:phoneLabel];
    [phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:H_MARGIN];
    [phoneLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 下划线
    UIView *divider = [[UIView alloc]initForAutoLayout];
    divider.backgroundColor = HEX_COLOR(0xe9e9e9);
    [phoneView addSubview:divider];
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    // 输入框
    UITextField *phonetextField = [[UITextField alloc] initForAutoLayout];
    phonetextField.font = [UIFont systemFontOfSize:12.f];
    phonetextField.keyboardType = UIKeyboardTypePhonePad;
    _phoneTextField = phonetextField;
    phonetextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"配送人员联系您的电话" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x8a8a8a)}];
    [phoneView addSubview:phonetextField];
    [phonetextField autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_addressView];
    [phonetextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 94.f, 0, H_MARGIN) excludingEdge:ALEdgeTop];
}

- (void)setupSaveButton
{
    NBAddAddressButton *saveButton = [[NBAddAddressButton alloc] initForAutoLayout];
    [saveButton addTarget:self action:@selector(saveBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    [saveButton autoSetDimension:ALDimensionHeight toSize:40.f];
    [saveButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [saveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [saveButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_phoneView withOffset:9.f];
}

- (void)genderBtnOnClick:(UIButton *)button
{
    _selectedButton.selected = NO;
    button.selected = YES;
    
    _selectedButton = button;
    
}

- (void)saveBtnOnClick:(UIButton *)button
{
    if (!(_linkmanTextField.text != nil && _linkmanTextField.text.length >0)) { // 联系人为空
        [SVProgressHUD showErrorWithStatus:@"请输入联系人"];
        return;
    }
    if (!(_addressTextField.text != nil && _addressTextField.text.length >0)) { // 地址为空
        [SVProgressHUD showErrorWithStatus:@"请输入收餐地址"];
        return;
    }
    if (!(_phoneTextField.text != nil && _phoneTextField.text.length >0)) { // 手机号为空
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![NBLoginTool isMobileNumber:_phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
//    if (_linkmanTextField.text != nil && _linkmanTextField.text.length > MAX_NAME_LENGTH) { // 联系人为姓名过长
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"姓名过长(最多%d个字符)",MAX_NAME_LENGTH]];
//        _linkmanTextField.text = [_linkmanTextField.text substringToIndex:MAX_NAME_LENGTH];
//        return;
//    }
    
//    if (_addressTextField.text != nil && _addressTextField.text.length > MAX_ADDRESS_LENGTH) { // 地址为空
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"地址过长(最多%d个字符)",MAX_ADDRESS_LENGTH]];
//        _addressTextField.text = [_addressTextField.text substringToIndex:MAX_ADDRESS_LENGTH];
//        return;
//    }
    
    NBRequestModel *param = [[NBRequestModel alloc] init];
    NBAddressJsonStringModel *addressJsonString = [[NBAddressJsonStringModel alloc] init];
    addressJsonString.uname = _linkmanTextField.text;
    addressJsonString.phonenum = _phoneTextField.text;
    addressJsonString.detailaddress = _addressTextField.text;
    addressJsonString.sex = self.gender;
    addressJsonString.userid = [NBAccountTool userId];
    if (_type == NBAddressEditViewControllerTypeEdit) {
        addressJsonString.addressid = _item.addressID;
    }
    NSDictionary *dict = [addressJsonString keyValues];
    NSString *jsonStr = [dict JSONString];
    param.addressJsonString = jsonStr;
    // 增加遮板
    [SVProgressHUD show];
    if (_type == NBAddressEditViewControllerTypeEdit) { // 编辑
        [NBLoginHttpTool editUserAddressInfoWithParam:param success:^(NBAddressResponseModel *result) {
            if (0 == result.code) { // 修改成功
                [SVProgressHUD showSuccessWithStatus:@"修改地址成功"];
                _item.name = _linkmanTextField.text;
                _item.gender = self.gender;
                _item.address = _addressTextField.text;
                _item.phone = _phoneTextField.text;
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误,请检测网络"];
            NBLog(@"%@",error);
        }];
    }else // 新增
    {
        [NBLoginHttpTool addUserAddressInfoWithParam:param success:^(NBAddressResponseModel *result) {
            if (0 == result.code) { // 新增成功
                [SVProgressHUD showSuccessWithStatus:@"新增地址成功"];
                NBAddressModel *address = [[NBAddressModel alloc] init];
                address.name = _linkmanTextField.text;
                address.gender = self.gender;
                address.address = _addressTextField.text;
                address.phone = _phoneTextField.text;
                address.addressID = result.address.addressID;
                [[NBAccountTool account].addresses insertObject:address atIndex:0];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:result.message];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误,请检测网络"];
            NBLog(@"%@",error);
        }];
    }
}
@end
