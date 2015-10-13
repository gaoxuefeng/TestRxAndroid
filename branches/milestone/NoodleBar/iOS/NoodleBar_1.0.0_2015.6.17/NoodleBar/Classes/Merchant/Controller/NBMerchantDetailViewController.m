//
//  NBMerchantDetailViewController.m
//  NoodleBar
//
//  Created by sen on 6/7/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBMerchantDetailViewController.h"
#import "NBMerchantTopCell.h"
#import "NBCell.h"
#import "NBMerchantHttpTool.h"
#import "NBMerchantTool.h"
#import <MJExtension.h>
@interface NBMerchantDetailViewController ()
@property(nonatomic, weak) UIScrollView *scrollView;

@property(nonatomic, strong) NBMerchantModel *merchantData;

@property(nonatomic, weak)  NBCell *addressCell;

@property(nonatomic, weak) NBCell *phoneCell;

@property(nonatomic, weak) NBMerchantTopCell *merchantTopView;
// 打电话用
@property (strong, nonatomic) UIWebView *webView;

@property(nonatomic, weak) UILabel *contentLabel;

@property(nonatomic, copy) NSString *merchantID;
@end

@implementation NBMerchantDetailViewController

#pragma mark - lazyload
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (instancetype)initWithMerchantID:(NSString *)merchantID
{
    _merchantID = merchantID;
    return [self init];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏
    self.title = @"商户信息";
    self.view.backgroundColor = HEX_COLOR(0xf3f3f3);
    [self loadData];
}

- (void)loadData
{
    NBRequestModel *param = [[NBRequestModel alloc] init];
    param.businessid = _merchantID;

    [NBMerchantHttpTool merchantWithParam:param success:^(NBMerchantResponseModel *result) {
        if (result.code == 0) {
            [self setupSubViews];
            _merchantData = result.data;
            [_addressCell setText:_merchantData.address];
            [_phoneCell setText:_merchantData.phonenum];
            _contentLabel.text = _merchantData.brief;
            _merchantTopView.item = _merchantData;
        }
    } failure:^(NSError *error) {
        NBLog(@"%@",error);
    }];
}

- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initForAutoLayout];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    [containerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [containerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:scrollView];
    
    // 顶部
    NBMerchantTopCell *merchantTopView = [NBMerchantTopCell newAutoLayoutView];
    _merchantTopView = merchantTopView;
    [containerView addSubview:merchantTopView];
    [merchantTopView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 126.f)];
    [merchantTopView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:containerView];
    [merchantTopView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 地址
    NBCell *addressCell = [NBCell newAutoLayoutView];
    _addressCell = addressCell;
    addressCell.showBottomDivider = YES;
    [addressCell setImage:[UIImage imageNamed:@"merchant_location"]];
    [addressCell setText:nil withColor:HEX_COLOR(0x969696) Font:[UIFont systemFontOfSize:13.f]];
    [containerView addSubview:addressCell];
    
    [addressCell autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 39.5f)];
    [addressCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [addressCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:merchantTopView];
    
    //电话
    NBCell *phoneCell = [NBCell newAutoLayoutView];
    _phoneCell = phoneCell;
    [phoneCell setImage:[UIImage imageNamed:@"merchant_phone"]];
    [phoneCell setText:nil withColor:HEX_COLOR(0x969696) Font:[UIFont systemFontOfSize:13.f]];
    [containerView addSubview:phoneCell];
    [phoneCell autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 39.f)];
    [phoneCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [phoneCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:addressCell];
    __block typeof(phoneCell) blockPhoneCell = phoneCell;
    __weak typeof(self) weakSelf = self;
    phoneCell.option = ^{
        
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",[blockPhoneCell text]];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
    };
    
    // 餐厅介绍
    NBCell *introduceCell = [NBCell newAutoLayoutView];
    introduceCell.showBottomDivider = YES;
    [introduceCell setImage:[UIImage imageNamed:@"merchant_introduce"]];
    [introduceCell setText:@"餐厅介绍" withColor:HEX_COLOR(0x464646) Font:[UIFont systemFontOfSize:13.f]];
    [containerView addSubview:introduceCell];
    [introduceCell autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 39.5f)];
    [introduceCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [introduceCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneCell withOffset:14.f];
    
    // 介绍详情
    NBCell *introduceContentCell = [NBCell newAutoLayoutView];
    [containerView addSubview:introduceContentCell];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    _contentLabel = contentLabel;
    contentLabel.textColor = HEX_COLOR(0x969696);
    contentLabel.font = [UIFont systemFontOfSize:13.0];
    contentLabel.numberOfLines = 0;
    [introduceContentCell addSubview:contentLabel];
    
    [contentLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;
    
    [introduceContentCell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [introduceContentCell autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [introduceContentCell autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [introduceContentCell autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:introduceCell];
    [containerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:introduceContentCell];
    
//    introduceContentCell.option = ^{
//        [weakSelf.navigationController presentViewController:[[NBMerchantNoticeViewController alloc] init] animated:YES completion:nil];
};


@end
