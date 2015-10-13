//
//  CSMapPaoPaoView.h
//  CloudSong
//
//  Created by sen on 15/7/27.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMapPaoPaoView : UIView
- (instancetype)initWithKTVName:(NSString *)ktvName address:(NSString *)address;
- (void)addTareget:(id)target action:(SEL)action;
@end
