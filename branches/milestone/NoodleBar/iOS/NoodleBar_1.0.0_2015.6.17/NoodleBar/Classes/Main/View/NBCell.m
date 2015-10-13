//
//  NBCell.m
//  NoodleBar
//
//  Created by sen on 15/4/17.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCell.h"
#import "NBCommon.h"
#define MARGIN 12.5f
@interface NBCell()
/**
 *  左侧图
 */
@property(nonatomic, weak) UIImageView *imageView;
/**
 *  文本
 */
@property(nonatomic, weak) UILabel *textLabel;
/**
 *  底部分割线
 */
@property(nonatomic, weak) UIView *bottomDivider;

/**
 *  文本左边距
 */
@property(nonatomic, weak) NSLayoutConstraint *textLabelLeftConstraint;
@end


@implementation NBCell
#pragma mark - lazyload
- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        UILabel *textLabel = [UILabel newAutoLayoutView];
        textLabel.numberOfLines = 0;
        textLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 50;
        [self addSubview:textLabel];
        _textLabelLeftConstraint = [textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageView withOffset:10.f];
        [textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        _textLabel = textLabel;
    }
    return _textLabel;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bottomDivider = [UIView newAutoLayoutView];
        bottomDivider.hidden = YES;
        [self addSubview:bottomDivider];
        bottomDivider.backgroundColor = HEX_COLOR(0xe9e9e9);
        [bottomDivider autoSetDimension:ALDimensionHeight toSize:.5f];
        [bottomDivider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, MARGIN, 0, MARGIN) excludingEdge:ALEdgeTop];
        _bottomDivider = bottomDivider;
        
        // 添加手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)setText:(NSString *)text withColor:(UIColor *)color Font:(UIFont *)font
{
    if (color) {
        self.textLabel.textColor = color;
    }
    if (font) {
        self.textLabel.font = font;
    }
    self.textLabel.text = text;
}

- (void)setText:(NSString *)text
{
    if (text) {
        self.textLabel.text = text;
    }
}

- (NSString *)text
{
    return self.textLabel.text;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView autoSetDimensionsToSize:self.imageView.image.size];
    [self.imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:MARGIN];
}

#pragma mark - public
- (void)setShowBottomDivider:(BOOL)showBottomDivider
{
    _showBottomDivider = showBottomDivider;
    _bottomDivider.hidden = !showBottomDivider;
    
}

- (void)setTextCenterHorizontally:(BOOL)textCenterHorizontally
{
    if (textCenterHorizontally) {
        [_textLabel removeConstraint:_textLabelLeftConstraint];
        [_textLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }
}

- (void)tap
{
    if (_option) {
        self.option();
    }
}

@end
