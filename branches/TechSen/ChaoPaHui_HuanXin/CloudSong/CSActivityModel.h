//
//  CSActivityModel.h
//  CloudSong
//
//  Created by 汪辉 on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSActivityModel : NSObject
@property (nonatomic,copy)NSNumber * activityId;
@property (nonatomic,copy)NSString * activityImageUrl;
@property (nonatomic,copy)NSNumber * activityPraiseCount;
@property (nonatomic,copy)NSString * activityTag;
@property (nonatomic,copy)NSString * activityTheme;
@property (nonatomic,copy)NSString * activityTime;
@property (nonatomic,copy)NSString * cityName;
@property (nonatomic,copy)NSString * companyImageUrl;
@property (nonatomic,copy)NSString * htmlUrl;
@property (nonatomic,copy)NSNumber * tagId;
@property (nonatomic,copy)NSString * tagName;
@property (nonatomic,copy)NSString * activityIcon;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * kTVName;
@property (nonatomic,copy)NSString * distance; //距离
@property (nonatomic,copy)NSString * colorCode;//标签背景色值
@property (nonatomic,copy)NSString * typeImageUrl;//推荐类型图片路径
@property (nonatomic,copy)NSString * uidpass;
@property (nonatomic,copy)NSString * shareTitle;
@end
