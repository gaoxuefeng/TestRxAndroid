//
//  CSOrderPayMethodCell.m
//  CloudSong
//
//  Created by sen on 5/27/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSOrderPayMethodCell.h"
#import "CSOrderPayCellHeaderView.h"
#import <Masonry.h>
#import "CSPayTypeCell.h"
#import "WXApi.h"

@interface CSOrderPayMethodCell ()
@property(nonatomic, weak) CSOrderPayCellHeaderView *headerView;
@property(nonatomic, weak) CSPayTypeCell *wechatCell;
@property(nonatomic, weak) CSPayTypeCell *alipayCell;
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) CSPayTypeCell *selectedPayTypeCell;
@end


@implementation CSOrderPayMethodCell


- (void)setSelectedPayTypeCell:(CSPayTypeCell *)selectedPayTypeCell
{
    _selectedPayTypeCell = selectedPayTypeCell;
    _payType = selectedPayTypeCell.tag;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}



- (void)setupSubViews
{
    CSOrderPayCellHeaderView *headerView = [[CSOrderPayCellHeaderView alloc] init];
    headerView.title = @"支付方式";
    headerView.backgroundColor = WhiteColor_Alpha_6;
    _headerView = headerView;
    [self addSubview:headerView];
    
    CSPayTypeCell *alipayCell = [[CSPayTypeCell alloc] initWithType:CSPayMethodTypeAlipay];
    [alipayCell addTarget:self action:@selector(payCellOnClick:)];
    alipayCell.tag = CSPayMethodTypeAlipay;
    alipayCell.backgroundColor = WhiteColor_Alpha_4;
    _alipayCell = alipayCell;
    [self addSubview:alipayCell];
    alipayCell.selected = YES;
    self.selectedPayTypeCell = alipayCell;
    
    
    if ([WXApi isWXAppInstalled]) {
        CSPayTypeCell *wechatCell = [[CSPayTypeCell alloc] initWithType:CSPayMethodTypeWechat];
        [wechatCell addTarget:self action:@selector(payCellOnClick:)];
        wechatCell.tag = CSPayMethodTypeWechat;
        wechatCell.backgroundColor = WhiteColor_Alpha_4;
        _wechatCell = wechatCell;
        [self addSubview:wechatCell];
    }
    
    
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(TRANSFER_SIZE(38.0));
        }];
        [self.alipayCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo(TRANSFER_SIZE(48.5));
            if (![WXApi isWXAppInstalled]) {
                make.bottom.equalTo(self);
            }
        }];
        [self.wechatCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.alipayCell.mas_bottom);
            make.height.mas_equalTo(TRANSFER_SIZE(48.5));
            make.bottom.equalTo(self);
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Touch Events
- (void)payCellOnClick:(UITapGestureRecognizer *)tapGR
{
    self.selectedPayTypeCell.selected = NO;
    CSPayTypeCell *cell = (CSPayTypeCell *)tapGR.view;
    cell.selected = YES;
    self.selectedPayTypeCell = cell;
}

@end
