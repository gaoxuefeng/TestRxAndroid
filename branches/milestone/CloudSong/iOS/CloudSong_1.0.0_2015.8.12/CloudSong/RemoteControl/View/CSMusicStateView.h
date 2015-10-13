//
//  CSMusicStateView.h
//  CloudSong
//
//  Created by sen on 15/7/21.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMusicStateView : UIScrollView
@property(nonatomic, copy) NSString *text;
- (void)startAnimation;
@end
