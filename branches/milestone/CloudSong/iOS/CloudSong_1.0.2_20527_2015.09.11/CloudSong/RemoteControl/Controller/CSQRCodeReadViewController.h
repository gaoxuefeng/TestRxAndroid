//
//  CSQRCodeReadViewController.h
//  CloudSong
//
//  Created by sen on 5/29/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSQRCodeReadHttpTool.h"
@class CSQRCodeReadViewController;
@protocol CSQRCodeReadViewControllerDelegate <NSObject>

@optional
- (void)codeReadControllerDidFinishReadWithServerIP:(NSString *)serverIP code:(NSString *)code roomNum:(NSString *)roomNum;
@end

@interface CSQRCodeReadViewController : UIViewController
@property(nonatomic, weak) id<CSQRCodeReadViewControllerDelegate> delegate;
@end
