//
//  CSMusicStateView.m
//  CloudSong
//
//  Created by sen on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMusicStateView.h"
#import <Masonry.h>
#import "CSDefine.h"


@interface CSMusicStateView ()
@property(nonatomic, weak) UIView *container;
@property(nonatomic, weak) UIButton *textLabel;
@property(nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation CSMusicStateView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Setup
- (void)setupSubviews
{
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    _container = container;
    
    UIButton *textLabel = [[UIButton alloc] init];
    [textLabel setImage:[[UIImage imageNamed:@"room_music_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    textLabel.titleLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(12.0)];
//    textLabel.textColor = HEX_COLOR(0xbcbbc2);
    [textLabel setTitleColor:HEX_COLOR(0xbcbbc2) forState:UIControlStateNormal];
    [container addSubview:textLabel];
    _textLabel = textLabel;
}


#pragma mark - Inherit
- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container.superview);
            make.height.equalTo(_container.superview);
        }];
        
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_textLabel.superview).offset(TRANSFER_SIZE(10.0));
//            make.width.equalTo(_textLabel.superview);
            make.right.equalTo(_textLabel.superview).offset(-TRANSFER_SIZE(10.0));
            make.centerY.equalTo(_textLabel.superview);
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)startAnimation
{

    if ([[_textLabel.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"当前暂无歌曲"]) {
        [_textLabel.layer removeAnimationForKey:@"reScroll"];
        return;
    }
    
    [_textLabel.layer removeAnimationForKey:@"reScroll"];
    
    [self layoutIfNeeded];
    // 如果宽度>标题容器宽度,则不做滚动
//    if (ABS((self.width - _container.width)) < 0.0) return;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position.x";
    // 需要移动的距离
    CGFloat offset = - (_container.bounds.size.width - self.bounds.size.width);
    // 距离中点的距离
    CGFloat x = _container.bounds.size.width * 0.5;
    anim.duration = ABS( -offset * 0.2);
    anim.values = @[[NSNumber numberWithFloat:x],[NSNumber numberWithFloat:offset + x],[NSNumber numberWithFloat:x]];
    anim.repeatCount = MAXFLOAT;
    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //    anim.removedOnCompletion=NO;
    //    anim.fillMode=kCAFillModeForwards;
    [_textLabel.layer addAnimation:anim forKey:@"reScroll"];
}

- (void)setText:(NSString *)text
{
    _text = [NSString stringWithFormat:@"   %@",text];
    [_textLabel setTitle:_text forState:UIControlStateNormal];
    
    
    [self startAnimation];
}

@end
