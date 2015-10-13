//
//  NBAddressViewController.m
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBAddressViewController.h"
#import "NBAccountTool.h"
#import "NBAddressCell.h"
#import "NBAddAddressButton.h"
#import "NBAddressEditViewController.h"
#import "NBLoginViewController.h"
#import "NBLoginHttpTool.h"

@interface NBAddressViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property(nonatomic, assign) NBAddressViewControllerType type;
/**
 *  地址列表
 */
@property(nonatomic, strong) UITableView *addressList;

@property(nonatomic, weak) UIButton *loginButton;

@end

@implementation NBAddressViewController

- (instancetype)initWithType:(NBAddressViewControllerType)type
{
    
    if (self = [self init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"送餐地址";
    [self setupSubViews];
    
}





- (void)setupSubViews
{
    UITableView *addressList = [[UITableView alloc] init];
    addressList.backgroundColor = HEX_COLOR(0xf3f3f3);
//    addressList.bounces = NO;
    addressList.dataSource = self;
    addressList.delegate = self;
    addressList.rowHeight = 62.5f;
    addressList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addressList];
    [addressList autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    _addressList = addressList;
    
    // 背景图
    [self setupAddressListBackgroundView];
    
    [self setupAddressListFooterView];
}
/**
 *  背景图
 */
- (void)setupAddressListBackgroundView
{
    UIView *addressListBackgroundView = [[UIView alloc] init];
    _addressList.backgroundView = addressListBackgroundView;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_icon_without_login"]];
    [addressListBackgroundView addSubview:iconView];
    [iconView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [iconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:44.0];
    
    UIButton *loginButton = [[UIButton alloc] initForAutoLayout];
    _loginButton = loginButton;
    [loginButton addTarget:self action:@selector(loginBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
//    [addressListBackgroundView addSubview:loginButton];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"mine_without_login_btn_bg"] forState:UIControlStateNormal];
    [loginButton setTitle:@"请登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton autoSetDimensionsToSize:loginButton.currentBackgroundImage.size];
    [loginButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconView withOffset:125.f];
}
/**
 *  新增地址按钮
 */
- (void)setupAddressListFooterView
{
    // 新增地址
    UIView *footView = [[UIView alloc] init];
    footView.hidden = YES;
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56.f);
    _addressList.tableFooterView = footView;
    NBAddAddressButton *addButton = [[NBAddAddressButton alloc] initForAutoLayout];
    [addButton setTitle:@"+新增地址" forState:UIControlStateNormal];
    [footView addSubview:addButton];
    [addButton autoSetDimension:ALDimensionHeight toSize:40.f];
    [addButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:footView];
    [addButton autoCenterInSuperview];
    [addButton addTarget:self action:@selector(addAddressBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_addressList reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([NBAccountTool account]) { // 如果已登录
        _addressList.backgroundView.hidden = YES;
        _loginButton.hidden = YES;
        _addressList.tableFooterView.hidden = NO;
    }else
    {
        _addressList.backgroundView.hidden = NO;
        _loginButton.hidden = NO;
        _addressList.tableFooterView.hidden = YES;
    }
    return [NBAccountTool account].addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBAddressCell *cell = [NBAddressCell cellWithTableView:tableView];
    
    NBAddressModel *item = (NBAddressModel *)[NBAccountTool account].addresses[indexPath.row];

    item.selected = indexPath.row == 0;
    
    cell.item = item;
    
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60.f];
    cell.delegate = self;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 立即取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NBAddressModel *item = [NBAccountTool account].addresses[indexPath.row];
    NBAddressEditViewController *editVc = [[NBAddressEditViewController alloc] initWithType:NBAddressEditViewControllerTypeEdit];
    editVc.item = item;
    if (_type == NBAddressViewControllerTypeMine) { // 我的页面的地址控制器
        [self.navigationController pushViewController:editVc animated:YES];
    }else{ // 下单页面地址控制器
        [[NBAccountTool account].addresses exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - SWTableViewDelegate
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // 允许每次值能有一个按钮被打开
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [SVProgressHUD show];
    switch (index) {
        case 0:
        {

            NSIndexPath *cellIndexPath = [_addressList indexPathForCell:cell];
            NBAddressModel *address = [NBAccountTool account].addresses[cellIndexPath.row];

            NBRequestModel *param = [[NBRequestModel alloc] init];
//            NBLog(@"%@",address.addressID);
            param.addressid = address.addressID;


            [NBLoginHttpTool deleteUserAddressInfoWithParam:param success:^(NBAddressResponseModel *result) {
                if (result.code == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"删除地址成功"];
                    [[NBAccountTool account].addresses removeObjectAtIndex:cellIndexPath.row];
                    [_addressList deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    // 如果删除的是第一条,那么第二条被选中
                    if (cellIndexPath.row == 0) {
                        NBAddressCell *addressCell = (NBAddressCell *)[_addressList cellForRowAtIndexPath:cellIndexPath];
                        addressCell.item.selected = YES;
                        addressCell.item = addressCell.item;
                        
                    }
                    
                }else
                {
                    NBLog(@"%@",result.message);
                }
            } failure:^(NSError *error) {
                NBLog(@"%@",error);
            }];
            
            
            break;
        }
        default:
            break;
    }
}

- (void)addAddressBtnOnClick
{
    [self.navigationController pushViewController:[[NBAddressEditViewController alloc] initWithType:NBAddressEditViewControllerTypeAdd] animated:YES];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     HEX_COLOR(0xf56800) title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)loginBtnOnClick:(UIButton *)button
{
    NBLog(@"登录按键点击");
    NBLoginViewController *loginVc = [[NBLoginViewController alloc] init];
    loginVc.loginBlock = ^(BOOL loginSuccess){
        if (loginSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
//
    [self.navigationController pushViewController:loginVc animated:YES];
    
}
@end
