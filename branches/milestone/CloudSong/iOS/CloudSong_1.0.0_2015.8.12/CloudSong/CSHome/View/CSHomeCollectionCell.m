//
//  CSHomeCollectionCell.m
//  CloudSong
//
//  Created by EThank on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSHomeCollectionCell.h"
#import <Masonry.h>
#import "CSDefine.h"
#import "CSHomeActivityModel.h"
#import <UIImageView+WebCache.h>

#define ACT_TYPE_FONT [UIFont systemFontOfSize:11] 
#define ACT_THEME_FONT [UIFont systemFontOfSize:13]

// 定义一些颜色
/** 红色 */
#define Red_Color [UIColor colorWithRed:228/255.0 green:58/255.0 blue:90/255.0 alpha:1]
/** 绿色 */
#define Green_Color [UIColor colorWithRed:58/255.0 green:176/255.0 blue:131/255.0 alpha:1]
/** 橙色 */
#define Orange_Color [UIColor colorWithRed:234/255.0 green:115/255.0 blue:90/255.0 alpha:1]
/** 紫色 */
#define Purple_Color [UIColor colorWithRed:152/255.0 green:65/255.0 blue:222/255.0 alpha:1]
/** 黄色 */
#define Yellow_Color [UIColor colorWithRed:222/255.0 green:156/255.0 blue:15/255.0 alpha:1]
/** 鲜红 */
#define NewRed_Color [UIColor colorWithRed:251/255.0 green:0/255.0 blue:156/255.0 alpha:1]

@interface CSHomeCollectionCell ()

/** 活动类型label */
@property (nonatomic, weak) UILabel *actTypeLabel ;
/** 活动主题label */
@property (nonatomic, weak) UILabel *themeLabel ;
/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImage ;
/** 等级视图 */
@property (nonatomic, weak) UIImageView *gradeImage ;

@property (nonatomic, assign, getter=isSetupConstaint) BOOL setupConstraint ;

/** 随机颜色 */
@property (nonatomic, strong) NSMutableArray *colorArray ;
/** 等级类型 */
@property (nonatomic, strong) NSMutableArray *gradeArray ;
@end

@implementation CSHomeCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews] ;
    }
    return  self ;
}

#pragma mark - Lazy Load
- (NSMutableArray *)colorArray{
    if (_colorArray == nil) {
        _colorArray = [NSMutableArray arrayWithObjects:Red_Color, Green_Color, Orange_Color, Purple_Color, Yellow_Color, NewRed_Color, nil] ;
    }
    return _colorArray ;
}
- (NSMutableArray *)gradeArray{
    if (!_gradeArray) {
        _gradeArray = [NSMutableArray arrayWithObjects:@"home_diamond_icon", @"home_level8_icon", @"home_star_icon", @"home_supercrown_icon", nil] ;
    }
    return _gradeArray ;
}
- (void)setupSubviews{
    
    // 0.封面图片
    UIImageView *coverImage = [[UIImageView alloc] init] ;
    coverImage.image = [UIImage imageNamed:@"home_defaultimg_bg"] ;
    [self.contentView addSubview:coverImage] ;
    coverImage.contentMode = UIViewContentModeScaleAspectFill;
    coverImage.layer.masksToBounds = YES;
    self.coverImage = coverImage ;
    
    // 1. 活动类型label
    UILabel *actTypeLabel = [[UILabel alloc] init] ;
    actTypeLabel.text = @"生日" ;
    actTypeLabel.layer.masksToBounds = YES ;
    actTypeLabel.layer.cornerRadius = 1.0 ;
    actTypeLabel.textAlignment = NSTextAlignmentCenter ;
    actTypeLabel.font = ACT_TYPE_FONT;
    actTypeLabel.backgroundColor = [UIColor redColor] ;
    [self.contentView addSubview:actTypeLabel] ;
    self.actTypeLabel = actTypeLabel ;
    
    // 2.活动主题
    UILabel *themeLabel = [[UILabel alloc] init] ;
    themeLabel.text = @"一起高呼！" ;
    themeLabel.font = ACT_THEME_FONT ;
    themeLabel.textColor = [UIColor whiteColor] ;
    [self.contentView addSubview:themeLabel] ;
    self.themeLabel = themeLabel ;
    
    // 4. 等级视图
    UIImageView *gradeImage = [[UIImageView alloc] init] ;
    gradeImage.image = [UIImage imageNamed:nil] ;
    [self.contentView addSubview:gradeImage] ;
    self.gradeImage = gradeImage ;
    
    [self updateConstraintsIfNeeded];
}

#pragma mark - 更新约束
- (void)updateConstraints{
    
    if (![self isSetupConstaint]) {
        
        WS(ws) ;
        // 1. 封面图片约束
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.contentView) ;
        }] ;

        // 2.活动类型
        [_actTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(TRANSFER_SIZE(9)) ;
            make.top.equalTo(ws.contentView).offset(TRANSFER_SIZE(65)) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(33), TRANSFER_SIZE(13))) ;
        }] ;
        
        // 3. 等级视图布局
        [_gradeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(ws.contentView).offset(-TRANSFER_SIZE(5)) ;
            make.top.equalTo(_themeLabel.mas_top) ;
            make.size.mas_equalTo(CGSizeMake(TRANSFER_SIZE(15), TRANSFER_SIZE(15))) ;
        }] ;
        
        // 4.活动主题布局
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(TRANSFER_SIZE(9)) ;
            make.top.equalTo(_actTypeLabel.mas_bottom).offset(5) ;
            make.right.equalTo(ws.contentView.mas_right) ;
        }] ;
        
        self.setupConstraint = YES ;
    }
    [super updateConstraints] ;
}

- (void)setActivityModel:(CSHomeActivityModel *)activityModel{
    _activityModel = activityModel ;
    
    self.themeLabel.text = activityModel.activityTheme ;
    self.actTypeLabel.text = activityModel.activityTag ;
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:activityModel.activityImageUrl] placeholderImage:[UIImage imageNamed:@"home_defaultimg_bg"]];
    
    // 设置活动类型label的颜色 activityId 从1开始
    int typeIndex = [activityModel.activityId intValue]  % self.colorArray.count ;
    self.actTypeLabel.backgroundColor = self.colorArray[typeIndex] ;
//    int gradeIndex = [activityModel.activityId intValue] % self.gradeArray.count ;
//    self.gradeImage.image = [UIImage imageNamed:self.gradeArray[gradeIndex]] ;
}
@end
