//
//  CSUserInfoCell.h
//  CloudSong
//
//  Created by sen on 6/22/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSUserInfoCell : UIView
- (instancetype)initWithTitle:(NSString *)title;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *placeHolder;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, weak) UILabel *subTitleLabel;
- (void)addTarget:(id)target action:(SEL)action;
@end
