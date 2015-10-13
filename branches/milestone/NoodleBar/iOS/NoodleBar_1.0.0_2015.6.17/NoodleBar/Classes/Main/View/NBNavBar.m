//
//  NBNavBar.m
//  NoodleBar
//
//  Created by sen on 15/4/17.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBNavBar.h"
#import "NBCommon.h"

@interface NBNavBar()
@property(nonatomic, weak) UILabel *navTitle;
@property(nonatomic, weak) UIButton *backButton;

@end


@implementation NBNavBar

#pragma mark - lazyload
- (UILabel *)navTitle
{
    if (!_navTitle) {
        // 导航标题
        UILabel *navTitle = [[UILabel alloc] init];
        [self addSubview:navTitle];
        navTitle.font = [UIFont boldSystemFontOfSize:17.f];
        navTitle.textColor = HEX_COLOR(0xeea300);
        [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(10.0);
        }];
        _navTitle = navTitle;
    }
    return _navTitle;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        // 导航返回键
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
            make.left.bottom.equalTo(self);
        }];
        _backButton = backButton;
    }
    return _backButton;
}

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - public
- (void)setTitle:(NSString *)title
{
    self.navTitle.text = title;
}

- (void)backButtonAddTarget:(id)target Action:(SEL)sel
{
    [self.backButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonHidden:(BOOL)hidden
{
    self.backButton.hidden = hidden;
}

- (void)setTitleView:(UIView *)titleView
{
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10.0);
        make.centerX.equalTo(self);
    }];
}





@end
