//
//  CSTwoColumnsView.h
//  CloudSong
//
//  Created by youmingtaizi on 4/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSTwoColumnsViewDelegate;

@interface CSTwoColumnsView : UIView
@property (nonatomic, weak)id<CSTwoColumnsViewDelegate> delegate;
@property (nonatomic, assign, readonly)CGFloat              distance;
@property (nonatomic, strong, readonly)NSString*            businessDistrict;

- (void)setData:(NSArray *)data;
- (void)reloadData;
- (void)resetPosition;
- (NSString *)defaultDistrictInCity:(NSString *)city;
@end

@protocol CSTwoColumnsViewDelegate <NSObject>
- (void)twoColumnsView:(CSTwoColumnsView *)view businessDistrict:(NSString *)businessDistrict;
- (void)twoColumnsViewDidHide:(CSTwoColumnsView *)view;
- (void)twoColumnsViewDidClose:(CSTwoColumnsView *)view;

@end