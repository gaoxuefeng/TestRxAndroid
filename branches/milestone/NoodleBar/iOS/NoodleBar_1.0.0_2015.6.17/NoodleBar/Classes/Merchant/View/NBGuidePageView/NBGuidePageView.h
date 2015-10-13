//
//  NBGuidePageView.h
//  NoodleBar
//
//  Created by sen on 15/5/5.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBGuidePageView;
@protocol NBGuidePageViewDelegate <NSObject>

@required
- (void)guidePageView:(NBGuidePageView *)guidePageView exitBtnDidClick:(UIButton *)button;
@end


@interface NBGuidePageView : UIView
@property(nonatomic, weak) id delegate;
@end
