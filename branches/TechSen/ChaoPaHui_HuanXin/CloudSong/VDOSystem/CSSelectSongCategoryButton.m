//
//  CSSelectSongCategoryButton.m
//  CloudSong
//
//  Created by youmingtaizi on 5/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSSelectSongCategoryButton.h"
#import "CSDefine.h"
#import <Masonry.h>

@interface CSSelectSongCategoryButton () {
    UIImageView*   _imageView;
    UILabel*       _titleLabel;
}
@end

@implementation CSSelectSongCategoryButton

- (void)setImage:(UIImage *)image title:(NSString *)title {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(12);
        }];
    }
    _imageView.image = image;
    
    if (!_titleLabel) {
        CGFloat labelHeight = 20;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, labelHeight)];
        _titleLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - labelHeight);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = Color_Hex_97_99_a2;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(43);
        }];
    }
    _titleLabel.text = title;
}

@end
