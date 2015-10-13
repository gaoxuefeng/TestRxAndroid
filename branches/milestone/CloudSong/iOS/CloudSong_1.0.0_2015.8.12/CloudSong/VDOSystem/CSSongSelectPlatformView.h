//
//  CSSongSelectPlatformView.h
//  CloudSong
//
//  Created by youmingtaizi on 7/9/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSSongSelectPlatformViewDelegate;

@interface CSSongSelectPlatformView : UIView
@property (nonatomic, weak)id<CSSongSelectPlatformViewDelegate>  delegate;
- (UITableView *)tableView;
- (void)reloadData;
@end

@protocol CSSongSelectPlatformViewDelegate <NSObject>
- (void)songSelectPlatformViewDidBeginSearch:(CSSongSelectPlatformView *)view;
- (void)songSelectPlatformViewDidPressSingerButton:(CSSongSelectPlatformView *)view;
- (void)songSelectPlatformViewDidPressLanguageButton:(CSSongSelectPlatformView *)view;
- (void)songSelectPlatformViewDidPressCategoryButton:(CSSongSelectPlatformView *)view;
- (void)songSelectPlatformViewDidPressNewSongButton:(CSSongSelectPlatformView *)view;
- (void)songSelectPlatformViewDidPressHotListButton:(CSSongSelectPlatformView *)view;
@end