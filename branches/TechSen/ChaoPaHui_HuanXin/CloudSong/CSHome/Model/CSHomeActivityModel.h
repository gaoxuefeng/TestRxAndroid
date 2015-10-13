//
//  CSHomeActivityModel.h
//  CloudSong
//
//  Created by EThank on 15/7/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHomeActivityModel : NSObject
/**
 *  活动ID
 */
@property (nonatomic, strong) NSNumber *activityId ;
/**
 *  图片地址
 */
@property (nonatomic, copy) NSString   *activityImageUrl ;
/**
 *  点赞个数
 */
@property (nonatomic, strong) NSNumber *activityPraiseCount ;
/**
 *  活动标记(生日，聚会....)
 */
@property (nonatomic, strong) NSString *activityTag ;
/**
 *  主题内容
 */
@property (nonatomic, copy) NSString *activityTheme ;
/**
 *  活动时间
 */
@property (nonatomic, copy) NSString   *activityTime ;
/**
 *  城市名
 */
@property (nonatomic, copy) NSString *cityName ;
/**
 *  公司logo
 */
@property (nonatomic, strong) NSNumber *companyImageUrl ;
/**
 *  H5详情页
 */
@property (nonatomic, copy) NSString *htmlUrl ;

@end
