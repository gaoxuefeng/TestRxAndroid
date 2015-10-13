//
//  CSHomeActivityView.h
//  CloudSong
//
//  Created by EThank on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSDefine.h"

@class CSHomeActivityView  ;

@protocol HomeActivityViewDelegate <NSObject>

@optional
- (void)homeActivityView:(CSHomeActivityView *)homeActivityView didTapViewWithIndex:(NSInteger )index ;

@end

@interface CSHomeActivityView : UIView

@property (nonatomic, weak) id <HomeActivityViewDelegate> delegate ;

@property (nonatomic, strong) NSArray *activityTags ;

@end
