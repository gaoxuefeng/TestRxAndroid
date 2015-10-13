//
//  CSMyInfoHeaderView.h
//  CloudSong
//
//  Created by sen on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSUserInfoModel.h"
@interface CSMyInfoHeaderView : UIView
@property(nonatomic, weak) UIImageView *backgroundView;
@property(nonatomic, weak) UIView *centerView;
@property(nonatomic, weak) UIImageView *userIcon;
@property(nonatomic, strong) CSUserInfoModel *item;

- (void)loginButtonAddTarget:(id)target action:(SEL)sel;
- (void)personPageButtonAddTarget:(id)target action:(SEL)sel;
@end
