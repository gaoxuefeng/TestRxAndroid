//
//  CSLaunchWindow.h
//  CloudSong
//
//  Created by sen on 8/18/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishAnimation)(BOOL finished);

@interface CSLaunchWindow : UIWindow
@property(copy, nonatomic) finishAnimation finishBlock;

///**
// *  清理所有动画图层
// */
//- (void)clearupAllAnimationLayer ;
@end
