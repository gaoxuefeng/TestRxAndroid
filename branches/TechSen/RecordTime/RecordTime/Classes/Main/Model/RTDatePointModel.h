//
//  RTDatePointModel.h
//  RecordTime
//
//  Created by sen on 9/5/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RTDatePointType) {
    RTDatePointTypeEnterCompany = 1 <<  0,         // 进入公司区域
    RTDatePointTypeExitCompany  = 1 <<  1,         // 离开公司区域
    RTDatePointTypeEnterHome    = 1 <<  2,         // 进入家区域
    RTDatePointTypeExitHome     = 2 <<  3          // 离开家区域
};
@interface RTDatePointModel : NSObject

@property(strong, nonatomic) NSDate *date;

@property(assign, nonatomic) RTDatePointType dateType;

@end
