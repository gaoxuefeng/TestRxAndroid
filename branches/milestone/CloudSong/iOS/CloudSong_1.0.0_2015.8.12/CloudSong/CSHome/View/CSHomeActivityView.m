//
//  CSHomeActivityView.m
//  CloudSong
//
//  Created by EThank on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeActivityView.h"
#import <Masonry.h>
#import "CSHomeBtnView.h"

#define BTN_WIDTH TRANSFER_SIZE(50)
#define BTN_HEIGHT  TRANSFER_SIZE(80)

@interface CSHomeActivityView ()
/** 全国活动按钮 */
@property (nonatomic, weak) CSHomeBtnView *nationalActBtn ;
/** 精品活动按钮 */
@property (nonatomic, weak) CSHomeBtnView *boutiqueActBtn ;
/** 热门活动按钮 */
@property (nonatomic, weak) CSHomeBtnView *hotActBtn ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;
@end


@implementation CSHomeActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews] ;
    }
    
    return self ;
}

- (void)setupSubviews{
    /** 1.全国活动按钮 */
    CSHomeBtnView *nationalActBtn = [[CSHomeBtnView alloc] init] ;
    [nationalActBtn setImageviewName:@"home_nationwide_btn" andLableName:@"全国活动"] ;
    // 添加轻触手势
    UITapGestureRecognizer *nationalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nationalTap)] ;
    [nationalActBtn addGestureRecognizer:nationalTap] ;
    [self addSubview:nationalActBtn] ;
    self.nationalActBtn = nationalActBtn ;

    /** 2.精品活动按钮 */
    CSHomeBtnView *boutiqueActBtn = [[CSHomeBtnView alloc] init] ;
    UITapGestureRecognizer *boutiqueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boutiqueBtnTap)] ;
    [boutiqueActBtn addGestureRecognizer:boutiqueTap] ;
    [boutiqueActBtn setImageviewName:@"home_fancy_btn" andLableName:@"精品活动"] ;
    [self addSubview:boutiqueActBtn] ;
    self.boutiqueActBtn = boutiqueActBtn ;

    /** 3.热门活动按钮 */
    CSHomeBtnView *hotActBtn = [[CSHomeBtnView alloc] init] ;
    UITapGestureRecognizer *hotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotBtnTap)] ;
    [hotActBtn addGestureRecognizer:hotTap] ;
    [hotActBtn setImageviewName:@"home_hot_btn" andLableName:@"热门活动"] ;
    [self addSubview:hotActBtn] ;
    self.hotActBtn = hotActBtn ;

}

- (void)updateConstraints{
    if (![self isSetupConstaint]) {
        
        WS(ws) ;
        CGFloat leftRightSpace = TRANSFER_SIZE(44) ;
        
        // 1.全国活动按钮约束
        [_nationalActBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws).offset(leftRightSpace) ;
            make.top.equalTo(ws);
            make.bottom.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT)) ;
        }] ;

        // 2. 精品活动按钮约束
        [_boutiqueActBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(ws) ;
            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT)) ;
        }] ;

        // 3. 热门活动按钮约束
        [_hotActBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.mas_right).offset(-TRANSFER_SIZE(44)) ;
            make.top.equalTo(ws);
            make.bottom.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT)) ;

        }] ;
        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
}


#pragma mark - Btn Action
- (void)nationalTap{
    if ([self.delegate respondsToSelector:@selector(homeActivityView:didTapViewWithType:)]) {
        [self.delegate homeActivityView:self didTapViewWithType:CSHomeActivityTypeNational] ;
    }
}

- (void)boutiqueBtnTap{
    if ([self.delegate respondsToSelector:@selector(homeActivityView:didTapViewWithType:)]) {
        [self.delegate homeActivityView:self didTapViewWithType:CSHomeActivityTypeBoutique] ;
    }
}

- (void)hotBtnTap{
    if ([self.delegate respondsToSelector:@selector(homeActivityView:didTapViewWithType:)]) {
    [self.delegate homeActivityView:self didTapViewWithType:CSHomeActivityTypeHot] ;
    }
}


@end
