//
//  RTTimePickerView.h
//  RecordTime
//
//  Created by sen on 8/31/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTTimePickerViewDelegate <NSObject>

@optional
- (void)timePickerDidGetDate:(NSDate *)date;

@end

@interface RTTimePickerView : UIView

@property(weak, nonatomic) id<RTTimePickerViewDelegate> delegate;

- (void)show;

- (void)dismiss;
@end
