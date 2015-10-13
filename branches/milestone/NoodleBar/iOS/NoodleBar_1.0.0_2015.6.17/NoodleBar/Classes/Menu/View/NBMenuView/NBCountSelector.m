//
//  NBCountSelector.m
//  NoodleBar
//
//  Created by TechSen on 15/4/9.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCountSelector.h"
#import "NBCommon.h"
#import "NBButton.h"
#define ANIMATION_DURATION .15f

//// 按钮直径
//#define BUTTON_DIAMETER 30.f

typedef enum{
    MinusButtonAnimationTypeShow,
    MinusButtonAnimationTypeHidden
    
}MinusButtonAnimationType;



@interface NBCountSelector ()
/**
 *  减法按钮
 */
@property(nonatomic,weak) NBButton *minusButton;
/**
 *  加法按钮
 */
@property(nonatomic,weak) NBButton *plusButton;
/**
 *  数量Label
 */
@property(nonatomic,weak) UILabel *amountLabel;
/**
 *  是否正在动画
 */
@property(nonatomic, assign) BOOL isAnimation;
/**
 *  数量
 */
@property(nonatomic, assign) int count;

@property(nonatomic, assign) MinusButtonAnimationType type;


@end

@implementation NBCountSelector


#pragma mark - setter
- (void)setCount:(int)count
{
    _count = count;
    _amountLabel.hidden = !_count;
    _minusButton.hidden = !_count;
    _amountLabel.text = [NSString stringWithFormat:@"%d",count];
    
}

- (void)setAmount:(int)amount
{
    _amount = amount;
    self.count = amount;
    // 如果数量不为0,则显示减号按钮和数量Label 否则隐藏
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

/**
 *  创建子控件
 */
- (void)setupSubViews
{
    NBButton *minusButton = [NBButton newAutoLayoutView];
    [minusButton setImage:[UIImage imageNamed:@"menu_minus_button"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    minusButton.hidden = YES;
    [self addSubview:minusButton];
    // 固定尺寸为图片尺寸
//    [minusButton autoSetDimensionsToSize:minusButton.currentImage.size];
    [minusButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    [minusButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:minusButton];
    // 紧贴左边
    [minusButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [minusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    _minusButton = minusButton;
    
    // 数量Label
    UILabel *amountLabel = [UILabel newAutoLayoutView];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = [UIFont systemFontOfSize:12];
    amountLabel.hidden = YES;
    [self addSubview:amountLabel];
    [amountLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [amountLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _amountLabel = amountLabel;
    
    // 加法按钮
    NBButton *plusButton = [NBButton newAutoLayoutView];
    
    [self addSubview:plusButton];
    [plusButton setImage:[UIImage imageNamed:@"menu_plus_button"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 固定尺寸为图片尺寸
//    [plusButton autoSetDimensionsToSize:plusButton.currentImage.size];
    [plusButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    [plusButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:plusButton];
    // 紧贴右边
    [plusButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    _plusButton = plusButton;
}

- (void)plusBtnOnClick:(NBButton *)button
{
    self.count += 1;
    [self countChangeByClickButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:MENU_CATEGORY_DETAIL_PLUS_ON_CLICK object:nil userInfo:@{@"info":button}];
}

- (void)minusBtnOnClick:(NBButton *)button
{
    if (_count == 1) {
        // 数量隐藏
        _amountLabel.hidden = YES;
    }
    self.count -= 1;
    [self countChangeByClickButton];
}

- (void)countChangeByClickButton
{
    if ([self.delegate respondsToSelector:@selector(countSelector:DidClickBtnToChangeCount:)]) {
        [self.delegate countSelector:self DidClickBtnToChangeCount:_count];
    }
    
}

///**
// *  显示减号按钮
// *
// *  @param animated 是否动画
// */
//- (void)showMinusButtonWithAnimated:(BOOL)animated
//{
//    _isAnimation = animated;
//    _minusButton.hidden = NO;
//    _amountLabel.hidden = NO;
//    if (animated) { // 需要动画
//        [self minusButtonAimationWithType:MinusButtonAnimationTypeShow];
//        return;
//    }
//}
//
///**
// *  隐藏减号按钮
// *
// *  @param animated 是否动画
// */
//- (void)hiddenMinusButtonWithAnimated:(BOOL)animated
//{
//    _isAnimation = animated;
//    _amountLabel.hidden = YES;
//    if (animated) { // 需要动画
//        [self minusButtonAimationWithType:MinusButtonAnimationTypeHidden];
//        return;
//    }
//    // 不需要动画
//    _minusButton.x = self.width - _minusButton.width;
//}
//
//
//// 执行减号按钮动画
//- (void)minusButtonAimationWithType:(MinusButtonAnimationType)type
//{
//    CGAffineTransform transform;
//    // 如果是显示动画
//    if (type == MinusButtonAnimationTypeShow) {
//        transform = CGAffineTransformMakeRotation(M_PI);
//    }else // 隐藏动画
//    {
//        transform = CGAffineTransformIdentity;;
//    }
//    // 执行动画
//    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//        [self layoutIfNeeded];
//        _minusButton.transform = transform;
//    } completion:^(BOOL finished) {
//        _minusButton.hidden = type;
//        _isAnimation = NO;
//    }];}
@end
