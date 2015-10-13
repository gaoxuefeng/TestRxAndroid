//
//  CSMapPaoPaoView.m
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSMapPaoPaoView.h"
#import "UIImage+Extension.h"
#import "NSString+Extension.h"
#import "CSDefine.h"

@interface CSMapPaoPaoView ()
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UILabel *addressLabel;
@property(nonatomic, weak) UIButton *navButton;
@property(nonatomic, weak) UIImageView *backgroundImageView;
@property(nonatomic, weak) UIImageView *backgroundBottomView;
@property(nonatomic, copy) NSString *ktvName;
@property(nonatomic, copy) NSString *address;

@end

@implementation CSMapPaoPaoView


- (instancetype)initWithKTVName:(NSString *)ktvName address:(NSString *)address
{
    _ktvName = ktvName;
    _address = address;
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"map_black_bg"] resizedImage]];
    
    // 背景三角
    UIImageView *backgroundBottomView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"map_black_tri_bg"] resizedImage]];

    

    // ktv名
    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.numberOfLines = 0;
    nameLabel.text = _ktvName;
    nameLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(16.0)];
    nameLabel.textColor = HEX_COLOR(0xffffff);

    // ktv地址
    UILabel *addressLabel = [[UILabel alloc] init];
//    addressLabel.numberOfLines = 0;
    addressLabel.text = _address;
    addressLabel.font = [UIFont systemFontOfSize:TRANSFER_SIZE(11.0)];
    addressLabel.textColor = HEX_COLOR(0xffffff);

    // 导航按钮
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setBackgroundImage:[UIImage imageNamed:@"map_navigation_icon"] forState:UIControlStateNormal];
    
    
    [self addSubview:backgroundImageView];
    [self addSubview:backgroundBottomView];
    [self addSubview:nameLabel];
    [self addSubview:addressLabel];
    [self addSubview:navButton];

    _nameLabel = nameLabel;
    _backgroundImageView = backgroundImageView;
    _backgroundBottomView = backgroundBottomView;
    _addressLabel = addressLabel;
    _navButton = navButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize nameSize = [NSString sizeWithString:_nameLabel.text font:_nameLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize addressSize = [NSString sizeWithString:_addressLabel.text font:_addressLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    // 店名
    CGFloat nameLabelW = MIN(TRANSFER_SIZE(150.0), nameSize.width);
    CGFloat nameLabelH = TRANSFER_SIZE(20.0);
    CGFloat nameLabelX = TRANSFER_SIZE(13.0);
    CGFloat nameLabelY = TRANSFER_SIZE(12.0);
    _nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);

    // 地址
    CGFloat addressLabelW = MIN(TRANSFER_SIZE(150.0), addressSize.width);
    CGFloat addressLabelH = TRANSFER_SIZE(17.0);
    CGFloat addressLabelX = TRANSFER_SIZE(13.0);
    CGFloat addressLabelY = CGRectGetMaxY(_nameLabel.frame) + TRANSFER_SIZE(5.0);
    _addressLabel.frame = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
    
    self.height = CGRectGetMaxY(_addressLabel.frame) + TRANSFER_SIZE(9.0) + _backgroundBottomView.image.size.height;
    
    // 导航按钮
    CGFloat navButtonW = _navButton.currentBackgroundImage.size.width;
    CGFloat navButtonH = _navButton.currentBackgroundImage.size.height;
    CGFloat navButtonX = MAX(nameLabelW, addressLabelW) + TRANSFER_SIZE(12.0);
    CGFloat navButtonY = (self.height - _backgroundBottomView.image.size.height - navButtonH) * 0.5;
    _navButton.frame = CGRectMake(navButtonX, navButtonY, navButtonW, navButtonH);
    
    self.width = CGRectGetMaxX(_navButton.frame) + TRANSFER_SIZE(11.0);
    
    CGFloat backgroundImageViewW = self.width;
    CGFloat backgroundImageViewH = self.height - _backgroundBottomView.image.size.height;
    CGFloat backgroundImageViewX = 0;
    CGFloat backgroundImageViewY = 0;
    _backgroundImageView.frame = CGRectMake(backgroundImageViewX, backgroundImageViewY, backgroundImageViewW, backgroundImageViewH);
    
    CGFloat backgroundBottomViewW = _backgroundBottomView.image.size.width;
    CGFloat backgroundBottomViewH = _backgroundBottomView.image.size.height;
    CGFloat backgroundBottomViewX = (self.width - backgroundBottomViewW) * 0.5;
    CGFloat backgroundBottomViewY = CGRectGetMaxY(_backgroundImageView.frame);
    _backgroundBottomView.frame = CGRectMake(backgroundBottomViewX, backgroundBottomViewY, backgroundBottomViewW, backgroundBottomViewH);
    
}

#pragma mark - Public Methods
- (void)addTareget:(id)target action:(SEL)action;
{
    [_navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}




@end
