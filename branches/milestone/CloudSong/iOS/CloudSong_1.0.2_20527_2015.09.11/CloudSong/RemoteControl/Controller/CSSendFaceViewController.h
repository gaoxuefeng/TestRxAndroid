//
//  CSSendFaceViewController.h
//  CloudSong
//
//  Created by sen on 15/6/30.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSBaseViewController.h"

@protocol CSSendFaceViewControllerDelegate <NSObject>

@optional
- (void)sendFaceViewControllerDidClickWithName:(NSString *)string;

@end


@interface CSSendFaceViewController : CSBaseViewController
@property(nonatomic, weak) id<CSSendFaceViewControllerDelegate> delegate;


@end
