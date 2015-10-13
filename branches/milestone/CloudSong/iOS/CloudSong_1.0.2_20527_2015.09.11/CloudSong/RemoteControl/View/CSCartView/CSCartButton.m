//
//  CSCartButton.m
//  CloudSong
//
//  Created by sen on 15/5/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//  购物车按钮

#import "CSCartButton.h"
#import <Masonry.h>
#import "CSDefine.h"
#define AMOUNT_LABEL_HEIGHT 21.0
@interface CSCartButton ()
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) UILabel *amountLabel;

@end

@implementation CSCartButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"wine_shopping_cart_icon"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"wine_shopping_cart_icon"] forState:UIControlStateDisabled];
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews
{
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.hidden = YES;
    _amountLabel = amountLabel;
    amountLabel.font = [UIFont systemFontOfSize:12.0];
    amountLabel.backgroundColor = HEX_COLOR(0x85265f);
    amountLabel.textColor = HEX_COLOR(0xe2e2e2);
    amountLabel.layer.cornerRadius = AMOUNT_LABEL_HEIGHT * 0.5;
    amountLabel.layer.masksToBounds = YES;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:amountLabel];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.right.equalTo(self);
            make.top.equalTo(self).offset(-2);
            make.right.equalTo(self).offset(2);
            make.size.mas_equalTo(CGSizeMake(AMOUNT_LABEL_HEIGHT, AMOUNT_LABEL_HEIGHT));
        }];
        [self didSetupConstraint];
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setAmount:(int)amount
{
    self.enabled = amount;
    
    if (amount) {
        _amountLabel.hidden = NO;
        _amountLabel.text = [NSString stringWithFormat:@"%d",amount];
        return;
    }
    _amountLabel.hidden = YES;
}

@end
