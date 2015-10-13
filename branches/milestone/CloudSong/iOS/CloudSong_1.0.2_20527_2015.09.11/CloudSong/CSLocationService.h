//
//  CSLocationService.h
//  CloudSong
//
//  Created by youmingtaizi on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CSLocationServiceDelegate;

@interface CSLocationService : NSObject
+ (instancetype)sharedInstance;
- (void)addDelegate:(id<CSLocationServiceDelegate>)delegate;
- (void)removeDelegate:(id<CSLocationServiceDelegate>)delegate;
- (void)startGetLocation;
- (void)getCityWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end

@protocol CSLocationServiceDelegate <NSObject>
- (void)locationService:(CSLocationService *)svc didGetCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)locationService:(CSLocationService *)svc didLocationInCity:(NSString *)city;
@end