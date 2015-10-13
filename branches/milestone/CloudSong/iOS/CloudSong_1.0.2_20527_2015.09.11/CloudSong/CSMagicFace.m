//
//  CSMagicFace.m
//  CloudSong
//
//  Created by sen on 8/12/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSMagicFace.h"
#import "CSDefine.h"
#import <Masonry.h>


@interface CSMagicFace ()
@property(nonatomic, weak) UILabel *textLabel;
@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end


@implementation CSMagicFace

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubviews
{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = HEX_COLOR(0xd4d3da);
    textLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
    [self addSubview:textLabel];
    _textLabel = textLabel;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {

        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_imageView.superview);
            make.bottom.equalTo(_imageView.superview).offset(-TRANSFER_SIZE(20.0));
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageView.superview);
            make.top.equalTo(_imageView.mas_bottom);
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public
- (void)setText:(NSString *)text
{
    _text = text;
    _textLabel.text = text;
    [self layoutIfNeeded];
    
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
    [self layoutIfNeeded];
    
}

- (void)addTarget:(id)target action:(SEL)sel
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    [self addGestureRecognizer:tapGr];
}

@end
