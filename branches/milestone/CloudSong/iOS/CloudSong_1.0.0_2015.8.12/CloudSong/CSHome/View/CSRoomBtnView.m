//
//  CSRoomBtnView.m
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSRoomBtnView.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "GlobalVar.h"

#define ROOM_BTN_FONT [UIFont boldSystemFontOfSize:18]
#define DESC_LABEL_FONT [UIFont systemFontOfSize:13]

@interface CSRoomBtnView ()

/** 进入房间的按钮 */
@property (nonatomic, weak) UIButton *roomBtn ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;

@end

@implementation CSRoomBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews] ;
    }
    
    return self ;
}

- (void)setupSubviews{
    
    // 进入房间Btn
    UIButton *roomBtn = [[UIButton alloc] init] ;
    [roomBtn setTitle:@"加入房间" forState:UIControlStateNormal] ;
    roomBtn.titleLabel.font = ROOM_BTN_FONT;
    roomBtn.hidden = YES ;
    [roomBtn setBackgroundImage:[UIImage imageNamed:@"home_circle_btn"] forState:UIControlStateNormal] ;
    [roomBtn addTarget:self action:@selector(roomBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
    [self addSubview:roomBtn] ;
    self.roomBtn = roomBtn ;
    
    // 描述信息Label
    UILabel *descInfoLabel = [[UILabel alloc] init] ;
    descInfoLabel.text = @"预订房间或扫描歌屏上二维码,就能点歌啦" ;
    descInfoLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9] ;
    descInfoLabel.alpha = 0 ;
    descInfoLabel.font = DESC_LABEL_FONT ;
    [self addSubview:descInfoLabel] ;
    self.descInfoLabel = descInfoLabel ;
    
    [self updateConstraintsIfNeeded] ;
}

- (void)updateConstraints{
    if (![self isSetupConstaint]) {
        
        WS(ws) ;
        // 描述信息Label布局
        [_descInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws).offset(-TRANSFER_SIZE(15)) ;
            make.centerX.mas_equalTo(ws.centerX) ;
        }] ;
        
        // 进入房间Btn布局
        [_roomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_descInfoLabel.mas_top).offset(-TRANSFER_SIZE(10)) ;
            make.centerX.mas_equalTo(ws.centerX) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(110), TRANSFER_SIZE(110))) ;

        }] ;
        
        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
}

// 设置进入房间按钮文字为当前房间号
- (void)setRoomBtnTitle:(NSString *)roomBtnTitle{
    _roomBtnTitle = roomBtnTitle ;
    self.descInfoLabel.text=@"到店后请开启或保持KTV内wifi连接状态";
    [self.roomBtn setTitle:roomBtnTitle forState:UIControlStateNormal] ;
}

#pragma mark - Action Method
- (void)roomBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(roomBtnView:didClickRoomBtn:)]) {
        [self.delegate roomBtnView:self didClickRoomBtn:self.roomBtn] ;
    }
}

- (void)roomBtnViewanimateWithTimeInterval:(NSTimeInterval)interval{
   
    // 进入房间按钮动画
//    [UIView animateWithDuration:interval/3 animations:^{
//        self.roomBtn.alpha = 1 ;
//        self.roomBtn.transform = CGAffineTransformMakeScale(1.25, 1.25) ;
//
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:.5 animations:^{
//            self.roomBtn.transform = CGAffineTransformIdentity ;
//        }] ;
//    }] ;

    self.roomBtn.hidden = NO ;
    CABasicAnimation *roomBtnAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"] ;
    roomBtnAnimation.repeatCount = 1 ;
    roomBtnAnimation.duration = interval / 3.5 ;
    roomBtnAnimation.autoreverses = YES ;
    roomBtnAnimation.fromValue = [NSNumber numberWithFloat:1.0] ;
    roomBtnAnimation.toValue = [NSNumber numberWithFloat:1.25] ;
    [_roomBtn.layer addAnimation:roomBtnAnimation forKey: nil] ; // @"scale-layer"] ;
    
    // 描述信息label动画
    [UIView animateWithDuration:interval
                          delay:0.5
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                                self.descInfoLabel.alpha = 1 ;
    } completion:nil] ;
    
}
@end
