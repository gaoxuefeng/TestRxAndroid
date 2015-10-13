//
//  CSSendDoodleViewController.h
//  CloudSong
//
//  Created by sen on 15/6/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSSendDoodleViewControllerDelegate <NSObject>

- (void)sendDoodleViewControllerDidFinishDoodleImage:(UIImage *)doodleImage;

@end

@interface CSSendDoodleViewController : UIViewController

@property(nonatomic, assign) id<CSSendDoodleViewControllerDelegate> delegate;

@end
