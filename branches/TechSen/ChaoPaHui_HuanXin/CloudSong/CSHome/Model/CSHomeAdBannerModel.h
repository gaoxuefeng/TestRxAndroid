//
//  CSHomeAdBannerModel.h
//  CloudSong
//
//  Created by EThank on 15/8/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHomeAdBannerModel : NSObject

/** H5页面 */
@property (nonatomic, copy) NSString *htmlUrl ;
/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl ;

@property (nonatomic, copy) NSString *shareTitle ;
@property (nonatomic, copy) NSString *shareUrl ;
@property (nonatomic,copy)NSString * uidpass;

@end
