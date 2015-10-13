//
//  CSChatToolBar.h
//  CloudSong
//
//  Created by sen on 15/7/20.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSChatToolBar;

@protocol CSChatToolBarDelegate <NSObject>

- (void)chatToolBarSendButtonPressedWithText:(NSString *)sendText;

- (void)chatToolBarInputTextFieldPressed:(CSChatToolBar *)chatToolBar;

- (void)chatToolBarSpreadButtonPressed;

@end


@interface CSChatToolBar : UIView
@property(nonatomic, weak) id<CSChatToolBarDelegate> delegate;

@end
