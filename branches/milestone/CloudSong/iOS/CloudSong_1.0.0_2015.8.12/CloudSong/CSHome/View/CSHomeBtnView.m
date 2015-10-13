//
//  CSHomeBtnView.m
//  CloudSong
//
//  Created by EThank on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeBtnView.h"
#import "CSDefine.h"
#import <Masonry.h>


#define ACTIVITY_BTN_FONT [UIFont systemFontOfSize:12]

@interface CSHomeBtnView ()

@property (nonatomic, weak) UIImageView *iconView ;
@property (nonatomic, weak) UILabel     *actNameLabel ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;

@end

@implementation CSHomeBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconView = [[UIImageView alloc] init] ;
        [self addSubview:iconView ] ;
        self.iconView = iconView ;
        
        UILabel *actNameLabel = [[UILabel alloc] init] ;
        actNameLabel.textAlignment = NSTextAlignmentCenter ;
        actNameLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5] ;
        [self addSubview:actNameLabel] ;
        actNameLabel.font = ACTIVITY_BTN_FONT ;
        self.actNameLabel = actNameLabel ;
    }
    return self ;
}

- (void)updateConstraints{
    if (![self isSetupConstaint]) {
        WS(ws) ;
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(TRANSFER_SIZE(2)) ;
            make.top.equalTo(ws).offset(TRANSFER_SIZE(5)) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(45), TRANSFER_SIZE(45))) ;
        }] ;
        
        [_actNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws) ;
            make.bottom.equalTo(ws) ;
            make.top.equalTo(_iconView.mas_bottom) ;
        }] ;
        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
}

- (void)setImageviewName:(NSString *)imageName andLableName:(NSString *)labelName{
    self.iconView.image = [UIImage imageNamed:imageName] ;
    self.actNameLabel.text = labelName ;
}
@end
