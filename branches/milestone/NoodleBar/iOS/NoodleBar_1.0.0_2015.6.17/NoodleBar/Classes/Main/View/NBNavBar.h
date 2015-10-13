//
//  NBNavBar.h
//  NoodleBar
//
//  Created by sen on 15/4/17.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBNavBar : UIView
- (void)setTitle:(NSString *)title;
- (void)backButtonHidden:(BOOL)hidden;
- (void)backButtonAddTarget:(id)target Action:(SEL)sel;
- (void)setTitleView:(UIView *)titleView;
@end
