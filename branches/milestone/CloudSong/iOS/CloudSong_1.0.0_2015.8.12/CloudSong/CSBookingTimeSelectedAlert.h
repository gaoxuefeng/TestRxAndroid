//
//  CSBookingTimeSelectedAlert.h
//  CloudSong
//
//  Created by youmingtaizi on 7/23/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSBookingTimeSelectedAlertDelegte;

@interface CSBookingTimeSelectedAlert : UIView
@property (nonatomic, weak)id<CSBookingTimeSelectedAlertDelegte>  delegate;

- (instancetype)initWithDate:(NSDate *)date openTime:(NSDate *)openTime closeTime:(NSDate *)closeTime;
- (void)show;
@end

@protocol CSBookingTimeSelectedAlertDelegte <NSObject>
- (void)bookingTimeSelectedAlert:(CSBookingTimeSelectedAlert *)alert didSelectDate:(NSDate *)date duration:(NSInteger)duration;
@end