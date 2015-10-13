//
//  CSAboutUsCell.h
//  CloudSong
//
//  Created by sen on 15/7/4.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Option)();
@interface CSAboutUsCell : UIView
- (instancetype)initWithTitle:(NSString *)title;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, copy) Option option;
@property(nonatomic, assign) BOOL fullWidthDivider;
@end
