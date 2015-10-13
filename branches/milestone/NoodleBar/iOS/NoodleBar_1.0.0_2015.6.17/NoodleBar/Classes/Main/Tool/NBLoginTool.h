//
//  NBLoginTool.h
//  NoodleBar
//
//  Created by sen on 15/4/28.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBLoginTool : NSObject
/**
 *  用于判断是否为手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return 返回是或否
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)idfa;
@end
