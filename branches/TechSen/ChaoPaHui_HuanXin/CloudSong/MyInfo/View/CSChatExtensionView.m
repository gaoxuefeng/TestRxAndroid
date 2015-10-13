//
//  CSChatExtensionView.m
//  CloudSong
//
//  Created by sen on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSChatExtensionView.h"
#import <Masonry.h>
#import "CSDefine.h"

@interface CSChatExtensionView ()
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, strong) NSMutableArray *buttonViews;
@end

@implementation CSChatExtensionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
        self.backgroundColor = HEX_COLOR(0x482a70);
    }
    return self;
}

#pragma mark - SetupSubviews
- (void)setupSubviews
{
    _buttonViews = [NSMutableArray array];
    
    UIButton *magicFaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    magicFaceButton.tag = CSChatExtensionTypeMagicFace;
    [magicFaceButton addTarget:self action:@selector(extensionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [magicFaceButton setImage:[[UIImage imageNamed:@"room_magicexpression_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIView *magicFaceView = [self buttonViewWithButton:magicFaceButton Title:@"魔法表情"];
    [self addSubview:magicFaceView];
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photoButton.tag = CSChatExtensionTypePhoto;
    [photoButton addTarget:self action:@selector(extensionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setImage:[[UIImage imageNamed:@"room_album_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIView *photoView = [self buttonViewWithButton:photoButton Title:@"相册图片"];
    [self addSubview:photoView];
    
    UIButton *doodleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doodleButton.tag = CSChatExtensionTypeDoodle;
    [doodleButton addTarget:self action:@selector(extensionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [doodleButton setImage:[[UIImage imageNamed:@"room_graffiti_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIView *doodleView = [self buttonViewWithButton:doodleButton Title:@"趣味涂鸦"];
    [self addSubview:doodleView];
    
    [_buttonViews addObject:magicFaceView];
    [_buttonViews addObject:photoView];
    [_buttonViews addObject:doodleView];

}

- (UIView *)buttonViewWithButton:(UIButton *)button Title:(NSString *)title
{
    UIView *buttonView = [[UIView alloc] init];
    buttonView.translatesAutoresizingMaskIntoConstraints = NO;
    [buttonView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(button.currentImage.size);
        make.top.equalTo(button.superview);
        make.left.right.equalTo(button.superview);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    titleLabel.textColor = HEX_COLOR(0xcfcfcf);
    [buttonView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(TRANSFER_SIZE(7.0));
        make.centerX.equalTo(titleLabel.superview);
        make.bottom.equalTo(titleLabel.superview);
    }];
    
    return buttonView;
}


- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        for (int i = 0; i < self.buttonViews.count; i++) {
            UIView *buttonView = self.buttonViews[i];
            [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(buttonView.superview);
                make.left.equalTo(buttonView.superview).offset(TRANSFER_SIZE(20.0) + i *TRANSFER_SIZE(80.0));
            }];
        }
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Touch Event

- (void)extensionBtnPressed:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(chatExtensionView:extensionButtonPressed:)]) {
        [self.delegate chatExtensionView:self extensionButtonPressed:button.tag];
    }
}
@end
