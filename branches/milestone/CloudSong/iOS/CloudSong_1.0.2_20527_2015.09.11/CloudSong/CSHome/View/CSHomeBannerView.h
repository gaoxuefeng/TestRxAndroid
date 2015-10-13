//
//  CSHomeBannerView.h
//  CloudSong
//
//  Created by EThank on 15/8/18.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSHomeBannerView ;
@protocol HomeBannerViewDelegate <NSObject>
@optional
- (void)homeBannerView:(CSHomeBannerView *)homeBannerView didSelectedAtIndex:(NSInteger )index ;
@end

@interface CSHomeBannerView : UIView

//- (void)setImagesWithURLs:(NSArray *)imageURLs;
@property (nonatomic, strong) NSArray *imageURLs ;
@property (nonatomic, weak) id <HomeBannerViewDelegate> delegate ;

@end
