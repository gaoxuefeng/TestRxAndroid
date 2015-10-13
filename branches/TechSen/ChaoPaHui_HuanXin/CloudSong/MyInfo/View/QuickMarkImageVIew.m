//
//  QuickMarkImageVIew.m
//  CloudSong
//
//  Created by Ethank on 15/8/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "QuickMarkImageVIew.h"
#import <Masonry.h>
#import "CSDefine.h"

@implementation QuickMarkImageVIew

- (instancetype)initWithTitle:(NSString *)titleStr image:(UIImage *)image tip:(NSString*)tipStr
{
    self = [super init];
    if (self) {
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker)];
        [self addGestureRecognizer:tapGesture];
        
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView.superview);
            make.centerY.equalTo(_bgView.superview);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(250), TRANSFER_SIZE(250)));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(14)];
        _titleLabel.text = titleStr;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel.superview);
            make.centerX.equalTo(_titleLabel.superview);
            make.top.equalTo(_titleLabel.superview).offset(TRANSFER_SIZE(5));
        }];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_bgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(TRANSFER_SIZE(5));
            make.left.right.equalTo(lineView.superview);
            make.height.mas_equalTo(@0.5);
        }];
        
        _quickMarkImg = [[UIImageView alloc] init];
        _quickMarkImg.image = image;
        _quickMarkImg.layer.cornerRadius = 4;
        _quickMarkImg.layer.masksToBounds = YES;
        [_bgView addSubview:_quickMarkImg];
        [_quickMarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(TRANSFER_SIZE(10));
            make.centerX.equalTo(_quickMarkImg.superview);
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(180), TRANSFER_SIZE(180)));
            
        }];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12)];
        _tipLabel.text = tipStr;
        [_bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_quickMarkImg.mas_bottom).offset(TRANSFER_SIZE(10));
            make.centerX.equalTo(_tipLabel.superview);
        }];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
    }
    return self;
}


- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
    
    [UIView animateWithDuration:.3f animations:^{

    }];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (void)dismissDatePicker
{
    [UIView animateWithDuration:0.3 animations:^{

        [self removeFromSuperview];
        [self removeGestureRecognizer:tapGesture];
        
    } completion:^(BOOL finished) {

    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
