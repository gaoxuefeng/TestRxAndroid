//
//  NBCartView.m
//  NoodleBar
//
//  Created by sen on 15/4/14.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCartView.h"
#import "NBCommon.h"
#import "NBCartTool.h"
#import "NBToPayView.h"
#import "NBCartListView.h"
#define MAX_DISPLAY_ROW 5

#define DEFAULT_CART_INSET (-9.f)


@interface NBCartView()
/**
 *  支付区域
 */
@property(nonatomic, weak) NBToPayView *toPayView;

/**
 *  购物车图标距离顶部约束
 */
@property(nonatomic, weak) NSLayoutConstraint *cartTopConstraint;
/**
 *  蒙版
 */
@property(nonatomic, weak) UIButton *cover;
/**
 *  是否展开
 */
@property(nonatomic, assign,getter=isShowing) BOOL showing;
/**
 *  购物车列表高度约束
 */
@property(nonatomic, weak) NSLayoutConstraint *cartListHeightConstraint;

@end

@implementation NBCartView

#pragma mark - lazyLoad
- (UIButton *)cover
{
    if (!_cover) {
        UIButton *cover = [UIButton newAutoLayoutView];
        [cover addTarget:self action:@selector(cartShow:) forControlEvents:UIControlEventTouchUpInside];
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = .0f;
        [self.superview insertSubview:cover belowSubview:self];
        [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, CART_VIEW_HEIGHT, 0)];
        _cover = cover;
    }
    return _cover;
}



#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showing = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        [self setupNotification];
    }
    return self;
}

- (void)setupSubViews
{
    // 支付区域
    NBToPayView *toPayView = [NBToPayView newAutoLayoutView];
    [self addSubview:toPayView];
    [toPayView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, CART_VIEW_HEIGHT)];
    [toPayView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [toPayView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _toPayView = toPayView;
    
    // 购物车按钮
    NBCartButton *cartButton = [NBCartButton newAutoLayoutView];
    [self addSubview:cartButton];
    [cartButton addTarget:self action:@selector(cartShow:) forControlEvents:UIControlEventTouchUpInside];
    cartButton.enabled = NO;
    [cartButton autoSetDimensionsToSize:cartButton.currentBackgroundImage.size];
    [cartButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
    _cartTopConstraint = [cartButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:DEFAULT_CART_INSET];
    _cartButton = cartButton;
    
    
    
    // 购物车菜单
    NBCartListView *listView = [NBCartListView newAutoLayoutView];
    [self insertSubview:listView belowSubview:toPayView];
    [listView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    _cartListHeightConstraint = [listView autoSetDimension:ALDimensionHeight toSize:CART_HEADER_HEIGHT];
    [listView cleanAllBtnaddTarget:self Action:@selector(cleanAllBtnOnClick)];
    
}

- (void)setupNotification
{
    // 接收购物车内容变化 用于改变购物车的frame
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartContentChanged) name:CART_CONTENT_CHANGED object:nil];
}

#pragma mark - public
- (void)payButtonAddTarget:(id)target action:(SEL)sel
{
    [_toPayView payButtonAddTarget:target action:sel];
}


#pragma mark - private
/**
 *  购物车内容改变后操作
 */
- (void)cartContentChanged
{
    [_toPayView setPrice:[NBCartTool originalPrice]];
    [NBCartTool dishesPrice];
    _cartButton.enabled = [NBCartTool dishesCount];
    [_cartButton setAmount:[NBCartTool dishesCount]];
    _cartListHeightConstraint.constant = MIN(CART_HEADER_HEIGHT + CART_LIST_CELL_HEIGHT * [NBCartTool dishes].count, CART_HEADER_HEIGHT + CART_LIST_CELL_HEIGHT * MAX_DISPLAY_ROW);
    [self cartShow:nil];
}

- (void)cleanAllBtnOnClick
{
    [NBCartTool emptyShoppingCart];
    [self cartShow:nil];
    // 发出通知  告知购物车操作,刷新列表
    [[NSNotificationCenter defaultCenter] postNotificationName:CART_VIEW_OPERATE object:nil];
}

- (void)cartShow:(NBCartButton *)button
{
    CGFloat alpha = 0.f;
    CGFloat heightConstant = 0.f;
    CGFloat cartTopConstant = 0.f;
    // 如果button为空那么不是通过购物车按钮调整大小
    // 如果处于展开状态下 则不改变_showing值, 如果处于收缩状态 直接return;
    if (!button) {
        if (!_showing) return;
        self.cover.alpha = 0.5f;
        alpha = .5f;
        // 购物车View约束
        heightConstant = _cartListHeightConstraint.constant + CART_VIEW_HEIGHT;
        // 购物车图标约束
        cartTopConstant = -_cartButton.height - 7.f;
        if ([NBCartTool dishes].count == 0) { // 如果为空 则直接执行关闭购物车操作
            _showing = !_showing;
            alpha = 0.f;
            // 购物车View约束
            heightConstant = CART_VIEW_HEIGHT;
            // 购物车图标约束
            cartTopConstant = DEFAULT_CART_INSET;
        }
    }else
    {
        
        if (_showing) { // 即将收缩
            self.cover.alpha = 0.5f;
            alpha = .0f;
            // 购物车View约束
            heightConstant = CART_VIEW_HEIGHT;
            // 购物车图标约束
            cartTopConstant = DEFAULT_CART_INSET;
        }else // 即将展开
        {
            alpha = .5f;
            // 购物车View约束
            heightConstant = _cartListHeightConstraint.constant + CART_VIEW_HEIGHT;
            // 购物车图标约束
            cartTopConstant = -_cartButton.height - 7.f;
        }
        _showing = !_showing;
    }
    
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:.3f animations:^{
        _cartViewHeightConstraint.constant = heightConstant;
        _cartTopConstraint.constant = cartTopConstant;
        [self layoutIfNeeded];
        self.cover.alpha = alpha;
        _toPayView.cartShowing = _showing;
    } completion:^(BOOL finished) {
    }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}

@end
