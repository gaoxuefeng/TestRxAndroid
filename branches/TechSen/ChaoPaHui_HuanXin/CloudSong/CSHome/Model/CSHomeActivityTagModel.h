//
//  CSHomeActivityTagModel.h
//  CloudSong
//
//  Created by EThank on 15/8/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHomeActivityTagModel : NSObject
/** 标签icon */
@property (nonatomic, copy) NSString *iconPath ;
/** 标签名 */
@property (nonatomic, copy) NSString *name ;
/** 请求路径 */
@property (nonatomic, copy) NSString *requestUrl ;
//@property (nonatomic, copy) NSString *type ;

@property (nonatomic, copy) NSNumber *activityType ;

@end
