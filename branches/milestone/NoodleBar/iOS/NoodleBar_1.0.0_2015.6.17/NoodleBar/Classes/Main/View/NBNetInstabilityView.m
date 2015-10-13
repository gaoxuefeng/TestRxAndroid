//
//  NBNoNetworkingWarning.m
//  NoodleBar
//
//  Created by sen on 15/5/12.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBNetInstabilityView.h"
#import "NBCommon.h"

@interface NBNetInstabilityView ()
{
    BOOL _didSetupConstraint;
    UIImageView *_imageView;
    UILabel *_textLabel;
    UILabel *_subTextLabel;
    UIButton *_refreshButton;
}
@end

@implementation NBNetInstabilityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt_no_network"]];
        [self addSubview:_imageView];


        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"网络不稳定";
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_textLabel];
        
        _subTextLabel = [[UILabel alloc] init];
        _subTextLabel.text = @"请稍后再试";
        _subTextLabel.textColor = [UIColor lightGrayColor];
        _subTextLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_subTextLabel];

        
        _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _refreshButton.layer.cornerRadius = 25;
        _refreshButton.layer.masksToBounds = YES;
        _refreshButton.backgroundColor = [UIColor orangeColor];
        _refreshButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_refreshButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_refreshButton];
    }
    return self;
}


#pragma mark - Public Methods
- (void)refreshBtnaddTarget:(id)target Action:(SEL)sel
{
    [_refreshButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Inherit
- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-80.0);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_imageView.mas_bottom).offset(20.0);
        }];
        
        [_subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_textLabel.mas_bottom).offset(10.0);
        }];
        
        [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150.0, 50.0));
            make.centerX.equalTo(self);
            make.top.equalTo(_subTextLabel.mas_bottom).offset(30.0);
        }];
        _didSetupConstraint = YES;
    }
    [super updateConstraints];
}

@end
