//
//  CSCancelRoomViewController.m
//  CloudSong
//
//  Created by sen on 15/6/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  确认取消订单控制器

#import "CSCancelRoomViewController.h"
#import <Masonry.h>
#import "CSCancelRoomCell.h"
#import "SVProgressHUD.h"
@interface CSCancelRoomViewController ()
{
    UIScrollView *_scorllView;
}
@property(nonatomic, weak) CSCancelRoomCell *refundMoneyCell;

@property(nonatomic, weak) CSCancelRoomCell *refundTypeCell;

@property(nonatomic, weak) CSCancelRoomCell *refundCycleCell;

@property(nonatomic, weak) UIButton *confirmButton;

@property(nonatomic, assign) CGFloat price;
@end

@implementation CSCancelRoomViewController

- (instancetype)initWithPrice:(CGFloat )price
{
    _price = price;
    return [self init];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退单确认";
    [self setupSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - Setup
- (void)setupSubViews
{
    _scorllView = [[UIScrollView alloc] init];
    _scorllView.alwaysBounceVertical = YES;
    [self.view addSubview:_scorllView];
    [_scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scorllView.superview);
    }];
    
    UIView *container = [[UIView alloc] init];
    [_scorllView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container.superview);
        make.width.equalTo(container.superview);
    }];
    
    UIView *refundMoneyTopLine = [[UIView alloc] init];
    refundMoneyTopLine.backgroundColor = HEX_COLOR(0x3f2757);
    [container addSubview:refundMoneyTopLine];
    [refundMoneyTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundMoneyTopLine.superview).offset(15.0);
        make.left.right.equalTo(refundMoneyTopLine.superview);
        make.height.mas_equalTo(0.5);
    }];
    CSCancelRoomCell *refundMoneyCell = [[CSCancelRoomCell alloc] initWithTitle:@"退款金额:"];
    refundMoneyCell.contentColor = HEX_COLOR(0xe33b99);
    [container addSubview:refundMoneyCell];
    [refundMoneyCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundMoneyTopLine.mas_bottom);
        make.left.right.equalTo(refundMoneyCell.superview);
        make.height.mas_equalTo(48.5);
    }];
    
    _refundMoneyCell = refundMoneyCell;
    UIView *refundMoneyBottomLine = [[UIView alloc] init];
    refundMoneyBottomLine.backgroundColor = refundMoneyTopLine.backgroundColor;
    [container addSubview:refundMoneyBottomLine];
    [refundMoneyBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundMoneyCell.mas_bottom);
        make.left.right.equalTo(refundMoneyBottomLine.superview);
        make.height.mas_equalTo(0.5);
    }];
    CSCancelRoomCell *refundTypeCell = [[CSCancelRoomCell alloc] initWithTitle:@"退款途径:"];
    [container addSubview:refundTypeCell];
    [refundTypeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundMoneyBottomLine.mas_bottom);
        make.left.right.equalTo(refundTypeCell.superview);
        make.height.mas_equalTo(48.5);
    }];
    _refundTypeCell = refundTypeCell;
    UIView *refundTypeBottomLine = [[UIView alloc] init];
    refundTypeBottomLine.backgroundColor = refundMoneyTopLine.backgroundColor;
    [container addSubview:refundTypeBottomLine];
    [refundTypeBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundTypeCell.mas_bottom);
        make.left.right.equalTo(refundTypeBottomLine.superview);
        make.height.mas_equalTo(0.5);
    }];
    CSCancelRoomCell *refundCycleCell = [[CSCancelRoomCell alloc] initWithTitle:@"退款时长:"];
    [container addSubview:refundCycleCell];
    [refundCycleCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundTypeBottomLine.mas_bottom);
        make.left.right.equalTo(refundCycleCell.superview);
        make.height.mas_equalTo(48.5);
    }];
    _refundCycleCell = refundCycleCell;
    UIView *refundCycleBottomLine = [[UIView alloc] init];
    refundCycleBottomLine.backgroundColor = refundMoneyTopLine.backgroundColor;
    [container addSubview:refundCycleBottomLine];
    [refundCycleBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundCycleCell.mas_bottom);
        make.left.right.equalTo(refundCycleBottomLine.superview);
        make.height.mas_equalTo(0.5);
    }];
    
    // 确认按钮
    UIButton *confirmbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmbutton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmbutton addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    confirmbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    confirmbutton.layer.cornerRadius = 4.0;
    confirmbutton.layer.masksToBounds = YES;
    confirmbutton.backgroundColor = HEX_COLOR(0x852c5f);
    [container addSubview:confirmbutton];
    [confirmbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmbutton.superview).offset(10.0);
        make.right.equalTo(confirmbutton.superview).offset(-10.0);
        make.top.equalTo(refundCycleBottomLine.mas_bottom).offset(15.0);
        make.height.mas_equalTo(39.0);
        make.bottom.equalTo(confirmbutton.superview.mas_bottom);
    }];
}

#pragma mark - Load Data
- (void)loadData
{
    _refundMoneyCell.content = [NSString stringWithFormat:@"￥%@",[NSString stringWithFloat:_price]];
    _refundTypeCell.content = @"原路返回";
    _refundCycleCell.content = @"1-5个工作日";
}


#pragma mark - Action
- (void)confirmBtnPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
