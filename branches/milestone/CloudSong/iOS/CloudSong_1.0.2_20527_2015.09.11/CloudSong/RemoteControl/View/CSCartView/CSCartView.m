//
//  CSCartView.m
//  CloudSong
//
//  Created by sen on 15/5/25.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSCartView.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSToPayBar.h"
#import <FXBlurView.h>
#import "UIImage+Extension.h"
#import "CSDishCartTool.h"
#import "CSToPayBar.h"
#import "CSCartList.h"


@interface CSCartView ()
@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, weak) CSToPayBar *toPayBar;
@property(nonatomic, weak) UIImageView *cover;
@property(nonatomic, weak) CSCartList *cartList;
/** cartTableView高度约束 */
@property(nonatomic, strong) MASConstraint *cartListHeightConstraint;
/** cartTableViewY约束 */
@property(nonatomic, strong) MASConstraint *cartListYConstraint;
@property(nonatomic, strong) MASConstraint *cartButtonYConstraint;
/** 购物车是否展开 */
@property(nonatomic, assign,getter = isCartShowing) BOOL cartShowing;
/** 购物车列表展开时高度 */
@property(nonatomic, assign) CGFloat cartListRowHeight;
@end


@implementation CSCartView

#pragma mark - Lazy Load
- (UIImageView *)cover
{
    if (!_cover) {
        UIImage *superViewImage = [UIImage screenshotWithView:self.superview];
        UIImage *blurSuperViewImage = [superViewImage blurredImageWithRadius:20.0 iterations:10.0 tintColor:[UIColor clearColor]];
        UIImageView *cover = [[UIImageView alloc] initWithImage:blurSuperViewImage];
        cover.userInteractionEnabled = YES;
        cover.alpha = 0.0;
        cover.frame = self.superview.bounds;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartBtnOnClick:)];
        [cover addGestureRecognizer:tapGR];
        [self insertSubview:cover atIndex:0];
        _cover = cover;
    }
    return _cover;
}

- (CGFloat)cartListRowHeight
{
    int rowCount = 0;
    if (iPhone4) {
        rowCount = 4;
    }else if (iPhone6)
    {
        rowCount = 6;
    }else if (iPhone6Plus)
    {
        rowCount = 7;
    }else
    {
        rowCount = 5;
    }
    return ((int)MIN([CSDishCartTool dishes].count, rowCount) * CART_LIST_CELL_HEIGHT + CART_LIST_HEADER_HEIGHT);
}


#pragma mark - Init
- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        //自动将事件传递到上一层
        return nil;
    }
    return hitView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
        [self setupNotification];
    }
    return self;
}

- (void)setCartShowing:(BOOL)cartShowing
{
    _cartShowing = cartShowing;
//    self.toPayBar.cartShowing = _cartShowing;
}

- (void)setupNotification
{
    // 接收购物车内容变化 用于改变购物车的frame
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartContentChanged) name:CART_CONTENT_CHANGED object:nil];
}

- (void)setupSubViews
{
    [self setupCartList];
    [self setupToPayBar];
    [self setupCartButton];
}


- (void)setupToPayBar
{
    CSToPayBar *toPayBar = [[CSToPayBar alloc] init];
    toPayBar.payButtonTitle = @"立即下单";
    _toPayBar = toPayBar;
//    toPayBar.backgroundColor = HEX_COLOR(0x151417);
    [self addSubview:toPayBar];
}

- (void)setupCartButton
{
    CSCartButton *cartButton = [[CSCartButton alloc] init];
    [cartButton addTarget:self action:@selector(cartBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cartButton = cartButton;
    [self addSubview:cartButton];
}

- (void)setupCartList
{
    CSCartList *cartList = [[CSCartList alloc] init];
    _cartList = cartList;
    [self addSubview:cartList];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        [self.cartList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width);
            self.cartListHeightConstraint = make.height.mas_equalTo(CART_LIST_HEADER_HEIGHT);
            self.cartListYConstraint = make.top.equalTo(self.toPayBar);
            make.centerX.equalTo(self);
        }];
        
        [self.toPayBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(TO_PAY_BAR_HEIGHT);
        }];
        
        [self.cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(TRANSFER_SIZE(10.0));
            self.cartButtonYConstraint = make.bottom.equalTo(self).offset(-TRANSFER_SIZE(11.0));
        }];
        
        self.didSetupConstraint = YES;
    }
    [super updateConstraints];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_CONTENT_CHANGED object:nil];
}
#pragma mark - Notification Events
-(void)cartContentChanged
{
    // 购物车图标数量
    [_cartButton setAmount:[CSDishCartTool dishesAmount]];
    
    // 购物车总价
    [_toPayBar setPrice:[CSDishCartTool totalPrice]];
    
//    self.toPayBar.payButton.enabled = ![CSDishCartTool isEmpty];
    if (self.isCartShowing) { // 如果是展开状态
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            // 改变购物车列表高度
            self.cartListHeightConstraint.offset = self.cartListRowHeight;
            // 改变购物车列表的垂直方向的位置
            self.cartListYConstraint.offset = [CSDishCartTool dishes].count?-self.cartListRowHeight:0;
            // 改变购物车按钮垂直方向的位置
            self.cartButtonYConstraint.offset = [CSDishCartTool dishes].count?- (TO_PAY_BAR_HEIGHT + self.cartListRowHeight):-TRANSFER_SIZE(11.0);
            self.cover.alpha = [CSDishCartTool isEmpty]?0.0:1.0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            // 如果购物车清空,则设置购物车不显示
            self.cartShowing = ![CSDishCartTool isEmpty];
            // 如果购物车不展示 清除毛玻璃
            if (!self.cartShowing) {
                [self.cover removeFromSuperview];
                self.toPayBar.cartShowing = self.cartShowing;
            }
        }];
        
    }else // 购物车未展开
    {
        // 改变购物车列表高度
        self.cartListHeightConstraint.offset = self.cartListRowHeight;
    }
}


#pragma mark - Touch Events
/**
 *  购物车按钮点击事件
 */
- (void)cartBtnOnClick:(UIButton *)button
{
    self.cover.hidden = NO;
    self.toPayBar.cartShowing = !self.cartShowing;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = self.isCartShowing?0.0:1.0;
        // 改变购物车列表的垂直方向的位置
        self.cartListYConstraint.offset = self.isCartShowing? 0: - (self.cartListRowHeight);
        [self layoutIfNeeded];
        // 改变购物车按钮垂直方向的位置
        self.cartButtonYConstraint.offset = self.isCartShowing? -TRANSFER_SIZE(11.0): - (TO_PAY_BAR_HEIGHT + self.cartListRowHeight);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.isCartShowing) {
            [self.cover removeFromSuperview];
        }
        // 改变购物车状态
        self.cartShowing = !self.isCartShowing;
    }];
    
}

#pragma mark - Public Methods
/**
 *  支付按钮点击事件
 */
- (void)payButtonAddTarget:(id)target action:(SEL)sel
{
    [_toPayBar payButtonAddTarget:target action:sel];
}
@end
