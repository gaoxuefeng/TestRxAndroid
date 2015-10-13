//
//  CSAmountSelector.m
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//  数量选择器

#import "CSAmountSelector.h"
#import <Masonry.h>
#import "CSDefine.h"
@interface CSAmountSelector ()
@property(nonatomic, weak) UIImageView *bgView;
@property(nonatomic, weak) UIButton *plusButton;
@property(nonatomic, weak) UIButton *unsightedPlusButton;
@property(nonatomic, weak) UIButton *unsightedMinusButton;
@property(nonatomic, weak) UILabel *amountLabel;
@property(nonatomic, assign) BOOL didUpdateConstraint;

@end

@implementation CSAmountSelector

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupSubViews];
    }
    return self;
}

- (void)setAmount:(NSInteger)amount
{
    _amount = amount;
    if (amount) { // 如果数量不等于0
        _plusButton.hidden = YES;
        _unsightedMinusButton.hidden = NO;
        _unsightedMinusButton.hidden = NO;
        _bgView.hidden = NO;
        _amountLabel.hidden = NO;
    }else
    {
        _plusButton.hidden = NO;
        _unsightedMinusButton.hidden = YES;
        _unsightedMinusButton.hidden = YES;
        _bgView.hidden = YES;
        _amountLabel.hidden = YES;
        
    }
    _amountLabel.text = [NSString stringWithFormat:@"%ld",_amount];
}

- (void)setupSubViews
{
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wine_add_btn_s"]];
    bgView.hidden = YES;
    _bgView = bgView;
    [self addSubview:bgView];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    _amountLabel = amountLabel;
    amountLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(10.0)];
    amountLabel.textColor = HEX_COLOR(0xff41ab);
    [self addSubview:amountLabel];
    
    // 可见加号按钮
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton addTarget:self action:@selector(plusBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"wine_add_btn"] forState:UIControlStateNormal];
    _plusButton = plusButton;
    [self addSubview:plusButton];
    
    // 不可见加号按钮
    UIButton *unsightedPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unsightedPlusButton addTarget:self action:@selector(plusBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _unsightedPlusButton = unsightedPlusButton;
    [self addSubview:unsightedPlusButton];
    
    // 不可见减号按钮
    UIButton *unsightedMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unsightedMinusButton addTarget:self action:@selector(minusBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _unsightedMinusButton = unsightedMinusButton;
    [self addSubview:unsightedMinusButton];
    

}

- (void)updateConstraints
{
    if (!self.didUpdateConstraint) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.size.mas_equalTo(self.bgView.image.size);
        }];
        
        [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
        }];
        
        [self.unsightedPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.mas_equalTo(TRANSFER_SIZE(25.0));
        }];
        
        [self.unsightedMinusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self);
            make.width.mas_equalTo(TRANSFER_SIZE(25.0));
        }];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        self.didUpdateConstraint = YES;
    }
    
    [super updateConstraints];
}

#pragma - mark Touch Events
- (void)plusBtnOnClick:(UIButton *)button
{
    self.amount++;
    [self manualAmountChange];
    
    // 发送加号按钮通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"plusButtonOnClick" object:nil userInfo:@{@"info":button}];

}

- (void)minusBtnOnClick:(UIButton *)button
{
    self.amount--;
    [self manualAmountChange];
}

/** 手动改变 */
- (void)manualAmountChange
{
    if ([self.delegate respondsToSelector:@selector(amountSelector:amountDidChange:)]) {
        [self.delegate amountSelector:self amountDidChange:_amount];
    }
}

@end
