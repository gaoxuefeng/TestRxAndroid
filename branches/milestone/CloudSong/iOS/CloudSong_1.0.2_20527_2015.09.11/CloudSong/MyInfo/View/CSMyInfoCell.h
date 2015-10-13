//
//  CSMyInfoCell.h
//  CloudSong
//
//  Created by sen on 6/11/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMyInfoCell : UIButton
/**
 *  初始化一个CSMyInfoCell对象
 *
 *  @param icon     图标
 *  @param title    标题
 *  @param subTitle 副标题
 */
- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle;
@end
