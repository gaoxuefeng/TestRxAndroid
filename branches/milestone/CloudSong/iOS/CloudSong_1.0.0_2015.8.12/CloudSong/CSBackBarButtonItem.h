//
//  CSBackBarButtonItem.h
//  CloudSong
//
//  Created by sen on 15/6/15.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSBackBarButtonItem : UIBarButtonItem

+ (instancetype)backBarButtonItemWithTitle:(NSString *)title;
- (void)addTarget:(id)target action:(SEL)action;

@end
