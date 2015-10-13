//
//  NBLocation.h
//  NoodleBar
//
//  Created by sen on 6/3/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMapKit.h>
@protocol NBLocationDelegate <NSObject>

@optional
/** 获取当前坐标 */
- (void)didGetCurrentLocation:(CLLocationCoordinate2D)location;

/** 获取当前城市 */
- (void)didGetCurrentCity:(NSString *)city;
@end
@interface NBLocation : NSObject
@property(nonatomic, weak) id<NBLocationDelegate> delegate;

@end
