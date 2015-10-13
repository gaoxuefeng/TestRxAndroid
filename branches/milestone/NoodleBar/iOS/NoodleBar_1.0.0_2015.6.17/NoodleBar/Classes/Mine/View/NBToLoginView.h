//
//  NBToLoginView.h
//  NoodleBar
//
//  Created by sen on 15/4/20.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBToLoginView : UIImageView


@property(nonatomic, copy) NSString *phone;
- (void)toLoginBtnAddTarget:(id)target Action:(SEL)sel;

@end
