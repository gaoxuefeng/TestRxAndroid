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
#import "CSHomeActivityTagModel.h"
#import <UIImageView+WebCache.h>

#define BTN_WIDTH TRANSFER_SIZE(TRANSFER_SIZE(50))
#define BTN_HEIGHT  TRANSFER_SIZE(TRANSFER_SIZE(50))

#define HEIGHT_WIDTH_RADIO (92.0/147.0) // 活动标签高宽比
#define TAG_COUNT 4

@interface CSHomeActivityView ()
/** 全国活动按钮 */
//@property (nonatomic, weak) CSHomeBtnView *nationalActBtn ;
///** 精品活动按钮 */
//@property (nonatomic, weak) CSHomeBtnView *boutiqueActBtn ;
///** 热门活动按钮 */
//@property (nonatomic, weak) CSHomeBtnView *hotActBtn ;

//@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;

@end


@implementation CSHomeActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self ;
}


- (void)setActivityTags:(NSArray *)activityTags{
    _activityTags = activityTags ;
    
    [self setupSubviews] ;
}

- (void)setupSubviews{

    CGFloat padding = TRANSFER_SIZE(5) ;
    CGFloat tagViewW = (SCREENWIDTH - (padding * (TAG_COUNT + 1))) / TAG_COUNT ;
    CGFloat tagViewH = tagViewW * HEIGHT_WIDTH_RADIO ;

                        
    for (int i = 0; i < _activityTags.count; i++) {
        CSHomeActivityTagModel *tagModel = _activityTags[i] ;
        UIImageView *tagView = [[UIImageView alloc] init] ;
        tagView.tag = i ;
        tagView.frame = CGRectMake(padding*(i+1) + tagViewW*i, padding, tagViewW, tagViewH) ;
        tagView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActivityTap:)] ;
        [tagView addGestureRecognizer:tapGesture] ;
        NSString *iconPath = tagModel.iconPath ;
        [tagView sd_setImageWithURL:[NSURL URLWithString:iconPath]] ;
        [self addSubview:tagView] ;
    }
    /** 1.全国活动按钮 */
//    CSHomeBtnView *nationalActBtn = [[CSHomeBtnView alloc] init] ;
//    [nationalActBtn setImageviewName:@"home_nationwide_btn" andLableName:@"全国活动"] ;
//    // 添加轻触手势
//    UITapGestureRecognizer *nationalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nationalTap)] ;
//    [nationalActBtn addGestureRecognizer:nationalTap] ;
//    [self addSubview:nationalActBtn] ;
//    self.nationalActBtn = nationalActBtn ;
    

}
- (void)tapActivityTap:(UIGestureRecognizer *)tapActivityTag{
    UIImageView *tagView = (UIImageView *)tapActivityTag.view ;
    CSLog(@"tapActivityTap.....tag = %ld", (long)tagView.tag) ;
    if ([self.delegate respondsToSelector:@selector(homeActivityView:didTapViewWithIndex:)]) {
        [self.delegate homeActivityView:self didTapViewWithIndex:tagView.tag] ;
    }
}

//- (void)updateConstraints{
//    if (![self isSetupConstaint]) {
//        
//        WS(ws) ;
//        CGFloat leftRightSpace = TRANSFER_SIZE(44) ;
//        
//        // 1.全国活动按钮约束
//        [_nationalActBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(ws).offset(leftRightSpace) ;
//            make.top.equalTo(ws);
//            make.bottom.equalTo(ws);
//            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT)) ;
//        }] ;
//
//        // 2. 精品活动按钮约束
//        [_boutiqueActBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.center.equalTo(ws) ;
//            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT )) ;
//        }] ;
//
//        // 3. 热门活动按钮约束
//        [_hotActBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(ws.mas_right).offset(-TRANSFER_SIZE(44)) ;
//            make.top.equalTo(ws);
//            make.bottom.equalTo(ws);
//            make.size.mas_equalTo(CGSizeMake(BTN_WIDTH, BTN_HEIGHT)) ;
//
//        }] ;
//        self.setupConstraint = YES ;
//    }
//    [super updateConstraints] ;
//}



@end
