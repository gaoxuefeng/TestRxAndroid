//
//  CSInputAlertView.h
//  CloudSong
//
//  Created by sen on 15/6/24.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSInputAlertView;
@protocol CSInputAlertViewDelegate <NSObject>

- (void)inputAlertView:(CSInputAlertView *)inputAlertView didInputText:(NSString *)text;

@end
typedef void (^DidInputBlock)(NSString *text);
@interface CSInputAlertView : UIView
@property(nonatomic, assign) NSInteger maxLength;
@property (weak ,nonatomic) UITextField *textField;
@property(nonatomic, copy) DidInputBlock didInputBlock;

@property (weak ,nonatomic) id<CSInputAlertViewDelegate> delegate;



- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content delegate:(id<CSInputAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

- (void)show;
@end
