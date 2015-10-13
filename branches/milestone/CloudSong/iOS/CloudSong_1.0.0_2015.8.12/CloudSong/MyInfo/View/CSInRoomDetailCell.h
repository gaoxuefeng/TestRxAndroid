//
//  CSInRoomDetailCell.h
//  CloudSong
//
//  Created by sen on 15/7/1.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSInRoomDetailCell : UIView
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) UIColor *contentColor;
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;
@end
