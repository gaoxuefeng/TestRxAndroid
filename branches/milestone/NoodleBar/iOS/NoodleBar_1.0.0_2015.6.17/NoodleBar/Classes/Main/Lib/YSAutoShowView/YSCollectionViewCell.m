//
//  YSCollectionViewCell.m
//  YSAutoShowView
//
//  Created by Sen on 15/3/23.
//  Copyright (c) 2015年 Sen. All rights reserved.
//

#import "YSCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "NBCommon.h"

@interface YSCollectionViewCell()
{
    BOOL _didSetupConstraint;
    UIImageView *_imageView;
}

@end

@implementation YSCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = HEX_COLOR(0xf5f5f7);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImageUrlStr:(NSString *)imageUrlStr
{
    _imageUrlStr = imageUrlStr;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    if (!_didSetupConstraint) {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

@end
