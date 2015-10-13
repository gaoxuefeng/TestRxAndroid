//
//  NBCartListHeaderView.m
//  NoodleBar
//
//  Created by sen on 15/4/15.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBCartListHeaderView.h"
#import "NBCommon.h"

@interface NBCartListHeaderView ()
@property(nonatomic, weak) UIButton *cleanAllDishesButton;
@property(nonatomic, weak) UIImageView *bgImageView;

@end

@implementation NBCartListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UICOLOR_FROM_HEX(0xdfe0e1);
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 背景图
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [[UIImage imageNamed:@"menu_cart_headerView_bg"] resizedImage];
    [self addSubview:bgImageView];
    _bgImageView = bgImageView;


    // 分割线
    UIView *divider = [UIView newAutoLayoutView];
    divider.backgroundColor = HEX_COLOR(0xa5a5a5);
    [self addSubview:divider];
    [divider autoSetDimension:ALDimensionHeight toSize:.5f];
    [divider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    // 标题
    UILabel *selectMenuTitle = [UILabel newAutoLayoutView];
    selectMenuTitle.numberOfLines = 1;
    selectMenuTitle.text = @"已选菜单";
    [self addSubview:selectMenuTitle];
    selectMenuTitle.textColor = HEX_COLOR(0x444444);
    selectMenuTitle.font = [UIFont systemFontOfSize:13.f];
    [selectMenuTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.f];
    [selectMenuTitle autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 清空按钮
    UIButton *cleanAllDishesButton = [UIButton newAutoLayoutView];
    [self addSubview:cleanAllDishesButton];
    [cleanAllDishesButton setTitle:@"清空购物车" forState:UIControlStateNormal];
    [cleanAllDishesButton setTitleColor:HEX_COLOR(0x444444) forState:UIControlStateNormal];
    [cleanAllDishesButton setImage:[UIImage imageNamed:@"menu_cart_dustbin"] forState:UIControlStateNormal];
    cleanAllDishesButton.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    cleanAllDishesButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [cleanAllDishesButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 10.f) excludingEdge:ALEdgeLeft];
    _cleanAllDishesButton = cleanAllDishesButton;
}

- (void)cleanAllBtnaddTarget:(id)target action:(SEL)sel
{
    [_cleanAllDishesButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat bgImageViewW = self.width;
    CGFloat bgImageViewH = _bgImageView.image.size.height;
    CGFloat bgImageViewX = 0;
    CGFloat bgImageViewY = self.height - bgImageViewH;
    _bgImageView.frame = CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH);
}



@end
