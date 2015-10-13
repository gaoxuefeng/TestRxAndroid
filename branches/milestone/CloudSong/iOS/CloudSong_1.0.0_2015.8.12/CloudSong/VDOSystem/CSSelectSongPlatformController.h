//
//  CSSelectSongPlatformController.h
//  CloudSong
//
//  Created by youmingtaizi on 6/3/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CSSong;
@class CSRecommendedAlbum;
@class CSSongSelectPlatformView;
@protocol CSSelectSongPlatformControllerDelegate;

@interface CSSelectSongPlatformController : NSObject 
@property (nonatomic, weak)id<CSSelectSongPlatformControllerDelegate> delegate;
@property (nonatomic, strong, readonly)CSSongSelectPlatformView*  platformView;
- (void)refreshData;
@end

@protocol CSSelectSongPlatformControllerDelegate <NSObject>
- (void)selectSongPlatformControllerDidBeginSearach:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformControllerDidPressSingerButton:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformControllerDidPressLanguageButton:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformControllerDidPressCategoryButton:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformControllerDidPressNewSongButton:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformControllerDidPressHotListButton:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformControllerDidPressMoreButton:(CSSelectSongPlatformController *)controller;
- (void)selectSongPlatformController:(CSSelectSongPlatformController *)controller didSelectSong:(CSSong *)song;
- (void)selectSongPlatformController:(CSSelectSongPlatformController *)controller didSelectIndexPath:(NSIndexPath *)indexPath Song:(CSSong *)song;//新增
- (void)selectSongPlatformController:(CSSelectSongPlatformController *)controller didSelectAlbum:(CSRecommendedAlbum *)album;
@end