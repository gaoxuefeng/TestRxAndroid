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

@end

@implementation CSDiscoveryCollectionCell

- (void)awakeFromNib
{
    // 初始化    
    // 设置半透明
    self.bottomView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4] ;
    
    // 头像圆形裁切
    self.headImage.layer.masksToBounds = YES ;
    self.headImage.layer.cornerRadius = self.headImage.bounds.size.width/2 ;
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
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:recordsData.musicPhotoUrl]   placeholderImage:[UIImage imageNamed:@"find_default_img"]] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:recordsData.avatarUrl]  placeholderImage:nil] ;
    self.userName.text = recordsData.userNickName ;
    self.songName.text = recordsData.musicName ;
    self.favoriteCount.text = recordsData.praiseCount ;
    self.listenedCount.text = recordsData.listenCount ;
}

@end
