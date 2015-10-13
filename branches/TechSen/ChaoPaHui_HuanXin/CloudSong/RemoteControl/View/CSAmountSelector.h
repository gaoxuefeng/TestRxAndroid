//
//  CSAmountSelector.h
//  CloudSong
//
//  Created by sen on 5/25/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//  数量选择器

#import <UIKit/UIKit.h>

@class CSAmountSelector;

@protocol CSAmountSelectorDelegate <NSObject>

@optional
- (void)amountSelector:(CSAmountSelector *)amountSelector amountDidChange:(NSInteger)amount;
@end

@interface CSAmountSelector : UIView
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, weak) id delegate;
@end
