//
//  CSDiscoveryCollectionCell.m
//  CloudSong
//
//  Created by EThank on 15/6/12.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSDiscoveryCollectionCell.h"
#import "UIImage+Extension.h"
#import "CSRecordsModel.h"
#import <UIImageView+WebCache.h>
#import "CSDefine.h"


@interface CSDiscoveryCollectionCell ()

/** 封面大图 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/** 用户名称 */
@property (weak, nonatomic) IBOutlet UILabel *userName;
/** 歌曲名称 */
@property (weak, nonatomic) IBOutlet UILabel *songName;
/** 底部半透明视图 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/*  用户等级  */
@property (weak, nonatomic) IBOutlet UIImageView *gradeView;

@end

@implementation CSDiscoveryCollectionCell

- (void)awakeFromNib
{
    // 初始化    
    // 设置半透明
    self.bottomView.backgroundColor = WhiteColor_Alpha_4 ;
    
    // 头像圆形裁切
    self.headImage.layer.masksToBounds = YES ;
//    self.headImage.layer.cornerRadius = 15.f;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2;
    self.coverImage.layer.masksToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ; 
}

#pragma mark - 重写set方法设置数据
- (void)setRecordsData:(CSRecordsModel *)recordsData
{
    _recordsData = recordsData ;
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:recordsData.musicPhotoUrl]   placeholderImage:[UIImage imageNamed:@"find_deflaut_bg"]] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:recordsData.avatarUrl]] ;
    self.userName.text = recordsData.userNickName ;
    self.songName.text = recordsData.musicName ;
    self.favoriteCount.text = recordsData.praiseCount ;
    self.listenedCount.text = recordsData.listenCount ;
    [self assignmentUserLevel:recordsData.userLevel];
}
- (void)assignmentUserLevel:(NSString *)userLevel
{
    NSString * imgStr = nil;
    if ([userLevel isEqualToString:@"0"]) {

    }else if ([userLevel isEqualToString:@"1"]){
        imgStr = @"home_level1_icon";
    }else if ([userLevel isEqualToString:@"2"]){
        imgStr = @"home_level2_icon";
    }else if ([userLevel isEqualToString:@"3"]){
        imgStr = @"home_level3_icon";
    }else if ([userLevel isEqualToString:@"4"]){
        imgStr = @"home_level4_icon";
    }else if ([userLevel isEqualToString:@"5"]){
        imgStr = @"home_level5_icon";
    }else if ([userLevel isEqualToString:@"6"]){
        imgStr = @"home_level6_icon";
    }else if ([userLevel isEqualToString:@"7"]){
        imgStr = @"home_level7_icon";
    }else if ([userLevel isEqualToString:@"8"]){
        imgStr = @"home_level8_icon";
    }else if ([userLevel isEqualToString:@"9"]){
        imgStr = @"home_level9_icon";
    }else if ([userLevel isEqualToString:@"10"]){
        imgStr = @"home_level10_icon";
    }
    self.gradeView.image = [UIImage imageNamed:imgStr];
}
@end
