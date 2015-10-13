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
- (void)homeActivityView:(CSHomeActivityView *)homeActivityView didTapViewWithType:(CSHomeActivityType )viewType ;

@end

@interface CSHomeActivityView : UIView

@property (nonatomic, weak) id <HomeActivityViewDelegate> delegate ;
@end
