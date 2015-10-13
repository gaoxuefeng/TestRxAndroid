//
//  CSCleanCacheStatusBar.m
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCleanCacheStatusBar.h"
#import "CSDefine.h"
#import <Masonry.h>
@interface CSCleanCacheStatusBar ()
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIActivityIndicatorView *indicator;

@end

@implementation CSCleanCacheStatusBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1.0;
        self.backgroundColor = HEX_COLOR(0x0f0e10);
        self.hidden = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    __weak typeof(self) weakSelf = self;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(TRANSFER_SIZE(22.0));
        
    }];
    _indicator = indicator;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    titleLabel.textColor = HEX_COLOR(0x7e8085);
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    _titleLabel = titleLabel;
    
}

#pragma mark - Public Methods
- (void)show
{
    self.hidden = NO;
    _titleLabel.text = @"正在清除缓存...";
    [_indicator startAnimating];
    
}

- (void)dismiss
{
    _titleLabel.text = @"缓存清理完毕";
    [_indicator stopAnimating];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.hidden = YES;
        [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [weakSelf resignKeyWindow];
        [weakSelf removeFromSuperview];
    });

}


- (void)dealloc
{
    CSLog(@"挂了");
}


@end
