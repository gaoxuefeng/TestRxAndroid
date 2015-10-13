//
//  CSCancelRoomCell.h
//  CloudSong
//
//  Created by sen on 15/6/26.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCancelRoomCell : UIView
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) UIColor *contentColor;


- (instancetype)initWithTitle:(NSString *)title;
@end
